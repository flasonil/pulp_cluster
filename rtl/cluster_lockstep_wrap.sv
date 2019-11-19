module cluster_lockstep_wrap
  #(
    parameter ID_WIDTH  = 2
    )
   (
    input  logic          clk_i,
    input  logic          rst_ni,
    input  logic          ref_clk_i,
    
    XBAR_PERIPH_BUS.Slave speriph_slave
    //XBAR_TCDM_BUS.Master tcdm_data_master
    );
   
   lockstep_unit
     #(
       .ID_WIDTH        ( ID_WIDTH             )
       )
   lockstep_unit_i
     (
      .clk_i            ( clk_i                ),
      .rst_ni           ( rst_ni               ),
      
      .req_i            ( speriph_slave.req     ),
      .addr_i           ( speriph_slave.add     ),
      .wen_i            ( speriph_slave.wen     ),
      .wdata_i          ( speriph_slave.wdata   ),
      .be_i             ( speriph_slave.be      ),
      .id_i             ( speriph_slave.id      ),
      .gnt_o            ( speriph_slave.gnt     ),
      
      .r_valid_o        ( speriph_slave.r_valid ),
      .r_opc_o          ( speriph_slave.r_opc   ),
      .r_id_o           ( speriph_slave.r_id    ),
      .r_rdata_o        ( speriph_slave.r_rdata )
      );
   
endmodule // cluster_lockstep_wrap
