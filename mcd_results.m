
test_numbs = 5;
% Datos de entrada
a_bin = ["69", "38", "4b", "70", "54"];
b_bin = ["3f", "0e", "34", "2c", "6a"];
% ----------------------------------
pattern_a = zeros(1, test_numbs);
pattern_b = zeros(1, test_numbs);
pattern_res = zeros(1, test_numbs);
% ----------------------------------

for i = 1:test_numbs
    a_dec = hex2dec(a_bin(i));
    b_dec = hex2dec(b_bin(i));
    pattern_a(i) = a_dec;
    pattern_b(i) = b_dec;
    pattern_res(i) = gcd(a_dec, b_dec);
end

% Datos de salida
pattern_res_hex = dec2hex(pattern_res);    % está en desuso
%pattern_res_hex = compose("%X", pattern_res);