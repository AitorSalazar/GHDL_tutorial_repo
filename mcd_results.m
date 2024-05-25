
test_numbs = 5;
% Datos de entrada
a_hex = ["69", "38", "4b", "70", "54"];
b_hex = ["3f", "0e", "34", "2c", "6a"];
% ----------------------------------
pattern_a = zeros(1, test_numbs);
pattern_b = zeros(1, test_numbs);
pattern_res = zeros(1, test_numbs);
% ----------------------------------

for i = 1:test_numbs
    a_dec = hex2dec(a_hex(i));
    b_dec = hex2dec(b_hex(i));
    pattern_a(i) = a_dec;
    pattern_b(i) = b_dec;
    pattern_res(i) = gcd(a_dec, b_dec);
end

% Datos de salida
pattern_res_hex = dec2hex(pattern_res);    % está en desuso
%pattern_res_hex = compose("%X", pattern_res);
a_bin = dec2bin(hex2dec(a_hex));
b_bin = dec2bin(hex2dec(b_hex));
res_bin = dec2bin(pattern_res, 8);
