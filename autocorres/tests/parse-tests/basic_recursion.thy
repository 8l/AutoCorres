theory basic_recursion
imports "../../AutoCorres"
begin

install_C_file "basic_recursion.c"

autocorres "basic_recursion.c"

end
