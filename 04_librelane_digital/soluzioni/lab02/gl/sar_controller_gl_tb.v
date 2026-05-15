// =============================================================================
// sar_controller_gl_tb.v — Testbench gate-level per sar_controller
// =============================================================================
//
// Questo file è l'esempio di riferimento per la simulazione gate-level del
// SAR controller. Segue la stessa struttura del template gl_tb_template.v,
// con tutte le sezioni già compilate per il design specifico.
//
// Usalo come guida per adattare il template a un design diverso:
// ogni sezione è commentata con il riferimento al passo corrispondente
// del template ([PASSO N]).
//
// Procedura di switching monotonica (Liu et al., JSSC 2010):
//   Il modello del comparatore calcola il differenziale effettivo tra le
//   due top plate del CDAC differenziale:
//     V_diff_eff = (2*vin_code - 255) - (to_integer(dac_p) - to_integer(dac_n))
//   out_comp_p='1' se V_diff_eff > 0 (VOUTP > VOUTN → bit=1)
//   out_comp_p='0' se V_diff_eff < 0 (VOUTP < VOUTN → bit=0)
//
// Codici di test e risultati attesi:
//   vin_code =   0 → dout = 0x00   (minimo)
//   vin_code =  64 → dout = 0x40
//   vin_code = 128 → dout = 0x80   (metascala)
//   vin_code = 192 → dout = 0xC0
//   vin_code = 200 → dout = 0xC8
//   vin_code = 255 → dout = 0xFF   (massimo)
//
// Uso:
//   make setup_gl   → copia la netlist in gl/ con define SKY130A embedded
//   make lint_gl    → verifica sintattica con Verible
//   make sim_gl     → compilazione iverilog + simulazione
//   make wave_gl    → apre GTKWave con sim/dump_gl.vcd
// =============================================================================

`timescale 1ns / 1ps

// =============================================================================
// [PASSO 1] Nome del modulo: <nome_design>_tb
// =============================================================================
module sar_controller_tb;

// =============================================================================
// [PASSO 2] Parametri temporali
// CLK_PERIOD = 50.0 ns → clock a 20 MHz (fs_SAR del corso)
// =============================================================================
localparam real CLK_PERIOD = 50.0;  // ns

// Codici di ingresso da convertire (in unità di LSB = 1 mV)
localparam integer VIN_0 = 0;
localparam integer VIN_1 = 64;
localparam integer VIN_2 = 128;
localparam integer VIN_3 = 192;
localparam integer VIN_4 = 200;
localparam integer VIN_5 = 255;

// =============================================================================
// [PASSO 3] Dichiarazione dei segnali
//   - Ingressi al DUT  → reg   (il testbench li guida)
//   - Uscite del DUT   → wire  (guidate dal modulo)
// =============================================================================

// Ingressi al DUT
reg        clk        = 1'b0;
reg        rst_n      = 1'b0;
reg        comp_out_p = 1'b0;   // uscita positiva comparatore (ingresso per il DUT)
reg        comp_out_n = 1'b1;   // uscita negativa comparatore (ingresso per il DUT)

// Uscite del DUT (wire — guidate dal modulo)
wire       phi_sample;
wire       phi_sample_n;
wire       clk_comp;
wire [7:0] dac_p;
wire [7:0] dac_n;
wire [7:0] dout;
wire       eoc;

// Segnale ausiliario per il modello del comparatore
integer    vin_code = 0;

// =============================================================================
// [PASSO 4] Wire per le porte di alimentazione
// VPWR e VGND sono porte inout nella netlist SKY130A — non si possono
// connettere a letterali diretti su porte inout: servono wire con
// assegnazione continua.
// =============================================================================
wire VPWR = 1'b1;
wire VGND = 1'b0;

// =============================================================================
// [PASSO 5] Istanziazione del DUT
// Tutte le porte collegate per nome, incluse VPWR e VGND.
// =============================================================================
sar_controller DUT (
    // Ingressi
    .clk          (clk),
    .rst_n        (rst_n),
    .out_comp_p   (comp_out_p),
    .out_comp_n   (comp_out_n),

    // Uscite
    .phi_sample   (phi_sample),
    .phi_sample_n (phi_sample_n),
    .clk_comp     (clk_comp),
    .dac_p        (dac_p),
    .dac_n        (dac_n),
    .dout         (dout),
    .eoc          (eoc),

    // Alimentazione — NON RIMUOVERE
    .VPWR         (VPWR),
    .VGND         (VGND)
);

// =============================================================================
// [PASSO 6] Generazione del clock
// Il clock commuta ogni CLK_PERIOD/2 ns.
// =============================================================================
initial clk = 1'b0;
always #(CLK_PERIOD / 2.0) clk = ~clk;

// =============================================================================
// [PASSO 7] Dump VCD per GTKWave
// Il file viene salvato in sim/dump_gl.vcd — path usato dal Makefile.
// $dumpvars(0, ...) dumpa ricorsivamente tutto il design.
// =============================================================================
initial begin
    $dumpfile("sim/dump_gl.vcd");
    $dumpvars(0, sar_controller_tb);
end

// =============================================================================
// [PASSO 8] Modello del comparatore Strong-ARM (blocco esterno)
//
// Il comparatore è un blocco analogico — non fa parte della netlist digitale.
// Lo modelliamo in Verilog con always @(*) (processo combinatorio).
//
// Procedura di switching monotonica: entrambi i rami del CDAC partono da
// Vref (dac_p=dac_n=255) e si abbassano unilateralmente a ogni bit.
// Il differenziale effettivo tra le top plate evolve come:
//   V_diff_eff = (2*vin_code - 255) - (dac_p_int - dac_n_int)
//
// out_comp_p='1' se V_diff_eff > 0  (VOUTP > VOUTN → bit=1)
// out_comp_p='0' se V_diff_eff <= 0 (VOUTP < VOUTN → bit=0)
// out_comp_n è sempre il complemento di out_comp_p.
//
// Guardia metavalue (===): prima del reset dac_p e dac_n sono 'x'.
// Usare === invece di == permette di distinguere x/z da 0/1 ed evitare
// propagazione di metavalue nel modello.
// =============================================================================
integer dac_p_int, dac_n_int;

always @(*) begin
    if (dac_p[0] === 1'b0 || dac_p[0] === 1'b1) begin
        dac_p_int = dac_p;
        dac_n_int = dac_n;
        if ((2*vin_code - 255) > (dac_p_int - dac_n_int)) begin
            comp_out_p = #1 1'b1;
            comp_out_n = #1 1'b0;
        end else begin
            comp_out_p = #1 1'b0;
            comp_out_n = #1 1'b1;
        end
    end
end

// =============================================================================
// [PASSO 9] Processo di stimolo e verifica
//
// Struttura:
//   a) Reset iniziale (3 cicli di clock)
//   b) 6 conversioni con codici di test diversi
//   c) Verifica PASS/FAIL per ogni conversione
//   d) $finish
// =============================================================================
integer n_pass, n_fail;

initial begin
    n_pass = 0;
    n_fail = 0;

    // ------------------------------------------------------------------
    // a) Reset iniziale
    // ------------------------------------------------------------------
    rst_n = 1'b0;
    repeat(3) @(posedge clk);
    rst_n = 1'b1;
    @(posedge clk);

    // ------------------------------------------------------------------
    // b) Sequenza di conversioni
    // Per ogni codice: imposta vin_code, attendi EOC, verifica dout.
    // ------------------------------------------------------------------

    // Conversione 1: vin = 0 (minimo)
    vin_code = VIN_0;
    @(posedge eoc); @(posedge clk);
    if (dout === VIN_0) begin
        $display("PASS: vin=%0d -> dout=0x%02X", VIN_0, dout);
        n_pass = n_pass + 1;
    end else begin
        $display("FAIL: vin=%0d -> dout=0x%02X (atteso 0x%02X) !!!", VIN_0, dout, VIN_0);
        n_fail = n_fail + 1;
    end

    // Conversione 2: vin = 64
    vin_code = VIN_1;
    @(posedge eoc); @(posedge clk);
    if (dout === VIN_1) begin
        $display("PASS: vin=%0d -> dout=0x%02X", VIN_1, dout);
        n_pass = n_pass + 1;
    end else begin
        $display("FAIL: vin=%0d -> dout=0x%02X (atteso 0x%02X) !!!", VIN_1, dout, VIN_1);
        n_fail = n_fail + 1;
    end

    // Conversione 3: vin = 128 (metascala)
    vin_code = VIN_2;
    @(posedge eoc); @(posedge clk);
    if (dout === VIN_2) begin
        $display("PASS: vin=%0d -> dout=0x%02X", VIN_2, dout);
        n_pass = n_pass + 1;
    end else begin
        $display("FAIL: vin=%0d -> dout=0x%02X (atteso 0x%02X) !!!", VIN_2, dout, VIN_2);
        n_fail = n_fail + 1;
    end

    // Conversione 4: vin = 192
    vin_code = VIN_3;
    @(posedge eoc); @(posedge clk);
    if (dout === VIN_3) begin
        $display("PASS: vin=%0d -> dout=0x%02X", VIN_3, dout);
        n_pass = n_pass + 1;
    end else begin
        $display("FAIL: vin=%0d -> dout=0x%02X (atteso 0x%02X) !!!", VIN_3, dout, VIN_3);
        n_fail = n_fail + 1;
    end

    // Conversione 5: vin = 200
    vin_code = VIN_4;
    @(posedge eoc); @(posedge clk);
    if (dout === VIN_4) begin
        $display("PASS: vin=%0d -> dout=0x%02X", VIN_4, dout);
        n_pass = n_pass + 1;
    end else begin
        $display("FAIL: vin=%0d -> dout=0x%02X (atteso 0x%02X) !!!", VIN_4, dout, VIN_4);
        n_fail = n_fail + 1;
    end

    // Conversione 6: vin = 255 (massimo)
    vin_code = VIN_5;
    @(posedge eoc); @(posedge clk);
    if (dout === VIN_5) begin
        $display("PASS: vin=%0d -> dout=0x%02X", VIN_5, dout);
        n_pass = n_pass + 1;
    end else begin
        $display("FAIL: vin=%0d -> dout=0x%02X (atteso 0x%02X) !!!", VIN_5, dout, VIN_5);
        n_fail = n_fail + 1;
    end

    // ------------------------------------------------------------------
    // c) Riepilogo e fine simulazione
    // ------------------------------------------------------------------
    $display("Simulazione gate-level completata: %0d PASS, %0d FAIL",
             n_pass, n_fail);
    #(CLK_PERIOD * 5);
    $finish;
end

endmodule

// =============================================================================
// CHECKLIST prima di simulare:
//   [x] Nome modulo: sar_controller_tb                     (Passo 1)
//   [x] CLK_PERIOD = 50.0 ns (20 MHz)                     (Passo 2)
//   [x] Ingressi come reg, uscite come wire                (Passo 3)
//   [x] wire VPWR = 1'b1 e wire VGND = 1'b0               (Passo 4)
//   [x] DUT istanziato con tutte le porte + VPWR/VGND      (Passo 5)
//   [x] Clock generato con always #(CLK_PERIOD/2.0)        (Passo 6)
//   [x] $dumpfile("sim/dump_gl.vcd") configurato           (Passo 7)
//   [x] Modello comparatore con always @(*) e guardia ===  (Passo 8)
//   [x] Reset + 6 conversioni + verifica PASS/FAIL         (Passo 9)
// =============================================================================
