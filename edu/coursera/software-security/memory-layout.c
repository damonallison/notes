#include <stdio.h>

int global; /* Uninitialized var stored in bss */

int two(void) {
  static int j = 100;
  return 1;
}
int main(void) {
  static int i = 100; /* Initialized static var stored in DS */
  return 0;
}
