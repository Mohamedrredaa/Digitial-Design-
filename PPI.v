/*
Aout,Bout,Cout,PD are the 8bit ports  inout
PA  ,PB  , PC ,PD are registers for every port
D is the databus in between 
*/

module PPI(Aout,Bout,Cout,PD,RD,WR,RESET,CS,A);
reg [7:0]PA,PB,D,PC;		//registers for every PORT to save data inside 
reg [7:0]controlword; 		//to take the byte of control inside and then cotrol 
inout [7:0]Aout,Bout,Cout,PD;
input RESET,CS,RD,WR;
input [1:0] A;

wire mode,mode0,mode1,mode2;	
assign mode= (!WR&&RD)?1:0;		//just an indication of tdhe port is read or write 
assign mode0=(!WR&&RD)?1:0;
assign mode1=(!WR&&RD)?1:0;
assign mode2=(!WR&&RD)?1:0;

assign PD          =(!RD&&WR)?D:8'bz;	//if PORTD is in read mode ,make it zero,,,else make it by the value on it 
assign Aout 	   =(RESET)?8'bz:(mode) ?PA:8'bz ; 
assign Bout        =(RESET)?8'bz:(mode0)?PB:8'bz ;
assign Cout[3:0]   =(RESET)?4'bz:(mode1)?PC[3:0]:4'bz;
assign Cout[7:4]   =(RESET)?4'bz:(mode2)?PC[7:4]:4'bz; 
always @*
begin               
				
if (RD&&!WR)   
begin  D=PD;end
else if(!RD&&WR)
begin
case(A)
0:PA=Aout;
1:PB=Bout;
2:PC=Cout;
endcase
end
                 
                 if(!CS)
              begin
              

           
		if (A[1] && A[0]) begin  controlword =PD; end //condition needed 
             //bta3t if(!RESET)
		while(!RESET) 
              begin
       
  
     if (controlword[7]==0) 
       begin                 //d7=0 y3ny BSR MODE			
	if(!WR&&RD&&mode1&&mode2)
	begin
		case(controlword[3:0])    //ytra mktoba s7
			0:  PC[0] =0;
	 		1:  PC[0] =1;
			2:  PC[1] =0;
			3:  PC[1] =1;
			4:  PC[2] =0;	
			5:  PC[2] =1;
			6:  PC[3] =0;
			7:  PC[3] =1;
			8:  PC[4] =0;
			9:  PC[4] =1;
			10: PC[5] =0;
			11: PC[5] =1;
			12: PC[6] =0;
			13: PC[6] =1;
			14: PC[7] =0;
			15: PC[7] =1; 
		 
			
		endcase
		//D=Cout;			//copy values
	end                   //bta3t if(!WR)
end                  //bta3t if (!D[7])
else 
begin
                // if pin8 in D is not low then i/o mode is enabled 
	
		if(controlword[2]==0&&controlword[6]==0&&controlword[5]==0)     //if8
		begin	//[4] A,[3] Cu , [1] B , [0] Cl
		case (controlword[4:0])//ZERO MEANS FROM D TO PORTS AND I IS INVERSE
		5'b00000:
			if     (A[0]==0&&A[1]==0&&mode==1) begin  PA=D;          	      	end
			else if(A[0]==1&&A[1]==0&&mode0==1) begin  PB=D;       	  	        end  
			else if(A[0]==0&&A[1]==1&& mode1&& mode2) begin
                         
                     		 PC[3:0]=D[3:0]; PC[7:4]=D[7:4]; end
		
			  
		5'b00001:
	
			if     (A[0]==0&&A[1]==0&&mode==1) begin  PA=D;  		      	end
			else if(A[0]==1&&A[1]==0&&mode0==1) begin  PB=D;       	      		end  
			else if(A[0]==0&&A[1]==1 &&mode1==0&& mode2==1) begin   
                      
                           D[3:0]=PC[3:0];PC[7:4]=D[7:4]; end
			
		5'b00010:
			
			if     (A[0]==0&&A[1]==0&&mode==1) begin  PA=D; 		      		end
			else if(A[0]==1&&A[1]==0&&mode0==1) begin  D=PB;      	      		end  
			else if(A[0]==0&&A[1]==1&&mode1 &&mode2) begin  
                       
                        PC[3:0]=D[3:0];PC[7:4]=D[7:4]; end
			
		5'b00011:
			
			if     (A[0]==0&&A[1]==0&&mode==1) begin   PA=D; 		      		end
			else if(A[0]==1&&A[1]==0&&mode0==0) begin  D=PB;      	      		end  
			else if(A[0]==0&&A[1]==1&&mode1==0 &&mode2==1) begin 
                         
                         D[3:0]=PC[3:0];PC[7:4]=D[7:4]; end
		
		5'b01000:
			
		
			if     (A[0]==0&&A[1]==0&&mode==1) begin  PA=D; 		      		end
			else if(A[0]==1&&A[1]==0&&mode0==1) begin  PB=D;      	     		end  
			else if(A[0]==0&&A[1]==1&& mode1==0 &&mode2==1) begin 
                       
                      D[7:4]=PC[7:4];PC[3:0]=D[3:0]; end
			
		5'b01001:
			
			if     (A[0]==0&&A[1]==0&&mode==1) begin  PA=D; 		      		end
			else if(A[0]==1&&A[1]==0&&mode0==0) begin  PB=D;      	     	  		end  
			else if(A[0]==0&&A[1]==1&& mode1==1 &&mode2==0) begin 
                          
                        D=PC; end
			
		5'b01010:
			
			
			if     (A[0]==0&&A[1]==0&&mode==1) begin  PA=D; 		      		end
			else if(A[0]==1&&A[1]==0&&mode0==1) begin  D=PB;      	      		end  
			else if(A[0]==0&&A[1]==1 &&mode1==0 &&mode2==1) begin 
                         
                         PC[3:0]=D[3:0];D[7:4]=PC[7:4]; end
			
		5'b01011:
			
			
			if     (A[0]==0&&A[1]==0&&mode==1) begin  PA=D; 		      		end
			else if(A[0]==1&&A[1]==0&& mode0==0) begin  D=PB;      	    	  		end  
			else if(A[0]==0&&A[1]==1&& mode1==0 &&mode2==0) begin 
                         
                         D=PC; end
			
		5'b10000:
			
			if     (A[0]==0&&A[1]==0&& mode==0) begin  D=PA; 			      		end
			else if(A[0]==1&&A[1]==0&&mode0==1) begin  PB=D;      	      		end  
			else if(A[0]==0&&A[1]==1&&mode1 &&mode2) begin 
                           
                        PC[3:0]=D[3:0];PC[7:4]=D[7:4]; end
			
		5'b10001:
		
			if     (A[0]==0&&A[1]==0&& mode==0) begin  D=PA; 			      		end
			else if(A[0]==1&&A[1]==0&&mode0==1) begin  PB=D;      	      		end  
			else if(A[0]==0&&A[1]==1&&mode1==0 &&mode2==0) begin 
                          
                         D[3:0]=PC[3:0];PC[7:4]=D[7:4]; end
			
		5'b10010:
			
			
			if     (A[0]==0&&A[1]==0&&mode==0) begin  D=PA; 			      		end
			else if(A[0]==1&&A[1]==0&&mode0==0) begin  D=PB;      	    	   		end  
			else if(A[0]==0&&A[1]==1&&mode1&&mode2) begin 
                           
                         PC[3:0]=D[3:0];PC[7:4]=D[7:4]; end
			
		5'b10011:
			
			if     (A[0]==0&&A[1]==0&&mode==0) begin  D=PA; 		    	   		end
			else if(A[0]==1&&A[1]==0&&mode0==0) begin  D=PB;      	    	   		end  
			else if(A[0]==0&&A[1]==1&&mode1==0 &&mode2==1) begin  
                           
                         D[3:0]=PC[3:0];PC[7:4]=D[7:4]; end
			
		5'b11000:
			
			
			if     (A[0]==0&&A[1]==0&&mode==0) begin  D=PA; 		   	    		end
			else if(A[0]==1&&A[1]==0&&mode0==1) begin  PB=D;      	      		end  
			else if(A[0]==0&&A[1]==1&&mode1==0 &&mode2==0) begin  
                            
                        PC[3:0]=D[3:0];D[7:4]=PC[7:4]; end
			
		5'b11001:
			
			if     (A[0]==0&&A[1]==0&&mode==0) begin  D=PA; 		  	     		end
			else if(A[0]==1&&A[1]==0&&mode0==1) begin  PB=D;      	      		end  
			else if(A[0]==0&&A[1]==1&&mode1==0 &&mode2==0) begin 
                              
                         D[3:0]=PC[3:0];D[7:4]=PC[7:4]; end
			
		5'b11010:
		
			if     (A[0]==0&&A[1]==0&&mode==0) begin  D=PA; 		 	      		end
			else if(A[0]==1&&A[1]==0&&mode0==0) begin  D=PB;      	 	      		end  
			else if(A[0]==0&&A[1]==1&& mode1==1 &&mode2==0) begin 
                                
                          PC[3:0]=D[3:0];D[7:4]=PC[7:4]; end
			
		5'b11011:
			
			if     (A[0]==0&&A[1]==0&&mode==0) begin  D=PA; 		 	      		end
			else if(A[0]==1&&A[1]==0&&mode0==0) begin  D=PB;      	    	  		end  
			else if(A[0]==0&&A[1]==1&&mode1==0 &&mode2==0) begin 
                           
                          D[3:0]=PC[3:0];D[7:4]=PC[7:4]; end
			 
	endcase 
end                      //bta3t if8
end                 //bta3t else mode0
end                // bta3telse !RESET   
end
end               //bta3t if(!CS)
endmodule


module Test();
//these are for the inout port which are used in the instance 
wire [7:0] PORTA;
wire [7:0] PORTB;
wire [7:0] PORTC;
wire [7:0] PORTD;
// Control wires
reg RD;
reg WR;
reg CS;
reg RESET;
reg [1:0] A;
// Ports for test bench
reg [7:0] regA;
reg [7:0] regB;
reg [7:0] regC;
reg [7:0] regD;
// Link Test bench with PPI
assign PORTD  = (RD)? regD : 8'bz; 
assign PORTA  = (WR)? regA : 8'bz;
assign PORTB  = (WR)? regB : 8'bz;
assign PORTC  = (WR)? regC : 8'bz;
initial 
begin 
	$monitor ("%b %b %b %b %b   %b   %b   %b   %b",PORTA,PORTB,PORTC,PORTD,RD,WR,CS,RESET,A);
	$display ("PORTA    PORTB    PORTC    PORTD   RD  WR  CS RESET A0 A1");
	RESET = 1;
	CS = 0;
	WR = 1;
	RD = 1;
	
	#10
	RESET = 0;	
	WR = 0;
	A = 3;		    //the control word must have this value to start BSR
	regD = 8'b01111111; //here to test the BSR mode 8th bit
	#10 
	regD = 8'b01111100;
	#10
	regD = 8'b01110001; 
	#10
	regD = 8'b01111001;
	$display ("The port C must have 10xxxxx1");
	//-----------------------------------------------------------------------------
	//starting the I/O modes ,mode 0
	//first we will write in the control register and write in the PORTs in output mode
	RESET = 1;
	#10
	RESET = 0;
	$display ("the i/o mode 0");
	A = 3;
	WR = 0;
	RD = 1;
	regD = 8'b10000000 ; //to make all the port in the output mode 
	#10
	A = 0;
	regD = 8'b10000000 ;
	$display ("portA must have the value in portD which is 10000000");
	#10
	A = 1;
	regD = 8'b11111100 ;
	$display ("portB must have the value in portD which is 11111100");
	#10
	A = 2;
	regD = 8'b10101010 ;
	$display ("portC must have the value in portD which is 10101010");	

	//-------------------------------------------------------------------
	$display ("starting the input mode from the ports to portD");
	RESET = 1;
	#10
	RESET = 0;
	A = 3;
	regD = 10011011;
	RD = 0; WR = 1;
	#10
	A = 0;	
	regA = 8'b11110000;
	$display ("portD must have the value in portA which is 11110000");	
	A = 1;
	regB= 8'b00001111;
	#10
	$display ("portD must have the value in portB which is 00001111");
	A = 2;
	regC = 8'b10101010;
	#10
	$display ("portD must have the value in portC which is 10101010");
	$display ("Done");

end 
PPI MR(PORTA,PORTB,PORTC,PORTD,RD,WR,RESET,CS,A);
endmodule 