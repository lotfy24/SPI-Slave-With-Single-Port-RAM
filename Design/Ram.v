 module Single_port_SYNC_RAM (din,rx_valid,dout,tx_valid,clk,rst_n);
 // DEFINE PARAMETERS
 parameter MEM_DEPTH = 256 ;
 parameter ADDR_SIZE = 8 ;
 // DEFINE INPUTS 
 input [9:0] din;
 input clk,rst_n,rx_valid;
 // DEFINE OUTPUTS 
 output reg [7:0] dout;
 output reg tx_valid;
 // GENERATE MEMORY
 reg [7:0] RAM [MEM_DEPTH-1:0];
 // DEFINE 2 ADDRESSES ONE FOR WRITE AND ONE FOR READ
reg [ADDR_SIZE-1 :0] wr_address , rd_address ;
 // DESIGN IMPLEMENTATION
 always @(posedge clk) begin
    if(~rst_n)begin
      dout <= 0;
      tx_valid <= 0;
      wr_address <= 0;
      rd_address <= 0;
    end
    else begin
        if(rx_valid)begin
          case (din[9:8])
            2'b00:begin
                  wr_address <= din[7:0];
                  tx_valid   <= 0;
            end 
            2'b01:begin
                  RAM[wr_address] <= din[7:0];
                  tx_valid        <= 0;
            end
            2'b10:begin
                  rd_address <= din[7:0];
                  tx_valid   <= 0;
            end
            2'b11:begin
                  dout     <= RAM[rd_address];
                  tx_valid <= 1;
            end
            default: dout <=0;
         endcase
        end     
    end    
 end    
 endmodule