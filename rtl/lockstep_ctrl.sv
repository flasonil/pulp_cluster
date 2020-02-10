module lockstep_ctrl
#(
 parameter ID_WIDTH = 5
)
(
 input logic clk_i,
 input logic rst_ni,

 input logic [31:0] add_i,
 input logic wen_i,
 input logic [31:0] wdata_i,
 input logic [3:0] be_i,

 input logic [ID_WIDTH-1:0] id_i0,
 input logic [ID_WIDTH-1:0] id_i1,
 input logic [ID_WIDTH-1:0] id_i2,
 input logic [ID_WIDTH-1:0] id_i3,
 input logic [ID_WIDTH-1:0] id_i4,
 input logic [ID_WIDTH-1:0] id_i5,
 input logic [ID_WIDTH-1:0] id_i6,
 input logic [ID_WIDTH-1:0] id_i7,
 
 input logic req_i0,
 input logic req_i1,
 input logic req_i2,
 input logic req_i3,
 input logic req_i4,
 input logic req_i5,
 input logic req_i6,
 input logic req_i7,

 output logic gnt_o0,
 output logic gnt_o1,
 output logic gnt_o2,
 output logic gnt_o3,
 output logic gnt_o4,
 output logic gnt_o5,
 output logic gnt_o6,
 output logic gnt_o7,

 output logic r_valid_o0,
 output logic r_valid_o1,
 output logic r_valid_o2,
 output logic r_valid_o3,
 output logic r_valid_o4,
 output logic r_valid_o5,
 output logic r_valid_o6,
 output logic r_valid_o7,

 output logic [31:0] r_rdata_o0,
 output logic [31:0] r_rdata_o1,
 output logic [31:0] r_rdata_o2,
 output logic [31:0] r_rdata_o3,
 output logic [31:0] r_rdata_o4,
 output logic [31:0] r_rdata_o5,
 output logic [31:0] r_rdata_o6,
 output logic [31:0] r_rdata_o7,

 output logic [ID_WIDTH-1:0] r_id_o0,
 output logic [ID_WIDTH-1:0] r_id_o1,
 output logic [ID_WIDTH-1:0] r_id_o2,
 output logic [ID_WIDTH-1:0] r_id_o3,
 output logic [ID_WIDTH-1:0] r_id_o4,
 output logic [ID_WIDTH-1:0] r_id_o5,
 output logic [ID_WIDTH-1:0] r_id_o6,
 output logic [ID_WIDTH-1:0] r_id_o7,

 output logic r_opc_o0,
 output logic r_opc_o1,
 output logic r_opc_o2,
 output logic r_opc_o3,
 output logic r_opc_o4,
 output logic r_opc_o5,
 output logic r_opc_o6,
 output logic r_opc_o7,

 output logic lockstep_mode
);
logic [31:0] lockstep_ctrl_reg,lockstep_ctrl;

assign r_opc_o0 = 1'b0;
assign r_opc_o1 = 1'b0;
assign r_opc_o2 = 1'b0;
assign r_opc_o3 = 1'b0;
assign r_opc_o4 = 1'b0;
assign r_opc_o5 = 1'b0;
assign r_opc_o6 = 1'b0;
assign r_opc_o7 = 1'b0;
assign req_i = req_i0&req_i1&req_i2&req_i3&req_i4&req_i5&req_i6&req_i7;
assign lockstep_mode = lockstep_ctrl_reg[0];

enum logic [1:0] {TRANS_IDLE,TRANS_RUN} CS, NS;

always_ff @(posedge clk_i,negedge rst_ni)begin
 if(!rst_ni) CS <= TRANS_IDLE;
 else CS <= NS;
end

always_comb begin
 r_valid_o0 = 1'b0;
 r_valid_o1 = 1'b0;
 r_valid_o2 = 1'b0;
 r_valid_o3 = 1'b0;
 r_valid_o4 = 1'b0;
 r_valid_o5 = 1'b0;
 r_valid_o6 = 1'b0;
 r_valid_o7 = 1'b0;
 gnt_o0 = 1'b1;
 gnt_o1 = 1'b1;
 gnt_o2 = 1'b1;
 gnt_o3 = 1'b1;
 gnt_o4 = 1'b1;
 gnt_o5 = 1'b1;
 gnt_o6 = 1'b1;
 gnt_o7 = 1'b1;
 case (CS)
  TRANS_IDLE:begin
   if(req_i == 1'b1) NS = TRANS_RUN;
   else NS = TRANS_IDLE;
  end
  TRANS_RUN:begin
   r_valid_o0 = 1'b1;
   r_valid_o1 = 1'b1;
   r_valid_o2 = 1'b1;
   r_valid_o3 = 1'b1;
   r_valid_o4 = 1'b1;
   r_valid_o5 = 1'b1;
   r_valid_o6 = 1'b1;
   r_valid_o7 = 1'b1;
   if(req_i == 1'b1) NS = TRANS_RUN;
   else NS = TRANS_IDLE;
  end
  default: NS = TRANS_IDLE;
 endcase
end

always_ff @(posedge clk_i,negedge rst_ni)begin
 if(!rst_ni)begin
  r_id_o0 <= '0;
  r_id_o1 <= '0;
  r_id_o2 <= '0;
  r_id_o3 <= '0;
  r_id_o4 <= '0;
  r_id_o5 <= '0;
  r_id_o6 <= '0;
  r_id_o7 <= '0;
  lockstep_ctrl_reg <= '0;
 end else begin
  r_id_o0 <= id_i0;
  r_id_o1 <= id_i1;
  r_id_o2 <= id_i2;
  r_id_o3 <= id_i3;
  r_id_o4 <= id_i4;
  r_id_o5 <= id_i5;
  r_id_o6 <= id_i6;
  r_id_o7 <= id_i7;
  lockstep_ctrl_reg <= lockstep_ctrl;
 end
end

always_comb begin
 lockstep_ctrl = lockstep_ctrl_reg;
 if(req_i==1 && wen_i==0)
  if(add_i == 32'h10204400)
   lockstep_ctrl = wdata_i;
end

endmodule
