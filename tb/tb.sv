module tb;

logic pclk;
logic prst_n;
APB s_apb();
logic ef_tcc32_ext_clk;
logic ef_tcc32_irq;
logic ef_tcc32_pwm;
logic rtc_irq;

periphery #(.APB_AW(32), .APB_DW(32), .PERIPH_BA(0), .EF_TCC32_QTY(1), .RTC_QTY(1)) i_periphery (
    .pclk            (pclk            ),
    .prst_n          (prst_n          ),
    .s_apb           (s_apb           ),
    .ef_tcc32_ext_clk(ef_tcc32_ext_clk),
    .ef_tcc32_irq    (ef_tcc32_irq    ),
    .ef_tcc32_pwm    (ef_tcc32_pwm    ),
    .rtc_irq         (rtc_irq         )
);

initial begin
    pclk = 0;
    forever begin
        #1 pclk = ~pclk;
    end
end

initial begin
    prst_n <= 1;
    repeat (2) @ (posedge pclk);
    prst_n <= 0;
    repeat (2) @ (posedge pclk);
    prst_n <= 1;
end

initial begin
    #20;
    $display(">>>> Elaborated successfuly");
    $finish;
end

endmodule : tb