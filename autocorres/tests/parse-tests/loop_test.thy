theory loop_test
imports "../../AutoCorres"
begin

install_C_file "loop_test.c"

autocorres "loop_test.c"

end
