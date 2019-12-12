module lockstep_unit_wrap
  (
   input logic clk_i,
   input logic rst_ni,
   input logic lockstep_mode,
               
   XBAR_TCDM_BUS.Slave lockstep2core[11:0],
   XBAR_TCDM_BUS.Master lockstep2interconnect[11:0]
   );

   logic [31:0] rdata_i[8],rdata_o[8];
   logic        req_i[8],gnt_i[8],req_o[8],gnt_o[8],rvalid_i[8],rvalid_o[8];
   
    
   generate
      for(genvar i=0; i<8; i++)
        begin:BUS_BIND_CORES
           
           assign lockstep2interconnect[i].add        = lockstep2core[i].add;
           assign lockstep2interconnect[i].req        = (lockstep_mode)?req_o[i]:lockstep2core[i].req;
           assign lockstep2interconnect[i].wdata      = lockstep2core[i].wdata;
           assign lockstep2interconnect[i].wen        = lockstep2core[i].wen;
           assign lockstep2interconnect[i].be         = lockstep2core[i].be;
           
           assign lockstep2core[i].gnt                = (lockstep_mode)?gnt_o[i]:lockstep2interconnect[i].gnt;
           assign lockstep2core[i].r_valid            = (lockstep_mode)?rvalid_o[i]:lockstep2interconnect[i].r_valid;
           assign lockstep2core[i].r_rdata            = (lockstep_mode)?rdata_o[i]:lockstep2interconnect[i].r_rdata;
           
        end // block: BUS_BIND_CORES
   endgenerate
   
   generate
      for(genvar j=8; j<12; j++)
        begin:BUS_BIND_HWPE
           
           assign lockstep2interconnect[j].add = lockstep2core[j].add;
           assign lockstep2interconnect[j].req = lockstep2core[j].req;
           assign lockstep2interconnect[j].wdata = lockstep2core[j].wdata;
           assign lockstep2interconnect[j].wen = lockstep2core[j].wen;
           assign lockstep2interconnect[j].be = lockstep2core[j].be;
           
           assign lockstep2core[j].gnt = lockstep2interconnect[j].gnt;
           assign lockstep2core[j].r_valid = lockstep2interconnect[j].r_valid;
           assign lockstep2core[j].r_rdata = lockstep2interconnect[j].r_rdata;

        end // block: BUS_BIND_HWPE
   endgenerate

	/*always_comb begin
		if(lockstep_mode)begin
			lockstep2core[0].gnt = gnt_o[0];
			lockstep2core[1].gnt = gnt_o[1];
			lockstep2core[2].gnt = gnt_o[2];
			lockstep2core[3].gnt = gnt_o[3];
			lockstep2core[4].gnt = gnt_o[4];
			lockstep2core[5].gnt = gnt_o[5];
			lockstep2core[6].gnt = gnt_o[6];
			lockstep2core[7].gnt = gnt_o[7];

			lockstep2interconnect[0].req = req_o[0];
			lockstep2interconnect[1].req = req_o[1];
			lockstep2interconnect[2].req = req_o[2];
			lockstep2interconnect[3].req = req_o[3];
			lockstep2interconnect[4].req = req_o[4];
			lockstep2interconnect[5].req = req_o[5];
			lockstep2interconnect[6].req = req_o[6];
			lockstep2interconnect[7].req = req_o[7];

			lockstep2core[0].r_valid = rvalid_o[0];
			lockstep2core[1].r_valid = rvalid_o[1];
			lockstep2core[2].r_valid = rvalid_o[2];
			lockstep2core[3].r_valid = rvalid_o[3];
			lockstep2core[4].r_valid = rvalid_o[4];
			lockstep2core[5].r_valid = rvalid_o[5];
			lockstep2core[6].r_valid = rvalid_o[6];
			lockstep2core[7].r_valid = rvalid_o[7];

			lockstep2core[0].r_rdata = rdata_o[0];
			lockstep2core[1].r_rdata = rdata_o[1];
			lockstep2core[2].r_rdata = rdata_o[2];
			lockstep2core[3].r_rdata = rdata_o[3];
			lockstep2core[4].r_rdata = rdata_o[4];
			lockstep2core[5].r_rdata = rdata_o[5];
			lockstep2core[6].r_rdata = rdata_o[6];
			lockstep2core[7].r_rdata = rdata_o[7];
		end else begin
			lockstep2interconnect[0].req = lockstep2core[0].req;
			lockstep2interconnect[0].req = lockstep2core[0].req;
			lockstep2interconnect[0].req = lockstep2core[0].req;
			lockstep2interconnect[0].req = lockstep2core[0].req;
			lockstep2interconnect[0].req = lockstep2core[0].req;
			lockstep2interconnect[0].req = lockstep2core[0].req;
			lockstep2interconnect[0].req = lockstep2core[0].req;
			lockstep2interconnect[0].req = lockstep2core[0].req;

			lockstep2core[0].gnt = lockstep2interconnect[0].gnt;
			lockstep2core[1].gnt = lockstep2interconnect[1].gnt;
			lockstep2core[2].gnt = lockstep2interconnect[2].gnt;
			lockstep2core[3].gnt = lockstep2interconnect[3].gnt;
			lockstep2core[4].gnt = lockstep2interconnect[4].gnt;
			lockstep2core[5].gnt = lockstep2interconnect[5].gnt;
			lockstep2core[6].gnt = lockstep2interconnect[6].gnt;
			lockstep2core[7].gnt = lockstep2interconnect[7].gnt;

			lockstep2core[0].r_valid = lockstep2interconnect[0].r_valid;
			lockstep2core[1].r_valid = lockstep2interconnect[1].r_valid;
			lockstep2core[2].r_valid = lockstep2interconnect[2].r_valid;
			lockstep2core[3].r_valid = lockstep2interconnect[3].r_valid;
			lockstep2core[4].r_valid = lockstep2interconnect[4].r_valid;
			lockstep2core[5].r_valid = lockstep2interconnect[5].r_valid;
			lockstep2core[6].r_valid = lockstep2interconnect[6].r_valid;
			lockstep2core[7].r_valid = lockstep2interconnect[7].r_valid;

			lockstep2core[0].r_rdata = lockstep2interconnect[0].r_rdata;
			lockstep2core[1].r_rdata = lockstep2interconnect[1].r_rdata;
			lockstep2core[2].r_rdata = lockstep2interconnect[2].r_rdata;
			lockstep2core[3].r_rdata = lockstep2interconnect[3].r_rdata;
			lockstep2core[4].r_rdata = lockstep2interconnect[4].r_rdata;
			lockstep2core[5].r_rdata = lockstep2interconnect[5].r_rdata;
			lockstep2core[6].r_rdata = lockstep2interconnect[6].r_rdata;
			lockstep2core[7].r_rdata = lockstep2interconnect[7].r_rdata;
		end
	end*/
      
   lockstep lockstep_i
     (
      .clk_i(clk_i),
      .rst_ni(rst_ni),
		.lockstep_mode(lockstep_mode),

      .gnt_i0(lockstep2interconnect[0].gnt),
      .gnt_i1(lockstep2interconnect[1].gnt),
      .gnt_i2(lockstep2interconnect[2].gnt),
      .gnt_i3(lockstep2interconnect[3].gnt),
      .gnt_i4(lockstep2interconnect[4].gnt),
      .gnt_i5(lockstep2interconnect[5].gnt),
      .gnt_i6(lockstep2interconnect[6].gnt),
      .gnt_i7(lockstep2interconnect[7].gnt),
      .gnt_o0(gnt_o[0]),//lockstep2core[0].gnt),
      .gnt_o1(gnt_o[1]),//lockstep2core[1].gnt),
      .gnt_o2(gnt_o[2]),//lockstep2core[2].gnt),
      .gnt_o3(gnt_o[3]),//lockstep2core[3].gnt),
      .gnt_o4(gnt_o[4]),//lockstep2core[4].gnt),
      .gnt_o5(gnt_o[5]),//lockstep2core[5].gnt),
      .gnt_o6(gnt_o[6]),//lockstep2core[6].gnt),
      .gnt_o7(gnt_o[7]),//lockstep2core[7].gnt),

      .req_i0(lockstep2core[0].req),
      .req_i1(lockstep2core[1].req),
      .req_i2(lockstep2core[2].req),
      .req_i3(lockstep2core[3].req),
      .req_i4(lockstep2core[4].req),
      .req_i5(lockstep2core[5].req),
      .req_i6(lockstep2core[6].req),
      .req_i7(lockstep2core[7].req),
      .req_o0(req_o[0]),//lockstep2interconnect[0].req),
      .req_o1(req_o[1]),//lockstep2interconnect[1].req),
      .req_o2(req_o[2]),//lockstep2interconnect[2].req),
      .req_o3(req_o[3]),//lockstep2interconnect[3].req),
      .req_o4(req_o[4]),//lockstep2interconnect[4].req),
      .req_o5(req_o[5]),//lockstep2interconnect[5].req),
      .req_o6(req_o[6]),//lockstep2interconnect[6].req),
      .req_o7(req_o[7]),//lockstep2interconnect[7].req),
      
      .rvalid_i0(lockstep2interconnect[0].r_valid),
      .rvalid_i1(lockstep2interconnect[1].r_valid),
      .rvalid_i2(lockstep2interconnect[2].r_valid),
      .rvalid_i3(lockstep2interconnect[3].r_valid),
      .rvalid_i4(lockstep2interconnect[4].r_valid),
      .rvalid_i5(lockstep2interconnect[5].r_valid),
      .rvalid_i6(lockstep2interconnect[6].r_valid),
      .rvalid_i7(lockstep2interconnect[7].r_valid),
      .rvalid_o0(rvalid_o[0]),//lockstep2core[0].r_valid),
      .rvalid_o1(rvalid_o[1]),//lockstep2core[1].r_valid),
      .rvalid_o2(rvalid_o[2]),//lockstep2core[2].r_valid),
      .rvalid_o3(rvalid_o[3]),//lockstep2core[3].r_valid),
      .rvalid_o4(rvalid_o[4]),//lockstep2core[4].r_valid),
      .rvalid_o5(rvalid_o[5]),//lockstep2core[5].r_valid),
      .rvalid_o6(rvalid_o[6]),//lockstep2core[6].r_valid),
      .rvalid_o7(rvalid_o[7]),//lockstep2core[7].r_valid),
      
      .rdata_i0(lockstep2interconnect[0].r_rdata),
      .rdata_i1(lockstep2interconnect[1].r_rdata),
      .rdata_i2(lockstep2interconnect[2].r_rdata),
      .rdata_i3(lockstep2interconnect[3].r_rdata),
      .rdata_i4(lockstep2interconnect[4].r_rdata),
      .rdata_i5(lockstep2interconnect[5].r_rdata),
      .rdata_i6(lockstep2interconnect[6].r_rdata),
      .rdata_i7(lockstep2interconnect[7].r_rdata),
      .rdata_o0(rdata_o[0]),//lockstep2core[0].r_rdata),
      .rdata_o1(rdata_o[1]),//lockstep2core[1].r_rdata),
      .rdata_o2(rdata_o[2]),//lockstep2core[2].r_rdata),
      .rdata_o3(rdata_o[3]),//lockstep2core[3].r_rdata),
      .rdata_o4(rdata_o[4]),//lockstep2core[4].r_rdata),
      .rdata_o5(rdata_o[5]),//lockstep2core[5].r_rdata),
      .rdata_o6(rdata_o[6]),//lockstep2core[6].r_rdata),
      .rdata_o7(rdata_o[7])//lockstep2core[7].r_rdata)
      );
   
      
endmodule // lockstep_wrap


   
