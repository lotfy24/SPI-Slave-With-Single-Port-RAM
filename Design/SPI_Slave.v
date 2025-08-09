module SPI_slave_interface (MOSI,MISO,SS_n,clk,rst_n,tx_valid,tx_data,rx_valid,rx_data);
// DEFINE STATES ENCODING
parameter IDLE =3'b000;
parameter CHK_CMD =3'b001;
parameter WRITE =3'b010;
parameter READ_ADD =3'b011;
parameter READ_DATA =3'b100;
// DEFINE INPUTS
input MOSI,SS_n,tx_valid,clk,rst_n;
input [7:0] tx_data;
// DEFINE OUTPUTS
output reg rx_valid,MISO;
output reg [9:0] rx_data;
// DEFING INTERNAL COOUNTER & signal  
reg [3:0] counter;
reg rd_control;
// DEFINE CURRENT AND NEXT STATES
(* fsm_encoding = "one_hot" *) // FOR ENCODING IN VIVADO
reg [2:0] cs,ns; 
reg [7:0] tx_data_temp;
// STATE MEMORY BLOCK
always @(posedge clk) begin
    if(~rst_n)begin
       cs <= IDLE; 
    end
    else begin
       cs <= ns; 
    end
end
// NEXT STATE LOGIC BLOCK
always @(*) begin
    case (cs)
        IDLE:begin
            if(SS_n == 1)
                ns = IDLE ;
            else
                ns = CHK_CMD;    
        end
        CHK_CMD:begin
             if((SS_n == 0) && (MOSI == 0))
                ns = WRITE;
            else if((SS_n == 0) && (MOSI == 1) && (rd_control == 0)) 
                ns = READ_ADD;    
            else if((SS_n == 0) && (MOSI == 1) && (rd_control == 1))
                ns = READ_DATA; 
            else
                ns = IDLE;
        end
        WRITE:begin
            if(SS_n == 1)
                ns = IDLE;
            else 
                ns = WRITE;    
        end
        READ_ADD:begin
            if(SS_n == 1)
                ns = IDLE;
            else 
                ns = READ_ADD;
        end
        READ_DATA:begin
            if(SS_n == 1)
                ns = IDLE;
            else 
                ns = READ_DATA;
        end
        default: ns  = IDLE;
    endcase 
end
// OUTPUT LOGIC BLOCK
always @(posedge clk) begin
    if(~rst_n)begin
      rx_valid <= 0;
      rx_data <= 0;
      MISO <= 0;
      counter <= 0;
      rd_control <= 0;

    end
    else begin
      case (cs)
        IDLE:begin
            rx_valid <=0;
            counter <= 0;
            MISO <=0;
        end
        CHK_CMD:begin
            rx_valid <=0;
            counter <= 0;
        end
        WRITE:begin
          if(counter <= 9)begin
                rx_data[9-counter] <= MOSI ; 
                rx_valid <= 0;
                counter <= counter + 1;
          end
          else begin
                rx_valid <= 1;
          end
        end
        READ_ADD:begin
          if(counter <= 9)begin
                rx_data[9-counter] <= MOSI ; 
                rx_valid <= 0;
                counter <= counter + 1;
                rd_control <= 1;
          end
          else begin
               rx_valid <= 1;
          end
        end
        READ_DATA:begin
          if(counter <= 9) begin
                rx_data[9-counter] <= MOSI; 
                rx_valid <= 0;
                counter <= counter + 1;
          end
          else if(tx_valid && counter >= 3) begin
                MISO <= tx_data[counter - 3];
                counter <= counter - 1;
          end
           if(counter > 9) begin
                rx_valid <= 1;
                rd_control <= 0;
          end
        end 
      endcase
    end   
end    
endmodule
