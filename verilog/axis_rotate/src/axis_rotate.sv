// -----------------------------------------------------------------------------
// File Name: axis_rotate.sv
// Author: Jerome F.
// Date: 28-June-2024
// -----------------------------------------------------------------------------
// Description: AXI Stream left and right data rotation
//
// s_axis_tuser[USER_WIDTH-1:0]:
//      - s_axis_tuser[USER_WIDTH-1 : log2(DATA_WIDTH/8)+1]: Unused
//      - s_axis_tuser[log2(DATA_WIDTH/8)]: 1'b0 rotate left; 1'b1 rotate right;
//      - s_axis_tuser[log2(DATA_WIDTH/8)-1:0]: Number of rotations in bytes 
//
// Example:     - To rotate left by 3 : s_axis_tuser=3;
//              - To rotate right by 3 : s_axis_tuser=DATA_WIDTH/8+3 = 8+3 = 11
//

module axis_rotate
#(
    parameter   DATA_WIDTH          = 64,
    parameter   USER_WIDTH          = 64
)
(

    input   logic                       aclk,
    input   logic                       aresetn,
    
    input   logic   [DATA_WIDTH-1:0]    s_axis_tdata,
    input   logic   [USER_WIDTH-1:0]    s_axis_tuser,
    input   logic                       s_axis_tvalid,
    output  logic                       s_axis_tready,
    input   logic                       s_axis_tlast,
    input   logic   [DATA_WIDTH/8-1:0]  s_axis_tkeep,


    output   logic  [DATA_WIDTH-1:0]    m_axis_tdata,
    output   logic  [USER_WIDTH-1:0]    m_axis_tuser,
    output   logic                      m_axis_tvalid,
    input    logic                      m_axis_tready,
    output   logic                      m_axis_tlast,
    output   logic  [DATA_WIDTH/8-1:0]  m_axis_tkeep

);

logic s_axis_tready_int;
logic m_axis_tvalid_int;
integer i;

//Main process
always @(posedge aclk or negedge aresetn)
begin
    if(!aresetn) begin
    
        m_axis_tdata        <= {DATA_WIDTH{1'b0}};
        m_axis_tuser        <= {USER_WIDTH{1'b0}};
        m_axis_tvalid_int   <= 1'b0;
        m_axis_tlast        <= 1'b0;
        m_axis_tkeep        <= {DATA_WIDTH/8{1'b0}};
        
    end
    else begin
    
        if (s_axis_tready_int==1'b1) begin
        
            m_axis_tvalid_int   <= s_axis_tvalid;
            m_axis_tlast        <= s_axis_tlast;
            m_axis_tuser        <= s_axis_tuser;
            
            i = s_axis_tuser[$clog2(DATA_WIDTH/8)-1:0];

            // no rotate 
            if (s_axis_tuser[$clog2(DATA_WIDTH/8)-1:0]==0) begin
                m_axis_tdata <= s_axis_tdata;
                m_axis_tkeep <= s_axis_tkeep;
            end
            
            // rotate left
            if (s_axis_tuser[$clog2(DATA_WIDTH/8)]==1'b0) begin
                m_axis_tdata <= (s_axis_tdata << i*8) | (s_axis_tdata >> DATA_WIDTH-i*8);
                m_axis_tkeep <= (s_axis_tkeep << i) | (s_axis_tkeep >> DATA_WIDTH/8-i);
            end
            
            // rotate right
            if (s_axis_tuser[$clog2(DATA_WIDTH/8)]==1'b1) begin
                m_axis_tdata <= (s_axis_tdata >> i*8) | (s_axis_tdata << DATA_WIDTH-i*8);
                m_axis_tkeep <= (s_axis_tkeep >> i) | (s_axis_tkeep << DATA_WIDTH/8-i);
            end
            
        end
    end
end

// Backpressure
assign s_axis_tready_int = m_axis_tready | ~m_axis_tvalid_int;

// Internal signals to outputs
assign s_axis_tready = s_axis_tready_int;
assign m_axis_tvalid = m_axis_tvalid_int;

endmodule