module FA(a, b, c_in, s, c_out);
    input a, b, c_in;
    output s, c_out;

    assign s = a^b^c_in;
    assign c_out = (a&b)|(a&c_in)|(b&c_in);
endmodule

