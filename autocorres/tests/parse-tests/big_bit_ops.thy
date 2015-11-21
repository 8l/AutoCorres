theory big_bit_ops
imports "../../AutoCorres"
begin

install_C_file "big_bit_ops.c"

autocorres "big_bit_ops.c"

end
