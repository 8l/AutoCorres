(*
 * Copyright 2014, NICTA
 *
 * This software may be distributed and modified according to the terms of
 * the BSD 2-Clause license. Note that NO WARRANTY is provided.
 * See "LICENSE_BSD2.txt" for details.
 *
 * @TAG(NICTA_BSD)
 *)

theory Kmalloc
imports "../../AutoCorres"
begin

(* No proof here, just testing the parser. *)

consts
  KMC :: word32
  ptr_retyps :: "nat \<Rightarrow> word32 \<Rightarrow> heap_typ_desc \<Rightarrow> heap_typ_desc"

install_C_file "kmalloc.c"

autocorres "kmalloc.c"

context kmalloc begin

(* C parser output. *)
thm alloc_body_def
thm sep_alloc_body_def
thm free_body_def
thm sep_free_body_def

(* Abstracted output. *)
thm alloc'_def
thm sep_alloc'_def
thm free'_def
thm sep_free'_def

end

end
