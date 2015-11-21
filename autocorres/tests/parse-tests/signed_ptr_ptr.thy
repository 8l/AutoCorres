theory signed_ptr_ptr
imports "../../AutoCorres"
begin

install_C_file "signed_ptr_ptr.c"

autocorres "signed_ptr_ptr.c"

end
