module wallace_tree_multiplier_8x8(A, B, P);
	input [7:0] A, B;
	output [15:0] P;

	wire [7:0] ha_s, ha_c;
	wire [47:0] fa_s, fa_c;

	// Stage one.
	HA ha0((A[0]&B[1]), (A[1]&B[0]), ha_s[0], ha_c[0]);
	FA fa0((A[1]&B[1]), (A[2]&B[0]), ha_c[0], fa_s[0], fa_c[0]);
	FA fa1((A[2]&B[1]), (A[3]&B[0]), fa_c[0], fa_s[1], fa_c[1]);
	FA fa2((A[3]&B[1]), (A[4]&B[0]), fa_c[1], fa_s[2], fa_c[2]);
	FA fa3((A[4]&B[1]), (A[5]&B[0]), fa_c[2], fa_s[3], fa_c[3]);
	FA fa4((A[5]&B[1]), (A[6]&B[0]), fa_c[3], fa_s[4], fa_c[4]);
	FA fa5((A[7]&B[0]), (A[6]&B[1]), fa_c[4], fa_s[5], fa_c[5]);
	FA fa6((A[7]&B[1]), (A[6]&B[2]), fa_c[5], fa_s[6], fa_c[6]);
	FA fa7((A[7]&B[2]), (A[6]&B[3]), fa_c[6], fa_s[7], fa_c[7]);
	FA fa8((A[7]&B[3]), (A[6]&B[4]), fa_c[7], fa_s[8], fa_c[8]);
	FA fa9((A[7]&B[4]), (A[6]&B[5]), fa_c[8], fa_s[9], fa_c[9]);
	FA fa10((A[7]&B[5]), (A[6]&B[6]), fa_c[9], fa_s[10], fa_c[10]);
	FA fa11((A[7]&B[6]), (A[6]&B[7]), fa_c[10], fa_s[11], fa_c[11]);
	FA fa12((A[7]&B[7]), fa_c[11], fa_c[23], fa_s[12], fa_c[12]);

	// Stage two.
	HA ha1(fa_s[0], (A[0]&B[2]), ha_s[1], ha_c[1]);
	FA fa13(fa_s[1], (A[1]&B[2]), ha_c[1], fa_s[13], fa_c[13]);
	FA fa14(fa_s[2], (A[2]&B[2]), fa_c[13], fa_s[14], fa_c[14]);
	FA fa15(fa_s[3], (A[3]&B[2]), fa_c[14], fa_s[15], fa_c[15]);
	FA fa16(fa_s[4], (A[4]&B[2]), fa_c[15], fa_s[16], fa_c[16]);
	FA fa17(fa_s[5], (A[5]&B[2]), fa_c[16], fa_s[17], fa_c[17]);
	FA fa18(fa_s[6], (A[5]&B[3]), fa_c[17], fa_s[18], fa_c[18]);
	FA fa19(fa_s[7], (A[5]&B[4]), fa_c[18], fa_s[19], fa_c[19]);
	FA fa20(fa_s[8], (A[5]&B[5]), fa_c[19], fa_s[20], fa_c[20]);
	FA fa21(fa_s[9], (A[5]&B[6]), fa_c[20], fa_s[21], fa_c[21]);
	FA fa22(fa_s[10], (A[5]&B[7]), fa_c[21], fa_s[22], fa_c[22]);
	FA fa23(fa_s[11], fa_c[22], fa_c[32], fa_s[23], fa_c[23]);

	// Stage three.
	HA ha2(fa_s[13], (A[0]&B[3]), ha_s[2], ha_c[2]);
	FA fa24(fa_s[14], (A[1]&B[3]), ha_c[2], fa_s[24], fa_c[24]);
	FA fa25(fa_s[15], (A[2]&B[3]), fa_c[24], fa_s[25], fa_c[25]);
	FA fa26(fa_s[16], (A[3]&B[3]), fa_c[25], fa_s[26], fa_c[26]);
	FA fa27(fa_s[17], (A[4]&B[3]), fa_c[26], fa_s[27], fa_c[27]);
	FA fa28(fa_s[18], (A[4]&B[4]), fa_c[27], fa_s[28], fa_c[28]);
	FA fa29(fa_s[19], (A[4]&B[5]), fa_c[28], fa_s[29], fa_c[29]);
	FA fa30(fa_s[20], (A[4]&B[6]), fa_c[29], fa_s[30], fa_c[30]);
	FA fa31(fa_s[21], (A[4]&B[7]), fa_c[30], fa_s[31], fa_c[31]);
	FA fa32(fa_s[22], fa_c[31], fa_c[39], fa_s[32], fa_c[32]);

	// Stage four.
	HA ha3(fa_s[24], (A[0]&B[4]), ha_s[3], ha_c[3]);
	FA fa33(fa_s[25], (A[1]&B[4]), ha_c[3], fa_s[33], fa_c[33]);
	FA fa34(fa_s[26], (A[2]&B[4]), fa_c[33], fa_s[34], fa_c[34]);
	FA fa35(fa_s[27], (A[3]&B[4]), fa_c[34], fa_s[35], fa_c[35]);
	FA fa36(fa_s[28], (A[3]&B[5]), fa_c[35], fa_s[36], fa_c[36]);
	FA fa37(fa_s[29], (A[3]&B[6]), fa_c[36], fa_s[37], fa_c[37]);
	FA fa38(fa_s[30], (A[3]&B[7]), fa_c[37], fa_s[38], fa_c[38]);
	FA fa39(fa_s[31], fa_c[38], fa_c[44], fa_s[39], fa_c[39]);

	// Stage five.
	HA ha4(fa_s[33], (A[0]&B[5]), ha_s[4], ha_c[4]);
	FA fa40(fa_s[34], (A[1]&B[5]), ha_c[4], fa_s[40], fa_c[40]);
	FA fa41(fa_s[35], (A[2]&B[5]), fa_c[40], fa_s[41], fa_c[41]);
	FA fa42(fa_s[36], (A[2]&B[6]), fa_c[41], fa_s[42], fa_c[42]);
	FA fa43(fa_s[37], (A[2]&B[7]), fa_c[42], fa_s[43], fa_c[43]);
	FA fa44(fa_s[38], fa_c[43], fa_c[47], fa_s[44], fa_c[44]);

	// Stage six.
	HA ha5(fa_s[40], (A[0]&B[6]), ha_s[5], ha_c[5]);
	FA fa45(fa_s[41], (A[1]&B[6]), ha_c[5], fa_s[45], fa_c[45]);
	FA fa46(fa_s[42], (A[1]&B[7]), fa_c[45], fa_s[46], fa_c[46]);
	FA fa47(fa_s[43], fa_c[46], ha_c[7], fa_s[47], fa_c[47]);

	// Stage seven.
	HA ha6(fa_s[45], (A[0]&B[7]), ha_s[6], ha_c[6]);
	HA ha7(fa_s[46], ha_c[6], ha_s[7], ha_c[7]);

	// Output.
	assign P[0] = A[0] & B[0];
	assign P[1] = ha_s[0];
	assign P[2] = ha_s[1];
	assign P[3] = ha_s[2];
	assign P[4] = ha_s[3];
	assign P[5] = ha_s[4];
	assign P[6] = ha_s[5];
	assign P[7] = ha_s[6];
	assign P[8] = ha_s[7];
	assign P[9] = fa_s[47];
	assign P[10] = fa_s[44];
	assign P[11] = fa_s[39];
	assign P[12] = fa_s[32];
	assign P[13] = fa_s[23];
	assign P[14] = fa_s[12];
	assign P[15] = fa_c[12];
	
endmodule