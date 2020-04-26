module lockstep_ctrl_wrap
  #(
    parameter ID_WIDTH  = 2
    )
   (
    input  logic          clk_i,
    input  logic          rst_ni,

    XBAR_PERIPH_BUS.Slave speriph_slave[7:0],
    output logic lockstep_mode_if,
    output logic lockstep_mode_id
    );

   lockstep_ctrl
     #(
       .ID_WIDTH        ( ID_WIDTH             )
       )

   lockstep_ctrl_i
     (
      .clk_i            ( clk_i                ),
      .rst_ni           ( rst_ni               ),


      .add_i            ( speriph_slave[0].add     ),
      .wen_i            ( speriph_slave[0].wen     ),
      .wdata_i          ( speriph_slave[0].wdata   ),
      .be_i             ( speriph_slave[0].be      ),

			.req_i0            ( speriph_slave[0].req     ),
			.req_i1            ( speriph_slave[1].req     ),
			.req_i2            ( speriph_slave[2].req     ),
			.req_i3            ( speriph_slave[3].req     ),
			.req_i4            ( speriph_slave[4].req     ),
			.req_i5            ( speriph_slave[5].req     ),
			.req_i6            ( speriph_slave[6].req     ),
			.req_i7            ( speriph_slave[7].req     ),

      .id_i0             ( speriph_slave[0].id      ),
      .id_i1             ( speriph_slave[1].id      ),
      .id_i2             ( speriph_slave[2].id      ),
      .id_i3             ( speriph_slave[3].id      ),
      .id_i4             ( speriph_slave[4].id      ),
      .id_i5             ( speriph_slave[5].id      ),
      .id_i6             ( speriph_slave[6].id      ),
      .id_i7             ( speriph_slave[7].id      ),

      .gnt_o0            ( speriph_slave[0].gnt     ),
      .gnt_o1            ( speriph_slave[1].gnt     ),
      .gnt_o2            ( speriph_slave[2].gnt     ),
      .gnt_o3            ( speriph_slave[3].gnt     ),
      .gnt_o4            ( speriph_slave[4].gnt     ),
      .gnt_o5            ( speriph_slave[5].gnt     ),
      .gnt_o6            ( speriph_slave[6].gnt     ),
      .gnt_o7            ( speriph_slave[7].gnt     ),

      .r_valid_o0        ( speriph_slave[0].r_valid ),
      .r_valid_o1        ( speriph_slave[1].r_valid ),
      .r_valid_o2        ( speriph_slave[2].r_valid ),
      .r_valid_o3        ( speriph_slave[3].r_valid ),
      .r_valid_o4        ( speriph_slave[4].r_valid ),
      .r_valid_o5        ( speriph_slave[5].r_valid ),
      .r_valid_o6        ( speriph_slave[6].r_valid ),
      .r_valid_o7        ( speriph_slave[7].r_valid ),

      .r_opc_o0          ( speriph_slave[0].r_opc   ),
      .r_opc_o1          ( speriph_slave[1].r_opc   ),
      .r_opc_o2          ( speriph_slave[2].r_opc   ),
      .r_opc_o3          ( speriph_slave[3].r_opc   ),
      .r_opc_o4          ( speriph_slave[4].r_opc   ),
      .r_opc_o5          ( speriph_slave[5].r_opc   ),
      .r_opc_o6          ( speriph_slave[6].r_opc   ),
      .r_opc_o7          ( speriph_slave[7].r_opc   ),

      .r_id_o0           ( speriph_slave[0].r_id    ),
      .r_id_o1           ( speriph_slave[1].r_id    ),
      .r_id_o2           ( speriph_slave[2].r_id    ),
      .r_id_o3           ( speriph_slave[3].r_id    ),
      .r_id_o4           ( speriph_slave[4].r_id    ),
      .r_id_o5           ( speriph_slave[5].r_id    ),
      .r_id_o6           ( speriph_slave[6].r_id    ),
      .r_id_o7           ( speriph_slave[7].r_id    ),

      .r_rdata_o0        ( speriph_slave[0].r_rdata ),
      .r_rdata_o1        ( speriph_slave[1].r_rdata ),
      .r_rdata_o2        ( speriph_slave[2].r_rdata ),
      .r_rdata_o3        ( speriph_slave[3].r_rdata ),
      .r_rdata_o4        ( speriph_slave[4].r_rdata ),
      .r_rdata_o5        ( speriph_slave[5].r_rdata ),
      .r_rdata_o6        ( speriph_slave[6].r_rdata ),
      .r_rdata_o7        ( speriph_slave[7].r_rdata ),

      .lockstep_mode_if (lockstep_mode_if),
      .lockstep_mode_id (lockstep_mode_id)
      );

   

endmodule // cluster_lockstep_wrap
