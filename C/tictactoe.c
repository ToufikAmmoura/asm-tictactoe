#include <unistd.h>
#include <fcntl.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

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

int field_offsets[] = {2,6,10,26,30,34,50,54,58};

// Variables needed for the game
int coordinate = 0;
int offset = 0;

void readField(char *buff){
  char* filename = "../field.txt";

  int fd = open(filename, O_RDONLY);
  read(fd, buff, 255);
}

void placeChar(char c){
  int offset = field_offsets[coordinate];
  field[offset] = c;
  return;
}

void updateTurnsArray(int id){
  turns[coordinate] = id;
  return;
}

bool verifyTurn(){
  return turns[coordinate] == 0;
}

bool checkAndParseInput(){
  char c = player_choice[0];
  if(c < '0' || '9' < c)
    return false;

  coordinate = ((int)c)-49;

  return true;
}

void turn(char* message, char c, int id){
  bool stop = false;
  
  do{
    printf("%s", message);
    scanf("%255s", player_choice);

    stop = checkAndParseInput();
    if(!stop){
      message = wrong_input;
      continue;
    }

    stop = verifyTurn();
    if(!stop){
      message = impossible_move;
      continue;
    }
  }while(!stop);
  
  updateTurnsArray(id);
  placeChar(c);
  printf("%s", field);
}

void setupEnding(int sum){
  return;
//   if(sum == 3){
//   }
//   else{
//   }
}

bool sumHor(){
  for(offset=0; offset<9; offset+=3){
    int sum = 0;
    for(int i=0; i<3; i++){
      sum += turns[i+offset]; 
    }
    if(sum == 3 || sum == -3){
      setupEnding(sum);
      return true;
    }
  }
  return false;
}

bool sumVer(){
  for(offset=0; offset<3; offset++){
    int sum = 0;
    for(int i=0; i<9; i+=3){
      sum += turns[i+offset];
    }
    if(sum == 3 || sum == -3){
      setupEnding(sum);
      return true;
    }
  }
  return false;
}

bool sumDia(){
  int sum = 0;

  sum = turns[0] + turns[4] + turns[8];
  if(sum == 3 || sum == -3){
      setupEnding(sum);
      return true;
  }

  sum = turns[2] + turns[4] + turns[6];
  if(sum == 3 || sum == -3){
      setupEnding(sum);
      return true;
  }

  return false;
}

bool referee(char* endmessage){
  bool winnerH, winnerV, winnerD;

  winnerH = sumHor();
  winnerV = sumVer();
  winnerD = sumDia();

  return !(winnerH || winnerV || winnerD);
}

int main(){
  bool playing = true;
  int count = 0;
  char* endmessage=draw;

  readField(field);
  printf("%s", field);
  
  // // dit kan echt wel beter tering, je moet een betere flow dan dit kunnen bedenken
  while(playing){
    turn(x_turn, 'X', 1);
    count++;
    if(count >= 5)
      playing = referee(endmessage);

    if(!playing || count == 9)
      break;

    turn(o_turn, 'O', -1);
    count++;
    if(count >= 5)
      playing = referee(endmessage);
  }

  printf("%s", endmessage);
  return 0;
}