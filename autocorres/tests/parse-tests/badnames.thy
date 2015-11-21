theory badnames
imports "../../AutoCorres"
begin

install_C_file "badnames.c"

autocorres "badnames.c"

end
