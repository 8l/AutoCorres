theory while_loop_no_vars
imports "../../AutoCorres"
begin

install_C_file "while_loop_no_vars.c"

autocorres "while_loop_no_vars.c"

end
