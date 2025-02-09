module periphery 
#(
    parameter int   APB_AW          = 32,
                    APB_DW          = 32,
                    PERIPH_BA       = 0, // periphery base address
                    EF_TCC32_QTY    = 1,
                    RTC_QTY         = 1

) (
    // apb slave intf
    input  logic pclk            ,
    input  logic prst_n          ,

    APB.Slave    s_apb           ,
    // block specific inputs
    input  logic ef_tcc32_ext_clk,

    // outputs
    output logic ef_tcc32_irq    ,
    output logic ef_tcc32_pwm    ,
    output logic rtc_irq         
);

localparam EF_TCC32_IDX = 0                           ;
localparam RTC_IDX      = EF_TCC32_IDX  + EF_TCC32_QTY;
localparam SLAVES_QTY   = RTC_IDX       + RTC_QTY     ;

localparam EF_TCC32_REGS_QTY = 1024; // 1024 - 963 = 61 reserved
localparam RTC_REGS_QTY      = 16  ; // 16 - 13 = 3 reserved

// slave address map rule
typedef struct packed {
    int unsigned        idx;
    logic [APB_AW-1:0]  start_addr;
    logic [APB_AW-1:0]  end_addr;
} rule_t;

typedef logic [APB_AW - 1:0] addr_t;
typedef rule_t [SLAVES_QTY - 1:0] addr_map_t;

function addr_map_t get_addr_map();
    addr_map_t addr_map;

    for (int i = 0; i < EF_TCC32_QTY; i++) begin
        addr_map[i] = rule_t'{
            idx:        unsigned'(i),
            start_addr: PERIPH_BA + ( i    * EF_TCC32_REGS_QTY * 4),
            end_addr:   PERIPH_BA + ((i+1) * EF_TCC32_REGS_QTY * 4)
        };
    end

    for (int i = EF_TCC32_QTY; i < (EF_TCC32_QTY + RTC_QTY); i++) begin
        addr_map[i] = rule_t'{
            idx:        unsigned'(i),
            start_addr: PERIPH_BA + ( i    * RTC_REGS_QTY * 4),
            end_addr:   PERIPH_BA + ((i+1) * RTC_REGS_QTY * 4)
        };
    end

    return addr_map;
endfunction : get_addr_map

addr_map_t periph_addr_map = get_addr_map();

APB #(.ADDR_WIDTH(APB_AW), .DATA_WIDTH(APB_DW)) s_apb_selected[SLAVES_QTY - 1:0]();

localparam SLV_SEL_W = cf_math_pkg::idx_width(SLAVES_QTY);
logic [SLV_SEL_W - 1:0] periph_slv_sel;
logic                   periph_addr_valid;

addr_decode #(
    .NoIndices(SLAVES_QTY),
    .NoRules  (SLAVES_QTY),
    .addr_t   (addr_t    ),
    .rule_t   (rule_t    )
) i_addr_decode (
    .addr_i          (s_apb.paddr      ),
    .addr_map_i      (periph_addr_map  ),
    .idx_o           (periph_slv_sel   ),
    .dec_valid_o     (periph_addr_valid), // TODO: clarify whether we need to do smth in case of false address
    .dec_error_o     (/*not used*/     ),
    .en_default_idx_i('0               ),
    .default_idx_i   ('0               )
);

apb_demux_intf #(
    .APB_ADDR_WIDTH(APB_AW    ),
    .APB_DATA_WIDTH(APB_DW    ),
    .NoMstPorts    (SLAVES_QTY)
) i_apb_demux_intf (
    .slv     (s_apb                ),
    .mst     (s_apb_selected.Master),
    .select_i(periph_slv_sel       )
);


EF_TCC32_apb #(.APB_ADDR_W(APB_AW)) i_EF_TCC32_apb (
    .ext_clk  (ef_tcc32_ext_clk            ),
    .PCLK     (pclk                        ),
    .PRESETn  (prst_n                      ),
    .irq      (ef_tcc32_irq                ),
    .gpio_pwm (ef_tcc32_pwm                ),
    .apb_slave(s_apb_selected[EF_TCC32_IDX])
);


rtc_apb #(.APB_ADDR_W(APB_AW)) i_rtc_apb (
    .pclk  (pclk                         ),
    .prst_n(prst_n                       ),
    .irq   (rtc_irq                      ),
    .s_apb (s_apb_selected[RTC_IDX].Slave)
);



endmodule : periphery