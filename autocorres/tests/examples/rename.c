/*
 * rename.c: C file for AC_Rename.
 *
 * This code uses some inconvenient names. Its actual behaviour isn't important.
 */

int __real_var__;

int __get_real_var__(void) {
  return __real_var__;
}

void __set_real_var__(int x) {
  __real_var__ = x;
}

#define VAR (__get_real_var__())
