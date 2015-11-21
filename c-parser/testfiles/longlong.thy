(*
 * Copyright 2014, NICTA
 *
 * This software may be distributed and modified according to the terms of
 * the BSD 2-Clause license. Note that NO WARRANTY is provided.
 * See "LICENSE_BSD2.txt" for details.
 *
 * @TAG(NICTA_BSD)
 *)

theory longlong
imports "../CTranslation"
begin

install_C_file "longlong.c"

ML {* NameGeneration.return_var_name (Absyn.Signed Absyn.LongLong) *}


context longlong
begin

thm f_body_def
thm shifts1_body_def
thm shifts2_body_def

lemma "(ucast :: 16 word \<Rightarrow> 8 word) 32768 = 0"
apply simp
done

lemma "(scast :: 16 word \<Rightarrow> 8 word) 32768 = 0"
by simp

lemma "(scast :: 16 word \<Rightarrow> 8 word) 65535 = 255"
by simp

lemma "(ucast :: 16 word \<Rightarrow> 8 word) 65535 = 255"
by simp

lemma "(ucast :: 16 word \<Rightarrow> 8 word) 32767 = 255" by simp
lemma "(scast :: 16 word \<Rightarrow> 8 word) 32767 = 255" by simp

lemma "(scast :: 8 word \<Rightarrow> 16 word) 255 = 65535" by simp
lemma "(ucast :: 8 word \<Rightarrow> 16 word) 255 = 255" by simp

lemma sint_1 [simp]: "1 < len_of TYPE('a) \<Longrightarrow> sint (1 :: 'a::len word) = 1"
apply (subgoal_tac "1 \<in> sints (len_of TYPE ('a))")
  defer
  apply (simp add: sints_num)
  apply (rule order_trans [where y = 0])
    apply simp
  apply simp
  apply (drule Word.word_sint.Abs_inverse)
  apply (simp add: Word.word_of_int_hom_syms)
done

lemma g_result:
  "\<Gamma> \<turnstile> \<lbrace> True \<rbrace> \<acute>ret__int :== CALL callg() \<lbrace> \<acute>ret__int = 0 \<rbrace>"
apply vcg
apply (simp add: max_word_def)
done

thm literals_body_def

lemma literals_result:
  "\<Gamma> \<turnstile> \<lbrace> True \<rbrace> \<acute>ret__int :== CALL literals() \<lbrace> \<acute>ret__int = 31 \<rbrace>"
apply vcg
apply simp
done

end (* context *)

end (* theory *)
