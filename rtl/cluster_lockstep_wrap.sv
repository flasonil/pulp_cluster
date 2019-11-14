
// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

/*
 * cluster_timer_wrap.sv
 * Davide Rossi <davide.rossi@unibo.it>
 * Antonio Pullini <pullinia@iis.ee.ethz.ch>
 * Igor Loi <igor.loi@unibo.it>
 * Francesco Conti <fconti@iis.ee.ethz.ch>
 */

module cluster_lockstep_wrap
   (
    input  logic          clk_i,
    input  logic          rst_ni,
    input  logic          ref_clk_i,
    
    XBAR_PERIPH_BUS.Slave speriph_slave
    );
   
   lockstep_unit
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
