module Sign_Extend
(
    data_i,
    data_o
);

input [11:0] data_i;


output [31:0] data_o;

// assign data_o[11:0] = data_i;
// assign data_o[31:12] = (data[11] == 1'b0)? {20{1'b0}} : {20{1'b1}}; // sign extend depend on imm[11]

assign data_o = { {20{data_i[11]}}, data_i};

endmodule