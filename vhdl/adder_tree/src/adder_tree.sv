module adder_tree
#(
    parameter   NB_IN               = 8,
    parameter   IN_WIDTH            = 16,
    parameter   OUT_WIDTH           = IN_WIDTH+NB_IN,
    parameter   USE_PIPE            = 0
)
(
    input   wire                        clk,
    input   wire                        aresetn,

    input   wire [IN_WIDTH-1:0]         data_in[NB_IN-1:0],
    input   wire                        data_in_en,

    output  reg [OUT_WIDTH-1:0]        data_out,
    output  reg                        data_out_en

);

reg [OUT_WIDTH-1:0]        data_out_tmp;
integer i;

generate

    if (USE_PIPE==0) begin
        always @(posedge clk or negedge aresetn)
        begin
            if(!aresetn) begin
                data_out    <= { OUT_WIDTH {1'b0} };
                data_out_en <= 1'b0;
            end
            else begin
                data_out_tmp = 0;
                for(i=0;i<NB_IN;i++)begin
                    data_out_tmp = data_out_tmp+data_in[i];
                end
                data_out <= data_out_tmp;
                data_out_en <= data_in_en;
            end
        end
    end

    if (USE_PIPE==1) begin

        always @(posedge clk or negedge aresetn)
        begin
            if(!aresetn) begin
            end
            else begin
            end
        end
    end

endgenerate

endmodule