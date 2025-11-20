module SPI_Wrapper_tb ();

parameter MEM_DEPTH_tb = 256 ;
parameter ADDR_SIZE_tb = 8 ;

reg MOSI_tb,SS_n_tb,clk_tb,rst_n_tb;
wire MISO_dut;

SPI_Wrapper DUT(MOSI_tb,SS_n_tb,clk_tb,rst_n_tb,MISO_dut);

integer i,j;
reg [9:0] data;

integer flag;

initial begin
    clk_tb = 0;
    forever begin
       #1 clk_tb = ~ clk_tb ;
    end
end
initial begin
   $readmemh("mem.dat",DUT.ram.RAM);
   rst_n_tb = 0;
   MOSI_tb =0;
   SS_n_tb=1;
   flag = 0;
   data =0;
   @(negedge clk_tb);
   rst_n_tb = 1;
   // WRITE ADDRESS
   SS_n_tb = 0; // START COMMUNICATION
   MOSI_tb = 0;
   data[9:8] = 2'b00; 
   data[7:0] = 8'b0000_1111;
   repeat(2) @(negedge clk_tb); // first cycle cs goes from IDLE to CHK_CMD and the second cycle cs goes from CHK_CMD TO WRITE

   for(i=0;i<10;i=i+1)begin
      MOSI_tb = data[9-i];
      @(negedge clk_tb);
   end
   SS_n_tb  =1;   /// END COMMUNICATION
   @(negedge clk_tb);
   if(DUT.SPI.rx_data != data[9:0])begin
          $display("Error");
          $stop;
    end
    // WRITE data
    SS_n_tb = 0; // START COMMUNICATION
    MOSI_tb = 0;
    data[9:8] = 2'b01; 
    data[7:0] = 8'b0101_0011;
    repeat(2) @(negedge clk_tb); // first cycle cs goes from IDLE to CHK_CMD and the second cycle cs goes from CHK_CMD TO WRITE

    for(i=0;i<10;i=i+1)begin
       MOSI_tb = data[9-i];
       @(negedge clk_tb);
    end
    SS_n_tb  =1;   /// END COMMUNICATION
    @(negedge clk_tb);
    if(DUT.SPI.rx_data != data[9:0])begin
           $display("Error");
           $stop;
    end
    // READ ADDRESS
    SS_n_tb = 0; // START COMMUNICATION
    MOSI_tb = 1;
    data[9:8] = 2'b10; 
    data[7:0] = 8'b0000_1111;
    repeat(2) @(negedge clk_tb); // first cycle cs goes from IDLE to CHK_CMD and the second cycle cs goes from CHK_CMD TO READ_ADD

    for(i=0;i<10;i=i+1)begin 
       MOSI_tb = data[9-i];
       @(negedge clk_tb);
    end
    SS_n_tb  =1;   /// END COMMUNICATION
    @(negedge clk_tb);
    if(DUT.SPI.tx_data != DUT.ram.RAM[data[9:0]])begin
          $display("Error");
          $stop;
    end
    // READ DATA
    SS_n_tb = 0; // START COMMUNICATION
    MOSI_tb = 1;
    data[9:8] = 2'b11; 
    data[7:0] = 8'b0000_1111;
    repeat(2) @(negedge clk_tb); // first cycle cs goes from IDLE to CHK_CMD and the second cycle cs goes from CHK_CMD TO READ_DATA

    for(i=0;i<10;i=i+1)begin
       MOSI_tb = data[9-i];
       @(negedge clk_tb);
    end
    repeat(9) @(negedge clk_tb);
    SS_n_tb  =1;   /// END COMMUNICATION
    @(negedge clk_tb);
    if(DUT.SPI.tx_data != DUT.ram.RAM[data[9:0]])begin
          $display("Error");
          $stop;
    end
    $stop;
end
initial begin
    $monitor("MOSI_tb=%d,SS_n_tb=%d,rst_n_tb=%d,MISO_dut=%d,rx_data=%d,rx_valid=%d,tx_data=%d,tx_valid=%d"
    ,MOSI_tb,SS_n_tb,rst_n_tb,MISO_dut,DUT.rx_valid,DUT.rx_valid, DUT.tx_data,DUT.tx_valid);
end
endmodule
