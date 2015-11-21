theory unliftable_call
imports "../../AutoCorres"
begin

install_C_file "unliftable_call.c"

autocorres "unliftable_call.c"

end
