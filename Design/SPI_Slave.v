module SPI_slave_interface (MOSI,MISO,SS_n,clk,rst_n,tx_valid,tx_data,rx_valid,rx_data);
//Define satates as a parameters
parameter IDLE      = 3'b000;
parameter CHK_CMD   = 3'b001;
parameter WRITE     = 3'b010;
parameter READ_ADD  = 3'b011;
parameter READ_DATA = 3'b100;
// Input ports
input clk,rst_n;
input SS_n,MOSI,tx_valid;
input [7:0] tx_data;
// Output ports
output reg rx_valid,MISO;
output reg  [9:0] rx_data;
// Internal signals
reg [3:0] counter;
reg Recieved_address;   // single bit to deffrentiate between read data and read address
reg [2:0] cs,ns;        // current and next states

//State memory 
always @(posedge clk,negedge rst_n) begin
    if(~rst_n)begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end
// Next state logic
always @(*) begin
    if(~rst_n)begin
        ns = IDLE;
    end
    else begin
        case (cs)
            IDLE:begin
                if(SS_n == 1'b0)begin
                    ns = CHK_CMD;
                end
                else begin
                    ns = IDLE;
                end
            end
            CHK_CMD:begin
                if(SS_n == 1'b1)begin
                    ns = IDLE;
                end
                else if((SS_n == 1'b0) && (MOSI == 1'b0))begin
                    ns = WRITE;
                end
                else if((SS_n == 1'b0) && (MOSI == 1'b1) && (Recieved_address == 1'b0))begin
                    ns = READ_ADD;
                end
                else if((SS_n == 1'b0) && (MOSI == 1'b1) && (Recieved_address == 1'b1))begin
                    ns = READ_DATA;
                end    
            end
            WRITE:begin
                if(SS_n == 1'b1)begin
                    ns = IDLE;
                end
                else begin
                    ns = WRITE;
                end
            end
            READ_ADD:begin
                if(SS_n == 1'b1)begin
                    ns = IDLE;
                end
                else begin
                    ns = READ_ADD;
                end
            end
            READ_DATA:begin
                if(SS_n == 1'b1)begin
                    ns = IDLE;
                end
                else begin
                    ns = READ_DATA;
                end 
            end
            
        endcase
    end
end
// Output logic
always @(posedge clk) begin
    if(~rst_n)begin
        rx_valid        <=1'b0;
        MISO            <=1'b0;
        rx_data         <=10'b0;
        counter             <=1'b0;
        Recieved_address    <=1'b0;
    end
    else begin
        case (cs)
            IDLE:begin
                rx_valid <=1'b0; // communication is off no ready data
            end
            CHK_CMD:begin
                counter <= 10;
                rx_valid <=1'b0; // data is not ready 
            end
            WRITE:begin
                if(counter > 0)begin
                    rx_valid <=1'b0;
                    rx_data[counter - 1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <=1'b1;
                end
            end
            READ_ADD:begin
                if(counter > 0)begin
                    rx_valid <=1'b0;
                    rx_data[counter - 1] <= MOSI;
                    counter <= counter - 1;
                    Recieved_address <= 1'b0;
                end
                else begin
                    rx_valid <=1'b1;
                    Recieved_address <= 1'b1;
                end
            end
            READ_DATA:begin
                if(tx_valid == 1'b1)begin
                    rx_valid <=1'b0;    // send data to the master throgh MISO
                    if(counter > 0)begin
                        MISO <= tx_data[counter - 1];
                        counter  <= counter - 1;
                    end
                    else begin
                        Recieved_address <= 1'b0;
                    end
                end
                else begin  // reciving data from the MOSI
                    if(counter > 0)begin
                        rx_data[counter - 1] <= MOSI;
                        counter  <= counter - 1;
                    end
                    else begin
                        rx_valid <=1'b1;
                        counter <= 9;
                    end
                end
                
            end  
        endcase
    end
end
endmodule
