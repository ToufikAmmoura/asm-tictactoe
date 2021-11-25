%include "functions.asm"

SECTION .data
    filename    db  "field.txt", 0h

    welcome_msg     db  "WELCOME TO TICTACTOE", 0ah, 0h
    wrong_input     db  "INPUT IS INCORRECT, TRY AGAIN: ", 0h
    impossible_move db  "THIS MOVE IS IMPOSSIBLE, TRY AGAIN: ", 0h

    X_turn  db      "PLAYER X, CHOOSE A POSITION: ", 0h
    O_turn  db      "PLAYER O, CHOOSE A POSITION: ", 0h
    draw    db      "GAME ENDS IN A DRAW!", 0h
    X_won   db      "PLAYER X WON!", 0h
    O_won   db      "PLAYER O WON!", 0h

    field_offsets   db  2, 6, 10, 26, 30, 34, 50, 54, 58

SECTION .bss
    field           resb    255         ; holds the playfield with the made choices
    turns           resb    9           ; 2D mapped into 1D array of the made turns: 1 for X, -1 for O
    count           resb    1           ; counts turns made

    player_input    resb    255         ; large buffer in the case the user is stupid
    index           resb    1           ; the index chosen by the user
    offset          resb    1           ; the offset of the character that has to be placed in the field

    char            resb    1           ; will be 'X' or 'O'
    id              resb    1           ; will be  1  or -1

SECTION .text
global _start

_start:

    mov     eax, welcome_msg
    call    sprint

    call    _readField
    call    _printField

_setUpX:
    mov     byte [char], 'X'
    mov     byte [id], 1
    mov     eax, X_turn
    call    sprint
    jmp     _turn

_setUpO:
    mov     byte [char], 'O'
    mov     byte [id], -1
    mov     eax, O_turn
    call    sprint
    jmp     _turn

_turn:
    call    _takeInput
    call    _checkInput
    call    _parseInput

    call    _verifyTurn
    call    _updateTurnsArray
    
    call    _placeChar
    inc     byte [count]
    
    call    _printField

_referee:
    ; after 5 turns we begin checking if someone has won
    cmp     byte [count], 5
    jge     .checkWinner

.continueGame:
    ; when reaching 9 turns the game ends in a draw
    cmp     byte [count], 9
    je      _endGameInDraw

    ; checking the parity of count to know who is next
    test    byte [count], 1 
    jnz     _setUpO
    jz      _setUpX

.checkWinner:

    call    _horizontalCheck
    call    _verticalCheck
    call    _diagonalCheck

    jmp     .continueGame

; --------------------- ------------ ---------------------
; --------------------- needed funcs ---------------------
; --------------------- ------------ ---------------------

;------------------------------------------
; Reads the field from field.txt and saves it
_readField:
    ; opening the file -> file operand will end up in eax
    mov     eax, 5
    mov     ebx, filename
    mov     ecx, 0
    int     80h

    ; reading the file
    mov     ebx, eax        ; first move the file operand from eax to ebx
    mov     eax, 3
    mov     ecx, field
    mov     edx, 255
    int     80h

    ret

;------------------------------------------
; Reads 255 bytes from STDIN
_takeInput:
    mov     eax, 3
    mov     ebx, 1
    mov     ecx, player_input
    mov     edx, 255
    int     80h
    
    ret

;------------------------------------------
; Checks if the input of the user is valid
_checkInput:
    xor     edx, edx
    mov     dl, byte [player_input]

    cmp     dl, '1'
    jl      .wrong
    cmp     dl, '9'
    jg      .wrong

    jmp     .finished

.wrong:
    mov     eax, wrong_input
    call    sprint
    jmp     _turn

.finished:
    ret

;------------------------------------------
; Parsing the input to the integer, continues using what checkInput put in dl
_parseInput:
    mov     [index], dl
    sub     byte [index], 49

    ret

;------------------------------------------
; Verifies if the turn is not made on top of another turn
_verifyTurn:
    xor     eax, eax
    mov     al, [index]

    cmp     byte [turns+eax], 0
    jne     .wrong

    jmp     .finished

.wrong:
    mov     eax, impossible_move
    call    sprint
    jmp     _turn

.finished:
    ret

;------------------------------------------
; Will put the correct ID in the array
_updateTurnsArray:
    xor     eax, eax
    xor     ebx, ebx

    mov     al, [index]
    mov     bl, [id]

    mov     [turns+eax], bl
    ret

;------------------------------------------
; Places the character into the field
_placeChar:
    xor     eax, eax
    xor     ebx, ebx
    
    mov     al, [index]
    mov     bl, byte [field_offsets+eax]
    
    mov     cl, byte [char]

    mov     [field+ebx], cl
    ret

;------------------------------------------
; Loops through eacht horizontal row and checks the made moves
_horizontalCheck:

    xor     ebx, ebx
    xor     ecx, ecx

.loop:
    xor     eax, eax
    inc     ecx
    
    add     al, byte [turns+ebx]
    inc     ebx
    add     al, byte [turns+ebx]
    inc     ebx
    add     al, byte [turns+ebx]
    inc     ebx

    cmp     al, 3
    je      _winnerIsX
    cmp     al, -3
    je      _winnerIsO
    
    cmp     ecx, 9
    jl      .loop

    ret

;------------------------------------------
; Same as above but then vertical
_verticalCheck:

    xor     ebx, ebx
    xor     ecx, ecx

.loop:
    xor     eax, eax
    inc     ecx

    add     al, byte [turns+ebx]
    add     bl, 3
    add     al, byte [turns+ebx]
    add     bl, 3
    add     al, byte [turns+ebx]
    sub     bl, 5

    cmp     al, 3
    je      _winnerIsX
    cmp     al, -3
    je      _winnerIsO

    cmp     ecx, 9
    jl      .loop

    ret

;------------------------------------------
; Checks the diagonals in a hardcoded way because a loop for it is weird
_diagonalCheck:

    xor     eax, eax

    add     al, byte[turns]
    add     al, byte[turns+4]
    add     al, byte[turns+8]

    cmp     al, 3
    je      _winnerIsX
    cmp     al, -3
    je      _winnerIsO

    xor     eax, eax

    add     al, byte[turns+2]
    add     al, byte[turns+4]
    add     al, byte[turns+6]

    cmp     al, 3
    je      _winnerIsX
    cmp     al, -3
    je      _winnerIsO

    ret

;------------------------------------------
; Do these need a description??

_printField:
    mov     eax, field
    call    sprintLF
    ret

_winnerIsX:
    mov     eax, X_won
    jmp     _endGameWithWinner

_winnerIsO:
    mov     eax, O_won
    jmp     _endGameWithWinner

_endGameInDraw:
    mov     eax, draw
    call    sprintLF
    call    quit

_endGameWithWinner:
    call    sprintLF
    call    quit