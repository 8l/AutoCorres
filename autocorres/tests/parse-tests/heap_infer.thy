theory heap_infer
imports "../../AutoCorres"
begin

install_C_file "heap_infer.c"

autocorres "heap_infer.c"

end
