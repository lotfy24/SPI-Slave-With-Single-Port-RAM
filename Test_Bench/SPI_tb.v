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
   // TEST WRITE OPERATION
   for(i=0;i<49;i=i+1)begin
    // START COMMUNICATION 
        SS_n_tb = 0;
        MOSI_tb = 0;
        repeat(2) @(negedge clk_tb);
        if(flag == 0)begin
          data[9:8] = 0;
          flag = 1;
        end
        else begin
           data [9:8] = 1;
           flag = 0;
        end
         
        for(j=0;j<=1;j=j+1)begin
          MOSI_tb = data[9-j];
          @(negedge clk_tb);
        end
        data[7:0] = $random;

          for(j=0;j<=7;j=j+1)begin
          MOSI_tb = data[7-j];
          @(negedge clk_tb);
        end  
        if(DUT.SPI.rx_data != data[9:0])begin
          $display("Error");
          $stop;
        end
        SS_n_tb = 1;        // END COMMUNICATION
         @(negedge clk_tb);
   end
   // TEST READ OPERATION
    flag =2;
   for(i=0;i<49;i=i+1)begin
     // START COMMUNICATION 
        SS_n_tb = 0;
        MOSI_tb = 1;
        repeat(2) @(negedge clk_tb);
        if(flag == 2)begin
          data[9:8] = 2;
          flag = 3;
        end
        else begin
           data [9:8] = 3;
           flag = 2;
        end
        for(j=0;j<=1;j=j+1)begin
          MOSI_tb = data[9-j];
          @(negedge clk_tb);
        end
            data[7:0] = $random;
          for(j=0;j<=7;j=j+1)begin
          MOSI_tb = data[7-j];
          @(negedge clk_tb);
        end  
        if(DUT.SPI.tx_data != DUT.ram.RAM[data[9:0]])begin
          $display("Error");
          $stop;
        end
        SS_n_tb = 1;        // END COMMUNICATION
         @(negedge clk_tb);
   end
    $stop;
end
  
initial begin
    $monitor("MOSI_tb=%d,SS_n_tb=%d,rst_n_tb=%d,MISO_dut=%d,rx_data=%d,rx_valid=%d,tx_data=%d,tx_valid=%d"
    ,MOSI_tb,SS_n_tb,rst_n_tb,MISO_dut,DUT.rx_valid,DUT.rx_valid, DUT.tx_data,DUT.tx_valid);
end
endmodule
