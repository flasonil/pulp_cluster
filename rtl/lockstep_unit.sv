module lockstep_unit
  (
   input logic         clk_i,
   input logic         rst_ni,
   input logic         lockstep_mode,
   input logic         same_address,
   
   input logic         gnt_i0,
   input logic         gnt_i1,
   input logic         gnt_i2,
   input logic         gnt_i3,
   input logic         gnt_i4,
   input logic         gnt_i5,
   input logic         gnt_i6,
   input logic         gnt_i7,
   output logic        gnt_o0,
   output logic        gnt_o1,
   output logic        gnt_o2,
   output logic        gnt_o3,
   output logic        gnt_o4,
   output logic        gnt_o5,
   output logic        gnt_o6,
   output logic        gnt_o7,
   
   input logic         req_i0,
   input logic         req_i1,
   input logic         req_i2,
   input logic         req_i3,
   input logic         req_i4,
   input logic         req_i5,
   input logic         req_i6,
   input logic         req_i7,
   output logic        req_o0,
   output logic        req_o1,
   output logic        req_o2,
   output logic        req_o3,
   output logic        req_o4,
   output logic        req_o5,
   output logic        req_o6,
   output logic        req_o7,
   
   input logic         rvalid_i0,
   input logic         rvalid_i1,
   input logic         rvalid_i2,
   input logic         rvalid_i3,
   input logic         rvalid_i4,
   input logic         rvalid_i5,
   input logic         rvalid_i6,
   input logic         rvalid_i7,
   output logic        rvalid_o0,
   output logic        rvalid_o1,
   output logic        rvalid_o2,
   output logic        rvalid_o3,
   output logic        rvalid_o4,
   output logic        rvalid_o5,
   output logic        rvalid_o6,
   output logic        rvalid_o7,

   input logic [31:0]  rdata_i0,
   input logic [31:0]  rdata_i1,
   input logic [31:0]  rdata_i2,
   input logic [31:0]  rdata_i3,
   input logic [31:0]  rdata_i4,
   input logic [31:0]  rdata_i5,
   input logic [31:0]  rdata_i6,
   input logic [31:0]  rdata_i7,
   output logic [31:0] rdata_o0,
   output logic [31:0] rdata_o1,
   output logic [31:0] rdata_o2,
   output logic [31:0] rdata_o3,
   output logic [31:0] rdata_o4,
   output logic [31:0] rdata_o5,
   output logic [31:0] rdata_o6,
   output logic [31:0] rdata_o7
   );
   
   logic               same_address_d;
   logic [3:0]         nreq,nreqd;
   logic [7:0]         cntgnt,cntrvalid;
   logic [31:0]        rdata_reg[7:0];      
   logic               outgnt,outrvalid;
   logic [7:0]         reqd;
   logic [31:0]        rdata0,rdata1,rdata2,rdata3,rdata4,rdata5,rdata6,rdata7;
   enum                {IDLE=2'b00, WAITING_GRANT=2'b01, GRANT_RECEIVED=2'b10} CS0,CS1,CS2,CS3,CS4,CS5,CS6,CS7,NS0,NS1,NS2,NS3,NS4,NS5,NS6,NS7;
   

   always_comb begin
      
      //sampling rdata on rvalid_i
      if(rvalid_i0)
        rdata0 = rdata_i0;
      if(rvalid_i1)
        rdata1 = rdata_i1;
      if(rvalid_i2)
        rdata2 = rdata_i2;
      if(rvalid_i3)
        rdata3 = rdata_i3;
      if(rvalid_i4)
        rdata4 = rdata_i4;
      if(rvalid_i5)
        rdata5 = rdata_i5;
      if(rvalid_i6)
        rdata6 = rdata_i6;
      if(rvalid_i7)
        rdata7 = rdata_i7;

      //FSM to set 0 req_o
      case(CS0)
        IDLE:begin
					 if(same_address) req_o0 = req_i0;
           else begin
					    req_o0 = req_i0;
						  if ((gnt_i0+gnt_i1+gnt_i2+gnt_i3+gnt_i4+gnt_i5+gnt_i6+gnt_i7) == nreq) NS0 = IDLE;
						  else begin
            	   if(req_i0&&gnt_i0) NS0 = GRANT_RECEIVED;
            	   else if(req_i0&&(!gnt_i0)) NS0 = WAITING_GRANT;
            	   else NS0 = IDLE;
						  end
					 end
        end
        WAITING_GRANT:begin
           req_o0 = req_i0;
	         if(outgnt) NS0 = IDLE;
	         else begin
        	    if(req_i0&&gnt_i0) NS0 = GRANT_RECEIVED;
        	    else NS0 = WAITING_GRANT;
	         end
        end
        GRANT_RECEIVED:begin
           req_o0 = 1'b0;
           if(outgnt) NS0 = IDLE;
	         else NS0 = GRANT_RECEIVED;
        end
      endcase // case (CS)
      case(CS1)
        IDLE:begin
					 if(same_address) req_o1 = 1'b0;
           else begin
					    req_o1 = req_i1;
						  if ((gnt_i0+gnt_i1+gnt_i2+gnt_i3+gnt_i4+gnt_i5+gnt_i6+gnt_i7) == nreq) NS1 = IDLE;
						  else begin
            	   if(req_i1&&gnt_i1) NS1 = GRANT_RECEIVED;
            	   else if(req_i1&&(!gnt_i1)) NS1 = WAITING_GRANT;
            	   else NS1 = IDLE;
						  end
					 end
        end
        WAITING_GRANT:begin
           req_o1 = req_i1;
	         if(outgnt) NS1 = IDLE;
	         else begin
        	    if(req_i1&&gnt_i1) NS1 = GRANT_RECEIVED;
        	    else NS1 = WAITING_GRANT;
	         end
        end
        GRANT_RECEIVED:begin
           req_o1 = 1'b0;
           if(outgnt) NS1 = IDLE;
	         else NS1 = GRANT_RECEIVED;
        end
      endcase // case (CS)
      case(CS2)
        IDLE:begin
					 if(same_address) req_o2 = 1'b0;
           else begin
					    req_o2 = req_i2;
						  if ((gnt_i0+gnt_i1+gnt_i2+gnt_i3+gnt_i4+gnt_i5+gnt_i6+gnt_i7) == nreq) NS2 = IDLE;
						  else begin
            	   if(req_i2&&gnt_i2) NS2 = GRANT_RECEIVED;
            	   else if(req_i2&&(!gnt_i2)) NS2 = WAITING_GRANT;
            	   else NS2 = IDLE;
						  end
					 end
        end
        WAITING_GRANT:begin
           req_o2 = req_i2;
	         if(outgnt) NS2 = IDLE;
	         else begin
        	    if(req_i2&&gnt_i2) NS2 = GRANT_RECEIVED;
        	    else NS2 = WAITING_GRANT;
	         end
        end
        GRANT_RECEIVED:begin
           req_o2 = 1'b0;
           if(outgnt) NS2 = IDLE;
	         else NS2 = GRANT_RECEIVED;
        end
      endcase // case (CS)
      case(CS3)
        IDLE:begin
					 if(same_address) req_o3 = 1'b0;
           else begin
					    req_o3 = req_i3;
						  if ((gnt_i0+gnt_i1+gnt_i2+gnt_i3+gnt_i4+gnt_i5+gnt_i6+gnt_i7) == nreq) NS3 = IDLE;
						  else begin
            	   if(req_i3&&gnt_i3) NS3 = GRANT_RECEIVED;
            	   else if(req_i3&&(!gnt_i3)) NS3 = WAITING_GRANT;
            	   else NS3 = IDLE;
						  end
					 end
        end
        WAITING_GRANT:begin
           req_o3 = req_i3;
	         if(outgnt) NS3 = IDLE;
	         else begin
        	    if(req_i3&&gnt_i3) NS3 = GRANT_RECEIVED;
        	    else NS3 = WAITING_GRANT;
	         end
        end
        
        GRANT_RECEIVED:begin
           req_o3 = 1'b0;
           if(outgnt) NS3 = IDLE;
	         else NS3 = GRANT_RECEIVED;
        end
      endcase // case (CS)
      case(CS4)
        IDLE:begin
					 if(same_address) req_o4 = 1'b0;
           else begin
					    req_o4 = req_i4;
						  if ((gnt_i0+gnt_i1+gnt_i2+gnt_i3+gnt_i4+gnt_i5+gnt_i6+gnt_i7) == nreq) NS4 = IDLE;
						  else begin
            	   if(req_i4&&gnt_i4) NS4 = GRANT_RECEIVED;
            	   else if(req_i4&&(!gnt_i4)) NS4 = WAITING_GRANT;
            	   else NS4 = IDLE;
						  end
					 end
        end
        WAITING_GRANT:begin
           req_o4 = req_i4;
	         if(outgnt) NS4 = IDLE;
	         else begin
        	    if(req_i4&&gnt_i4) NS4 = GRANT_RECEIVED;
        	    else NS4 = WAITING_GRANT;
	         end
        end
        GRANT_RECEIVED:begin
           req_o4 = 1'b0;
           if(outgnt) NS4 = IDLE;
	         else NS4 = GRANT_RECEIVED;
        end
      endcase // case (CS)
      case(CS5)
        IDLE:begin
					 if(same_address) req_o5 = 1'b0;
           else begin
					    req_o5 = req_i5;
						  if ((gnt_i0+gnt_i1+gnt_i2+gnt_i3+gnt_i4+gnt_i5+gnt_i6+gnt_i7) == nreq) NS5 = IDLE;
						  else begin
            	   if(req_i5&&gnt_i5) NS5 = GRANT_RECEIVED;
            	   else if(req_i5&&(!gnt_i5)) NS5 = WAITING_GRANT;
            	   else NS5 = IDLE;
						  end
					 end
        end
        WAITING_GRANT:begin
           req_o5 = req_i5;
	         if(outgnt) NS5 = IDLE;
	         else begin
        	    if(req_i5&&gnt_i5) NS5 = GRANT_RECEIVED;
        	    else NS5 = WAITING_GRANT;
	         end
        end
        GRANT_RECEIVED:begin
           req_o5 = 1'b0;
           if(outgnt) NS5 = IDLE;
	         else NS5 = GRANT_RECEIVED;
        end
      endcase // case (CS)
      case(CS6)
        IDLE:begin
					 if(same_address) req_o6 = 1'b0;
           else begin
					    req_o6 = req_i6;
						  if ((gnt_i0+gnt_i1+gnt_i2+gnt_i3+gnt_i4+gnt_i5+gnt_i6+gnt_i7) == nreq) NS6 = IDLE;
						  else begin
            	   if(req_i6&&gnt_i6) NS6 = GRANT_RECEIVED;
            	   else if(req_i6&&(!gnt_i6)) NS6 = WAITING_GRANT;
            	   else NS6 = IDLE;
						  end
					 end
        end
        WAITING_GRANT:begin
           req_o6 = req_i6;
	         if(outgnt) NS6 = IDLE;
	         else begin
        	    if(req_i6&&gnt_i6) NS6 = GRANT_RECEIVED;
        	    else NS6 = WAITING_GRANT;
	         end
        end
        GRANT_RECEIVED:begin
           req_o6 = 1'b0;
           if(outgnt) NS6 = IDLE;
	         else NS6 = GRANT_RECEIVED;
        end
      endcase // case (CS)
      case(CS7)
        IDLE:begin
					 if(same_address) req_o7 = 1'b0;
           else begin
					    req_o7 = req_i7;
						  if ((gnt_i0+gnt_i1+gnt_i2+gnt_i3+gnt_i4+gnt_i5+gnt_i6+gnt_i7) == nreq) NS7 = IDLE;
						  else begin
            	   if(req_i7&&gnt_i7) NS7 = GRANT_RECEIVED;
            	   else if(req_i7&&(!gnt_i7)) NS7 = WAITING_GRANT;
            	   else NS7 = IDLE;
						  end
					 end
        end
        WAITING_GRANT:begin
           req_o7 = req_i7;
	         if(outgnt) NS7 = IDLE;
	         else begin
        	    if(req_i7&&gnt_i7) NS7 = GRANT_RECEIVED;
        	    else NS7 = WAITING_GRANT;
	         end
        end
        GRANT_RECEIVED:begin
           req_o7 = 1'b0;
           if(outgnt) NS7 = IDLE;
	         else NS7 = GRANT_RECEIVED;
        end
      endcase // case (CS)
      
			if(same_address)//DATA BROADCAST: we send only one request to memory
        nreq = 1;
      else
        nreq = req_i7+req_i6+req_i5+req_i4+req_i3+req_i2+req_i1+req_i0;//Otherwise we count the number of simultaneous requests
      
      if(!same_address)begin      
			   if((nreq!=0)&&((cntgnt+(gnt_i0+gnt_i1+gnt_i2+gnt_i3+gnt_i4+gnt_i5+gnt_i6+gnt_i7)) == nreq)) begin
            //All grants from memory received: we send them simultaneously to the cores
            outgnt = 1;
            gnt_o0 = req_i0;
            gnt_o1 = req_i1;
            gnt_o2 = req_i2;
            gnt_o3 = req_i3;
            gnt_o4 = req_i4;
            gnt_o5 = req_i5;
            gnt_o6 = req_i6;
            gnt_o7 = req_i7;
         end
         else begin
            //Not all grants received: we don't send them to the cores
            outgnt = 0;
            gnt_o0 = '0;
            gnt_o1 = '0;
            gnt_o2 = '0;
            gnt_o3 = '0;
            gnt_o4 = '0;
            gnt_o5 = '0;
            gnt_o6 = '0;
            gnt_o7 = '0;
         end
      end else begin//same_address=1 : DATA BROADCAST
         if(gnt_i0) begin//grant0 from memory received: we send grant to all the cores
            outgnt=1;
            gnt_o0 = req_i0;
            gnt_o1 = req_i0;
            gnt_o2 = req_i0;
            gnt_o3 = req_i0;
            gnt_o4 = req_i0;
            gnt_o5 = req_i0;
            gnt_o6 = req_i0;
            gnt_o7 = req_i0;
         end else begin
            outgnt=0;
            gnt_o0 = '0;
            gnt_o1 = '0;
            gnt_o2 = '0;
            gnt_o3 = '0;
            gnt_o4 = '0;
            gnt_o5 = '0;
            gnt_o6 = '0;
            gnt_o7 = '0;
         end
      end
      if(!same_address_d)begin
         if((nreqd!=0)&&((cntrvalid+(rvalid_i0+rvalid_i1+rvalid_i2+rvalid_i3+rvalid_i4+rvalid_i5+rvalid_i6+rvalid_i7)) == nreqd)) begin
            outrvalid = 1;
            rdata_o0 = rdata0;
            rdata_o1 = rdata1;
            rdata_o2 = rdata2;
            rdata_o3 = rdata3;
            rdata_o4 = rdata4;
            rdata_o5 = rdata5;
            rdata_o6 = rdata6;
            rdata_o7 = rdata7;
            rvalid_o0 = reqd[0];
            rvalid_o1 = reqd[1];
            rvalid_o2 = reqd[2];
            rvalid_o3 = reqd[3];
            rvalid_o4 = reqd[4];
            rvalid_o5 = reqd[5];
            rvalid_o6 = reqd[6];
            rvalid_o7 = reqd[7];
         end else begin // if ((nreqd!=0)&&(cntrvalid == (nreqd-1)))
            rvalid_o0 = 0;
            rvalid_o1 = 0;
            rvalid_o2 = 0;
            rvalid_o3 = 0;
            rvalid_o4 = 0;
            rvalid_o5 = 0;
            rvalid_o6 = 0;
            rvalid_o7 = 0;
            outrvalid = 0;
         end // else: !if((nreqd!=0)&&(cntrvalid == (nreqd-1)))
      end else begin
         if(rvalid_i0) begin
            outrvalid = 1;
            rdata_o0 = rdata0;
            rdata_o1 = rdata0;
            rdata_o2 = rdata0;
            rdata_o3 = rdata0;
            rdata_o4 = rdata0;
            rdata_o5 = rdata0;
            rdata_o6 = rdata0;
            rdata_o7 = rdata0;
            rvalid_o0 = reqd[0];
            rvalid_o1 = reqd[0];
            rvalid_o2 = reqd[0];
            rvalid_o3 = reqd[0];
            rvalid_o4 = reqd[0];
            rvalid_o5 = reqd[0];
            rvalid_o6 = reqd[0];
            rvalid_o7 = reqd[0];
         end else begin
            rvalid_o0 = 0;
            rvalid_o1 = 0;
            rvalid_o2 = 0;
            rvalid_o3 = 0;
            rvalid_o4 = 0;
            rvalid_o5 = 0;
            rvalid_o6 = 0;
            rvalid_o7 = 0;
            outrvalid = 0;
         end
      end

	 end
   
   always_ff@(posedge clk_i)begin
      if(!rst_ni)begin
         cntrvalid <= '0;
         cntgnt <= '0;
         nreqd <= '0;
         reqd <= '0;
				 same_address_d <= '0;
         CS0 <= IDLE;
         CS1 <= IDLE;
         CS2 <= IDLE;
         CS3 <= IDLE;
         CS4 <= IDLE;
         CS5 <= IDLE;
         CS6 <= IDLE;
         CS7 <= IDLE;
      end
      else begin
				 same_address_d <= same_address;
         nreqd <= nreq;
         reqd[0] <= req_i0;
         reqd[1] <= req_i1;
         reqd[2] <= req_i2;
         reqd[3] <= req_i3;
         reqd[4] <= req_i4;
         reqd[5] <= req_i5;
         reqd[6] <= req_i6;
         reqd[7] <= req_i7;
		     if(lockstep_mode)begin
	          CS0 <= NS0;
   	        CS1 <= NS1;
   	        CS2 <= NS2;
   	        CS3 <= NS3;
   	        CS4 <= NS4;
   	        CS5 <= NS5;
   	        CS6 <= NS6;
   	        CS7 <= NS7;
		     end else begin
	          CS0 <= IDLE;
   	        CS1 <= IDLE;
   	        CS2 <= IDLE;
   	        CS3 <= IDLE;
   	        CS4 <= IDLE;
   	        CS5 <= IDLE;
   	        CS6 <= IDLE;
   	        CS7 <= IDLE;
		     end
         
		     if(((rvalid_i0+rvalid_i1+rvalid_i2+rvalid_i3+rvalid_i4+rvalid_i5+rvalid_i6+rvalid_i7)!=0)&&(outrvalid==0))//counter dei grant viene incrementato non appena viene servita una n-esima richiesta
			     cntrvalid <= cntrvalid + (rvalid_i0+rvalid_i1+rvalid_i2+rvalid_i3+rvalid_i4+rvalid_i5+rvalid_i6+rvalid_i7);
         else cntrvalid <= 0;
         
	       if(((gnt_i0+gnt_i1+gnt_i2+gnt_i3+gnt_i4+gnt_i5+gnt_i6+gnt_i7)!=0)&&(outgnt==0))//counter dei grant viene incrementato non appena viene servita una n-esima richiesta
		       cntgnt <= cntgnt + (gnt_i0+gnt_i1+gnt_i2+gnt_i3+gnt_i4+gnt_i5+gnt_i6+gnt_i7);
         else cntgnt <= 0;
         
      end
   end
   
endmodule // lockstep
