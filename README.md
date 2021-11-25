## tictactoe in x86 32-bit assembly

### functionality

 - speler 1 tegen speler 2
 - simpele print methode
 - input check

### program flow

  - welkom tekst printen

  - print veld
  - vraag speler X om positie te kiezen
  - check input
    - als input klopt: voer in
    - anders: vraag opnieuw
  - als 5 inputs zijn geweest: check of iemand heeft gewonnen

  - daarna vraag speler O
  - etc.

  - eind tekst printen

### Notes

 - gebruik field.txt om het veld te tekenen
 - je moet de middelste space verwijderen en dan X of O invoegen
 - we hebben even een code cleanup nodig


### Calculations

  - A1 = field+84
  - constant = 84
  - horizontal = 4
  - vertical = 32

### Referee

  - kan het diagonale deel hard coden

  add   eax, [arr]
  add   eax, [arr+4]
  add   eax, [arr+8]
  cmp   eax, 3
  je    playerXwon
  cmp   eax, -3
  je    playerOwon

  1 1 1 0 0 1 1 1 0

### Flow

 - we plaatsen 'X' of 'O' in een memory place
 - we plaatsen '1' of '-1' in een memory place
 - roep _turn, gezien turnX en turnO eigenlijk toch hetzelfde zijn

