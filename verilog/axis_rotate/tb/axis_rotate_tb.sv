`timescale 1ns / 1ps

module axis_rotate_tb();

// Parameters
parameter DATA_WIDTH=64;
parameter USER_WIDTH=64;

// DUT Signals
logic                       aclk;
logic                       aresetn;

logic   [DATA_WIDTH-1:0]    s_axis_tdata;
logic   [USER_WIDTH-1:0]    s_axis_tuser;
logic                       s_axis_tvalid;
logic                       s_axis_tready;
logic                       s_axis_tlast;
logic   [DATA_WIDTH/8-1:0]  s_axis_tkeep;

logic  [DATA_WIDTH-1:0]     m_axis_tdata;
logic  [USER_WIDTH-1:0]     m_axis_tuser;
logic                       m_axis_tvalid;
logic                       m_axis_tready;
logic                       m_axis_tlast;
logic  [DATA_WIDTH/8-1:0]   m_axis_tkeep;


// DUT
axis_rotate 
#(
    .DATA_WIDTH                 (DATA_WIDTH),
    .USER_WIDTH                 (USER_WIDTH)
)
axis_rotate_inst
(
    .aclk                       (aclk),
    .aresetn                    (aresetn),
    .s_axis_tdata               (s_axis_tdata),
    .s_axis_tuser               (s_axis_tuser),
    .s_axis_tvalid              (s_axis_tvalid),
    .s_axis_tready              (s_axis_tready),
    .s_axis_tlast               (s_axis_tlast),
    .s_axis_tkeep               (s_axis_tkeep),
    .m_axis_tdata               (m_axis_tdata),
    .m_axis_tuser               (m_axis_tuser),
    .m_axis_tvalid              (m_axis_tvalid),
    .m_axis_tready              (m_axis_tready),
    .m_axis_tlast               (m_axis_tlast),
    .m_axis_tkeep               (m_axis_tkeep)
);

// Clock
initial begin
    aclk = 1'b0;
    forever #5 aclk = ~aclk;
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

    // Initialize signals
    s_axis_tdata <= 0;
    s_axis_tuser <= 1;
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    s_axis_tkeep <= 0;
    m_axis_tready<= 1'b0;
    

    // Wait for reset release
    #10
    @(posedge aresetn);
    @(posedge aclk);

    
    // Rotate 1 left
    #100;
    @(posedge aclk);
    s_axis_tvalid <= 1'b1;  // slave write
    s_axis_tdata  <= 64'h0102030405060708;
    s_axis_tkeep  <= 8'h01;
    s_axis_tuser <= 1;
    @(posedge aclk);
    s_axis_tvalid <= 1'b0;
    @(posedge aclk);
    m_axis_tready <= 1'b1; // master read
    @(posedge aclk);
    m_axis_tready <= 1'b0;
    
    // Rotate 1 right
    #100;
    @(posedge aclk);
    s_axis_tvalid <= 1'b1;  // slave write
    s_axis_tdata  <= 64'h0102030405060708;
    s_axis_tkeep  <= 8'h01;
    s_axis_tuser <= 9;
    @(posedge aclk);
    s_axis_tvalid <= 1'b0;
    @(posedge aclk);
    m_axis_tready <= 1'b1; // master read
    @(posedge aclk);
    m_axis_tready <= 1'b0;
    
    // Rotate 2 left
    #100;
    @(posedge aclk);
    s_axis_tvalid <= 1'b1;  // slave write
    s_axis_tdata  <= 64'h0102030405060708;
    s_axis_tkeep  <= 8'h01;
    s_axis_tuser <= 2;
    @(posedge aclk);
    s_axis_tvalid <= 1'b0;
    @(posedge aclk);
    m_axis_tready <= 1'b1; // master read
    @(posedge aclk);
    m_axis_tready <= 1'b0;
    
    // Rotate 2 right
    #100;
    @(posedge aclk);
    s_axis_tvalid <= 1'b1;  // slave write
    s_axis_tdata  <= 64'h0102030405060708;
    s_axis_tkeep  <= 8'h01;
    s_axis_tuser <= 10;
    @(posedge aclk);
    s_axis_tvalid <= 1'b0;
    @(posedge aclk);
    m_axis_tready <= 1'b1; // master read
    @(posedge aclk);
    m_axis_tready <= 1'b0;

    #1000;
    $stop;

end

endmodule