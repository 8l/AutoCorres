(*
 * Copyright 2014, NICTA
 *
 * This software may be distributed and modified according to the terms of
 * the BSD 2-Clause license. Note that NO WARRANTY is provided.
 * See "LICENSE_BSD2.txt" for details.
 *
 * @TAG(NICTA_BSD)
 *)

(*<*)
theory Chapter1_MinMax
imports "../../AutoCorres"
begin
(*>*)


section {* Introduction *}

text {*

  AutoCorres is a tool that attempts to simplify the formal verification of C
  programs in the Isabelle/HOL theorem prover. It allows C code
  to be automatically abstracted to produce a higher-level functional
  specification.

  AutoCorres relies on the C-Parser~\cite{CParser_download} developed by Michael Norrish
  at NICTA. This tool takes raw C code as input and produces a translation in
  SIMPL~\cite{Simpl-AFP}, an imperative language written by Norbert Schirmer on top
  of Isabelle. AutoCorres takes this SIMPL code to produce a "monadic"
  specification, which is intended to be simpler to reason about in Isabelle.
  The composition of these two tools (AutoCorres applied after the C-Parser) can
  then be used to reason about C programs.

  This guide is written for users of Isabelle/HOL, with some knowledge of C, to
  get started proving properties of C programs. Using AutoCorres in conjunction
  with the verification condition generator (VCG) \texttt{wp}, one
  should be able to do this without an understanding of SIMPL nor of the monadic
  representation produced by AutoCorres. We will see how this is possible in the
  next chapter.

*}

section  {* A First Proof with AutoCorres *}

text {*

  We will now show how to use these tools to prove correctness of some very
  simple C functions.

*}

subsection {* Two simple functions: \texttt{min} and \texttt{max} *}

text {*

  Consider the following two functions, defined in a file \texttt{minmax.c},
  which (we expect) return the minimum and maximum respectively of two unsigned
  integers.

  \lstinputlisting[language=C, firstline=7]{../../minmax.c}

  It is easy to see that \texttt{min} is correct, but perhaps less obvious why
  \texttt{max} is correct. AutoCorres will hopefully allow us to prove these
  claims without too much effort.

*}

subsection {* Invoking the C-parser *}

text {*

  As mentioned earlier, AutoCorres does not handle C code directly. The first
  step is to apply the
  C-Parser\footnote{\url{http://ssrg.nicta.com.au/software/TS/c-parser}} to
  obtain a SIMPL translation. We do this using the \texttt{install-C-file}
  command in Isabelle, as shown.

*}

install_C_file "minmax.c"

(* FIXME: Be consistent with \texttt and \emph *)
text {*

  For every function in the C source file, the C-Parser generates a
  corresponding Isabelle definition. These definitions are placed in an Isabelle
  "locale", whose name matches the input filename. For our file \emph{minmax.c},
  the C-Parser will place definitions in the locale \emph{minmax}.\footnote{The
  C-parser uses locales to avoid having to make certain assumptions about the
  behaviour of the linker, such as the concrete addresses of symbols in your
  program.}

  For our purposes, we just have to remember to enter the appropriate locale
  before writing our proofs. This is done using the \texttt{context} keyword in
  Isabelle.

  Let's look at the C-Parser's outputs for \texttt{min} and \texttt{max}, which
  are contained in the theorems \texttt{min\_body\_def} and \texttt{max\_body\_def}.
  These are simply definitions of the generated names \emph{min\_body} and
  \emph{max\_body}. We can also see here how our work is wrapped within the
  \emph{minmax} context.

*}

context minmax begin

  thm min_body_def
  text {* @{thm [display] min_body_def} *}
  thm max_body_def
  text {* @{thm [display] max_body_def} *}

end

text {*

  The definitions above show us the SIMPL generated for each of the
  functions; we can see that C-parser has translated \texttt{min} and
  \texttt{max} very literally and no detail of the C language has been
  omitted. For example:

  \begin{itemize}
    \item  C \texttt{return} statements have been translated into
           exceptions which are caught at the outside of the
           function's body;

    \item  \emph{Guard} statements are used to ensure that behaviour
           deemed `undefined' by the C standard does not occur. In the
           above functions, we see that a guard statement is emitted
           that ensures that program execution does not hit the end
           of the function, ensuring that we always return a value
           (as is required by all non-\texttt{void} functions).

    \item  Function parameters are modelled as local variables, which
           are setup prior to a function being called. Return variables
           are also modelled as local variables, which are then
           read by the caller.
  \end{itemize}

  While a literal translation of C helps to improve confidence that the
  translation is sound, it does tend to make formal reasoning an arduous
  task.

*}

subsection {* Invoking AutoCorres *}

text {*

  Now let's use AutoCorres to simplify our functions. This is done using
  the \texttt{autocorres} command, in a similar manner to the
  \texttt{install\_C\_file} command:

*}

autocorres "minmax.c"

text {*

  AutoCorres produces a definition in the \texttt{minmax} locale
  for each function body produced by the C parser. For example,
  our \texttt{min} function is defined as follows:

*}
context minmax begin
thm min'_def
text {* @{thm [display] min'_def} *}

text {*

  Each function's definition is named identically to its name in
  C, but with a prime mark (\texttt{'}) appended. For example,
  our functions \texttt{min} above was named @{term min'}, while
  the function \texttt{foo\_Bar} would be named @{term foo_Bar'}.

  AutoCorres does not require you to trust its translation is sound,
  but also emits a \emph{correspondence} or \emph{refinement} proof,
  as follows:

*}

(* FIXME *)
(* thm min_autocorres *)

text {*

  Informally, this theorem states that, assuming the abstract function
  @{term min'} can be proven to not fail for a partciular input, then
  for the associated input, the concrete C SIMPL program also will not
  fault, will always terminate, and will have a corresponding end state
  to the generated abstract program.

  For more technical details, see~\cite{Greenaway_AK_12} and~\cite{Greenaway_LAK_14}.

*}

subsection {* Verifying \texttt{min} *}

text {*

  In the abstracted version of @{term min'}, we can see that AutoCorres
  has simplified away the local variable reads and writes in the
  C-parser translation of \texttt{min}, simplified away the exception
  throwing and handling code, and also simplified away the unreachable
  guard statement at the end of the function. In fact, @{term min'} has
  been simplified to the point that it exactly matches Isabelle's
  built-in function @{term min}:

*}
thm min_def
text {* @{thm [display] min_def} *}

text {*
  So, verifying @{term min'} (and by extension, the C function
  \texttt{min}) should be easy:
*}
lemma min'_is_min: "min' a b = min a b"
  unfolding min_def min'_def
  by (rule refl)

subsection {* Verifying \texttt{max} *}

text {*

  Now we also wish to verify that @{term max'} implements the built-in
  function @{term max}. @{term min'} was nearly too simple to bother
  verifying, but @{term max'} is a bit more complicated. Let's look at
  AutoCorres' output for \texttt{max}:

*}
thm max'_def
text {* @{thm [display] max'_def} *}

text {*

  At this point, you might still doubt that @{term max'} is indeed
  correct, so perhaps a proof is in order. The basic idea is that
  subtracting from \texttt{UINT\_MAX} flips the ordering of unsigned
  ints. We can then use @{term min'} on the flipped numbers to compute
  the maximum.

  The next lemma proves that subtracting from \texttt{UINT\_MAX} flips
  the ordering. To prove it, we convert all words to @{typ int}'s, which
  does not change the meaning of the statement.

  *}

  lemma n1_minus_flips_ord:
    "((a :: word32) \<le> b) = ((-1 - a) \<ge> (-1 - b))"
    apply (subst word_le_def)+
    apply (subst word_n1_ge [simplified uint_minus_simple_alt])+
    txt {* Now that our statement uses @{typ int}, we can apply Isabelle's built-in \texttt{arith} method. *}
    apply arith
    done

text {*
  And now for the main proof:
*}
  lemma max'_is_max: "max' a b = max a b"
    unfolding max'_def min'_def max_def
    using n1_minus_flips_ord
    by force

end

text {*
  In the next section, we will see how to use AutoCorres to simplify
  larger, more realistic C programs.
*}


(*<*)
end
(*>*)
