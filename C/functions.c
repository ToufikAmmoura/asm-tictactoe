#include <unistd.h>
#include <fcntl.h>

/*
again a function file that needs some helper functions
*/

// prints from pointer till nullbyte
void print(char* ptr){
  int l = 0;
  char c;

  while(c != '\0'){
    c = ptr[l];
    l++;
  }

  write(STDOUT_FILENO, ptr, l);
}