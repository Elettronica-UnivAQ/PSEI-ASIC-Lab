// =============================================================================
// gl_tb_template.v — Template testbench Verilog per simulazione gate-level
// =============================================================================
//
// Questo template è il punto di partenza per simulare una netlist gate-level
// generata da LibreLane (file .pnl.v) con Icarus Verilog (iverilog).
//
// DIFFERENZE rispetto a un testbench VHDL comportamentale:
//   1. La netlist è una scatola nera: si accede solo alle porte esterne.
//      Registri interni, stati della FSM e segnali intermedi non sono visibili.
//   2. Le porte di alimentazione VPWR e VGND sono esplicite nella netlist
//      SKY130A e vanno collegate tramite wire (non con letterali diretti,
//      perché sono porte inout).
//   3. Le uscite del DUT vanno dichiarate come wire, non come reg.
//   4. Il modello del comparatore (o di qualsiasi blocco esterno) va scritto
//      in Verilog con always @(*) invece del process VHDL.
//
// COME USARE QUESTO TEMPLATE:
//   1. Copia questo file in gl/<tuo_design>_gl_tb.v
//   2. Segui i passi marcati con [PASSO N] nell'ordine indicato
//   3. Lancia: make lint_gl  → verifica sintattica
//              make sim_gl   → simulazione
//              make wave_gl  → GTKWave
//
// =============================================================================

`timescale 1ns / 1ps

// =============================================================================
// [PASSO 1] Rinomina il modulo con il nome del tuo testbench.
//           Convenzione: <nome_design>_tb
//           Esempio:    sar_controller_tb
// =============================================================================
module nome_design_tb;

// =============================================================================
// [PASSO 2] Dichiara i parametri temporali.
//           CLK_PERIOD in nanosecondi (es. 50.0 = 20 MHz, 10.0 = 100 MHz).
// =============================================================================
localparam real CLK_PERIOD = 50.0;  // ns  ← modifica qui

// =============================================================================
// [PASSO 3] Dichiara i segnali di ingresso al DUT come reg,
//           e i segnali di uscita come wire.
//
//           REGOLA:
//             - Ingressi al DUT  → reg   (il testbench li guida)
//             - Uscite del DUT   → wire  (guidate dal modulo)
//             - Segnali bidirezionali → wire
//
//           Non dichiarare VPWR e VGND qui — sono già definiti sotto.
// =============================================================================

// Ingressi al DUT
reg        clk    = 1'b0;   // clock — inizializzato a 0
reg        rst_n  = 1'b0;   // reset attivo basso — inizializzato in reset

// Uscite del DUT (wire — guidate dal modulo)
// wire       uscita_1;
// wire [N:0] uscita_bus;

// Segnali ausiliari per i stimoli
// reg [31:0] parametro_test = 0;

// =============================================================================
// [PASSO 4] Wire per le porte di alimentazione.
//           Nella netlist SKY130A (.pnl.v) VPWR e VGND sono porte inout.
//           Non si possono connettere a letterali (1'b1, 1'b0) direttamente
//           su porte inout — occorrono wire con assegnazione continua.
//           NON MODIFICARE queste due righe.
// =============================================================================
wire VPWR = 1'b1;
wire VGND = 1'b0;

// =============================================================================
// [PASSO 5] Istanziazione del DUT.
//           Sostituisci "nome_modulo" con il nome del tuo design (deve
//           corrispondere al module name nella netlist .pnl.v).
//           Collega tutte le porte per nome (.nome_porta(segnale)).
//           Aggiungi .VPWR(VPWR) e .VGND(VGND) alla fine.
// =============================================================================
nome_modulo DUT (
    // Ingressi
    .clk        (clk),
    .rst_n      (rst_n),
    // .ingresso_1 (segnale_1),

    // Uscite
    // .uscita_1   (uscita_1),

    // Alimentazione — NON RIMUOVERE
    .VPWR       (VPWR),
    .VGND       (VGND)
);

// =============================================================================
// [PASSO 6] Generazione del clock.
//           Il clock commuta ogni CLK_PERIOD/2 — non modificare la struttura.
//           Modifica solo CLK_PERIOD al Passo 2.
// =============================================================================
initial clk = 1'b0;
always #(CLK_PERIOD / 2.0) clk = ~clk;

// =============================================================================
// [PASSO 7] Dump VCD per GTKWave.
//           Il file viene salvato in sim/dump_gl.vcd (percorso usato dal
//           Makefile). NON MODIFICARE il nome del file.
//           Il secondo argomento di $dumpvars (0) significa: dumpa tutto
//           il design ricorsivamente dal modulo corrente.
// =============================================================================
initial begin
    $dumpfile("sim/dump_gl.vcd");
    $dumpvars(0, nome_design_tb);  // ← aggiorna con il nome del modulo
end

// =============================================================================
// [PASSO 8] Modelli di blocchi esterni (opzionale).
//           Se il tuo design ha ingressi che dipendono da uscite in modo
//           combinatorio (es. un comparatore esterno, un modello di memoria),
//           descrivili qui con always @(*).
//
//           Esempio — comparatore esterno:
//
//           always @(*) begin
//               if (dac_out[0] === 1'b0 || dac_out[0] === 1'b1)
//                   comp_in = (dac_out <= vin_ref) ? 1'b1 : 1'b0;
//               else
//                   comp_in = 1'bx;  // metavalue: ingresso indefinito
//           end
//
//           NOTA sulla guardia metavalue (=== 1'b0 || === 1'b1):
//           All'avvio della simulazione i segnali possono essere X o Z.
//           Usare === invece di == permette di distinguere X/Z da 0/1
//           e di assegnare 1'bx in uscita invece di propagare errori.
// =============================================================================

// always @(*) begin
//     // inserisci qui i modelli combinatori esterni
// end

// =============================================================================
// [PASSO 9] Processo di stimolo.
//           Struttura consigliata:
//             a) Reset iniziale (almeno 2-3 cicli di clock)
//             b) Attesa di sincronizzazione
//             c) Sequenza di test con verifica dei risultati
//             d) $finish per terminare la simulazione
//
//           ATTENZIONE ai metavalue all'avvio: durante il reset i segnali
//           di uscita possono essere X. Non fare confronti === su uscite
//           fino a dopo il reset.
//
//           Usa $display per stampare i risultati nel terminale.
//           Formato suggerito:
//             $display("PASS: input=%0d → output=0x%02X", val_in, val_out);
//             $display("FAIL: input=%0d → output=0x%02X (atteso 0x%02X) !!!",
//                       val_in, val_out, atteso);
// =============================================================================
initial begin

    // ------------------------------------------------------------------
    // a) Reset iniziale
    // ------------------------------------------------------------------
    rst_n = 1'b0;
    repeat(3) @(posedge clk);  // mantieni il reset per almeno 3 cicli
    rst_n = 1'b1;
    @(posedge clk);            // un ciclo di sincronizzazione

    // ------------------------------------------------------------------
    // b) Sequenza di test
    //    Inserisci qui i tuoi stimoli. Esempio:
    //
    //    ingresso_A = 8'hAB;
    //    @(posedge clk);
    //    @(posedge segnale_fine_elaborazione);
    //    if (uscita_risultato === valore_atteso)
    //        $display("PASS: ...");
    //    else
    //        $display("FAIL: ...");
    // ------------------------------------------------------------------

    // TODO: inserisci la sequenza di test

    // ------------------------------------------------------------------
    // c) Fine simulazione
    // ------------------------------------------------------------------
    $display("Simulazione gate-level completata.");
    #(CLK_PERIOD * 10);
    $finish;

end

endmodule

// =============================================================================
// CHECKLIST prima di simulare:
//   [ ] Nome modulo aggiornato (Passo 1 e $dumpvars al Passo 7)
//   [ ] CLK_PERIOD corretto (Passo 2)
//   [ ] Tutti i segnali dichiarati: reg per ingressi, wire per uscite (Passo 3)
//   [ ] DUT istanziato con tutte le porte collegate, incluse VPWR e VGND (Passo 5)
//   [ ] Modelli esterni scritti con always @(*) se necessario (Passo 8)
//   [ ] Reset iniziale presente prima dei test (Passo 9a)
//   [ ] $finish alla fine del processo di stimolo (Passo 9c)
// =============================================================================
