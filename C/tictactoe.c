#include <unistd.h>
#include <fcntl.h>
#include "functions.c"

/*
NOTES:
This will be the variant of the x86 program that still uses 
syscalls instead of the simpler methods like printf()
*/

char field[255];
char player_choice[255];
int turns[9];

// Messages needed for the game
char* welcome_msg = "WELCOME TO TICTACTOE\n";
char* wrong_input = "INPUT IS INCORRECT, TRY AGAIN: ";
char* impossible_move = "THIS MOVE IS IMPOSSIBLE, TRY AGAIN: ";

char* x_turn = "PLAYER X, CHOOSE A POSITION: ";
char* o_turn = "PLAYER O, CHOOSE A POSITION: ";
char* draw = "GAME ENDS IN A DRAW!";
char* x_won = "PLAYER X WON!";
char* o_won = "PLAYER O WON!";

// int field_offsets = {2,6,10,26,30,34,50,54,58};

void readField(char *buff){
  char* filename = "../field.txt";

  int fd = open(filename, O_RDONLY);
  read(fd, buff, 255);
}

// void turn(char player, int id){
// }

int main(){
  readField(field);
  write(STDOUT_FILENO, field, 255);

  print(welcome_msg);

  return 0;
}

