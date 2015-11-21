theory heap_lift_array
imports "../../AutoCorres"
begin

install_C_file "heap_lift_array.c"

autocorres "heap_lift_array.c"

end
