`timescale 1ns / 1ps

module adder_tree_tb();

// Parameters
parameter NB_IN=4;
parameter IN_WIDTH=32;
parameter OUT_WIDTH=NB_IN+IN_WIDTH;
parameter USE_PIPE=0;

// DUT Signals
reg                             clk;
reg                             aresetn;
reg [IN_WIDTH-1:0]              data_in[NB_IN-1:0];
reg                             data_in_en;
wire [OUT_WIDTH-1:0]            data_out;
wire                            data_out_en;

// FILE Read signals
integer fid_in;
integer read_fid_in;
reg [IN_WIDTH-1:0] read_data;

// FILE Read signals
integer fid_out;

// Loop signal
integer i;


// DUT
adder_tree 
#(
    .NB_IN               (NB_IN),
    .IN_WIDTH            (IN_WIDTH),
    .OUT_WIDTH           (OUT_WIDTH),
    .USE_PIPE            (USE_PIPE)
)
adder_tree_inst
(
    .clk                (clk         ),                
    .aresetn            (aresetn     ),
    .data_in            (data_in     ),
    .data_in_en         (data_in_en  ),
    .data_out           (data_out    ),
    .data_out_en        (data_out_en ) 
);

// Clock
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

// Reset
initial begin
    aresetn = 1'b1;
    #100
    aresetn = 1'b0;
    #100
    aresetn = 1'b1;
end

// Main
initial begin
    // Open the file
    fid_in=$fopen("stim_in.txt", "r");
    if (fid_in == 0) begin
        $display("fid_in from file read is null");
        $finish;
    end

    // Wait for reset release
    #10
    @(posedge aresetn);
    @(posedge clk);
    data_in_en = 1'b0;

    // Read the file and feed the DUT
    while (!$feof(fid_in)) begin
        @(posedge clk);
        for(i=0;i<NB_IN;i++)begin
            $fscanf(fid_in, "%d\n", read_data);
            data_in[i] = read_data;
            $display("read file i=%d data: %d", i, read_data);
        end
        data_in_en = 1'b1;
        @(posedge clk);
        data_in_en = 1'b0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
    end

    // Close the file
    $fclose(fid_in);

    #1000;
    $finish;

end

// Save to a file
initial begin
    fid_out= $fopen("stim_out.txt","w");
    forever begin
        @(posedge clk);
        if (data_out_en==1) begin
            //$fwrite(fid_out, data_out);
            $fwrite(fid_out, "%d\n",data_out);
        end
    end
end



endmodule