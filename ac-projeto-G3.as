global _start

section .data                ; variáveis e constantes
   EXIT_SUCCESS:   equ 0     ; código de saída sem erros
   SYS_exit:       equ 60    ; código da operação de saída (fim) do programa
   SYS_write:      equ 0x01  ; função escrever (print) 
   SYS_read:       equ 0x00  ; função ler (input) 
   StdIn:          equ 0x00  ; input standard (teclado) 
   StdOut:         equ 0x01  ; output standard (ecrã)
   LF:        equ 0x0A       ; caracter (ASCII) de controlo Line Feed
   CR:        equ 0x0D       ; caracter (ASCII) de controlo Carriage Return
   BS:        equ 0x08       ; caracter (ASCII) de controlo Backspace
   EoS:       equ 0x00       ; caracter (ASCII) de controlo NULL (fim de string)
  ; Definição das strings a escrever e a ler (e respetivos comprimentos)
   newLine:   db CR,LF,EoS   ; string de controlo: mover o cursor para o início da linha abaixo
   compNL:    equ $-newLine  ; comprimento da string newLine
  ; Definir string com várias linhas (no ecran)
  ; Retângulo de caracteres: no interior, linhas com as opções do menu
   menu:      db  "*****************************",CR,LF   ; cursor movido para início da linha abaixo
              db  "*                           *",CR,LF   ; 
              db  "*    1 - Escrever Número    *",CR,LF   ; 
              db  "*    2 - Configurações      *",CR,LF   ; 
              db  "*    0 - Terminar           *",CR,LF   ; 
              db  "*                           *",CR,LF   ; 
              db  "*****************************",CR,LF,EoS   ;  
   compMenu: equ $-menu   ; comprimento da string ecran (inclui EoS)
   menu2:     db  "*****************************",CR,LF   ; cursor movido para início da linha abaixo
              db  "*                           *",CR,LF   ; 
              db  "*    1 - Caracter           *",CR,LF   ; 
              db  "*    2 - Cor do Texto       *",CR,LF   ; 
              db  "*    3 - Cor de Fundo       *",CR,LF   ; 
              db  "*    4 - Comprimento        *",CR,LF   ; 
              db  "*    5 - Voltar atrás       *",CR,LF   ; 
              db  "*                           *",CR,LF   ; 
              db  "*****************************",CR,LF,EoS   ;  
   compMenu2: equ $-menu2    ; comprimento da string ecran (inclui EoS)   
   ; Definir string para pedir o input da opção escolhida
   opcEsc:    db "Opção escolhida? ", EoS
   compOpc:   equ $-opcEsc   ; comprimento da string opcEsc
   ; Definir string para receber o input da opção escolhida
   escolha:   db "?", EoS    ; string com espaço para ler 1 caracter + <enter>
   compEsc:   equ $-escolha  ; comprimento da string escolha
   ; Definir string para a opção terminar
   termina:   db "Opção lida: Terminar", EoS
   compTerm:  equ $-termina  ; comprimento da string termina
   ; Definir string para a opção errada
   errada:    db "Opção lida: Errada", EoS
   compErro:  equ $-errada  ; comprimento da string errada

; Definir as variáveis numéricas e strings necessárias
   lado:      db 5, EoS           ; 
   contorno:  db "#"         ;
   lerLado:   db "Número <0-9>", EoS
   compLado:  equ $-lerLado 
   espaco:    db ' '

section .text
_start:

inicio:
   cmp byte [escolha], "0"
   je  saida

; escrever a string newLine
   mov rax, SYS_write        ; função escrever 
   mov rdi, StdOut           ; output standard (ecrã)
   mov rsi, newLine          ; rsi <- endereço da string a escrever
   mov rdx, compNL           ; rdx <- nº de caracteres a escrever (até EoS)
   syscall                   ; chamada de função do SO (system call)
; escrever a string menu
   mov rax, SYS_write        ; função escrever 
   mov rdi, StdOut           ; output standard (ecrã)
   mov rsi, menu             ; rsi <- endereço da string a escrever
   mov rdx, compMenu         ; rdx <- nº de caracteres a escrever (até EoS)
   syscall                   ; chamada de função do SO (system call)
; escrever a string newLine
   mov rax, SYS_write        ; função escrever 
   mov rdi, StdOut           ; output standard (ecrã)
   mov rsi, newLine          ; rsi <- endereço da string a escrever
   mov rdx, compNL           ; rdx <- nº de caracteres a escrever (até EoS)
   syscall                   ; chamada de função do SO (system call)
; escrever a string opcEsc
   mov rax, SYS_write        ; função escrever 
   mov rdi, StdOut           ; output standard (ecrã)
   mov rsi, opcEsc           ; rsi <- endereço da string a escrever
   mov rdx, compOpc          ; rdx <- nº de caracteres a escrever (até EoS)
   syscall                   ; chamada de função do SO (system call)
; ler caracteres para a string escolha (<enter> incluído)
   mov rax, SYS_read         ; função ler 
   mov rdi, StdIn            ; input standard (teclado)
   mov rsi, escolha          ; rsi <- endereço da string a ler
   mov rdx, compEsc          ; rdx <- nº máximo de caracteres para ler
   syscall                   ; chamada de função do SO (system call)
; identifica a escolha lida
   cmp byte [escolha], "1"
   je escolha1
   cmp byte [escolha], "2"
   je escolha2
   cmp byte [escolha], "0"
   je  escolha0              
   jmp escolhaE              ; escolha não válida (errada)

escolha1:

; Ler um carácter (algarismo)
   mov rsi, lerLado
   mov rdx, compLado
   call escrever
   mov rax, SYS_read         ; função ler 
   mov rdi, StdIn            ; input standard (teclado)
   mov rsi, lado             ; rsi <- endereço da string a ler
   mov rdx, 2                ; rdx <- nº máximo de caracteres para ler
   syscall                   ; chamada de função do SO (system call)

   ; Obter o valor numérico do algarismo
   sub byte [lado], 48>

   ; Escrever uma linha de caracteres repetindo o carácter lido um nº de vezes igual ao valor do algarismo lido
   mov ch, 0
   repete2:
   cmp ch, byte [lado]
   jae terminaciclo2

      mov cl, 0
   repete:
      cmp cl, byte [lado]
      jae terminaciclo
         mov rsi, contorno         ; rsi <- endereço da string a escrever
         mov rdx, 1                ; rdx <- nº de caracteres a escrever (até EoS)
         push rcx                  ; guarda valor de rcx na stack
         call escrever             ; chamada da função
         pop rcx                   ; retira valor de tcx na stack
         inc cl
         jmp repete
   terminaciclo:
      mov rsi, newLine          ; rsi <- endereço da string a escrever
      mov rdx, compNL           ; rdx <- nº de caracteres a escrever (até EoS)
      push rcx                  ; guarda valor de rcx na stack
      call escrever             ; chamada da função
      pop rcx                   ; retira valor de tcx na stack

   inc ch
   jmp repete2
   terminaciclo2:


; Função de spaçoes entre caracteres
   mov ch, 2
   repete4:
   cmp ch, byte [lado]
   jae terminaciclo4
   mov rsi, contorno         ; rsi <- endereço da string a escrever
         mov rdx, 1                ; rdx <- nº de caracteres a escrever (até EoS)
         push rcx                  ; guarda valor de rcx na stack
         call escrever             ; chamada da função
         pop rcx   
   mov cl, 2
   repete3:
      cmp cl, byte [lado]
      jae terminaciclo3
         mov rsi, espaco        ; rsi <- endereço da string a escrever
         mov rdx, 1                ; rdx <- nº de caracteres a escrever (até EoS)
         push rcx                  ; guarda valor de rcx na stack
         call escrever             ; chamada da função
         pop rcx                   ; retira valor de tcx na stack
         inc cl
         jmp repete3
   terminaciclo3:
      mov rsi, contorno         ; rsi <- endereço da string a escrever
         mov rdx, 1                ; rdx <- nº de caracteres a escrever (até EoS)
         push rcx                  ; guarda valor de rcx na stack
         call escrever             ; chamada da função
         pop rcx   
      mov rsi, newLine          ; rsi <- endereço da string a escrever
      mov rdx, compNL           ; rdx <- nº de caracteres a escrever (até EoS)
      push rcx                  ; guarda valor de rcx na stack
      call escrever             ; chamada da função
      pop rcx   

      inc ch
   jmp repete4
   terminaciclo4:

   jmp inicio

escolha2:

   ; escrever a string newLine
   mov rax, SYS_write        ; função escrever 
   mov rdi, StdOut           ; output standard (ecrã)
   mov rsi, newLine          ; rsi <- endereço da string a escrever
   mov rdx, compNL           ; rdx <- nº de caracteres a escrever (até EoS)
   syscall                   ; chamada de função do SO (system call)

   ; escrever a string menu2
   mov rax, SYS_write        ; função escrever 
   mov rdi, StdOut           ; output standard (ecrã)
   mov rsi, menu2             ; rsi <- endereço da string a escrever
   mov rdx, compMenu2         ; rdx <- nº de caracteres a escrever (até EoS)
   syscall                   ; chamada de função do SO (system call)

   ; escrever a string newLine
   mov rax, SYS_write        ; função escrever 
   mov rdi, StdOut           ; output standard (ecrã)
   mov rsi, newLine          ; rsi <- endereço da string a escrever
   mov rdx, compNL           ; rdx <- nº de caracteres a escrever (até EoS)
   syscall                   ; chamada de função do SO (system call)

; escrever a string opcEsc
   mov rax, SYS_write        ; função escrever 
   mov rdi, StdOut           ; output standard (ecrã)
   mov rsi, opcEsc           ; rsi <- endereço da string a escrever
   mov rdx, compOpc          ; rdx <- nº de caracteres a escrever (até EoS)
   syscall                   ; chamada de função do SO (system call)

; ler caracteres para a string escolha (<enter> incluído)
   mov rax, SYS_read         ; função ler 
   mov rdi, StdIn            ; input standard (teclado)
   mov rsi, escolha          ; rsi <- endereço da string a ler
   mov rdx, compEsc          ; rdx <- nº máximo de caracteres para ler
   syscall                   ; chamada de função do SO (system call)

; identifica a escolha lida
   cmp byte [escolha], "1"
   je configuracao1
   cmp byte [escolha], "2"
   je configuracao2
   cmp byte [escolha], "3"
   je configuracao3
   cmp byte [escolha], "4"
   je configuracao4
   cmp byte [escolha], "5"
   je configuracao5   
   jmp escolhaE              ; escolha não válida (errada)

; Função escolha do caracter
configuracao1:                 
   jmp  escolha2

; Função escolha da cor de texto
configuracao2:
   jmp  escolha2

; Funçaãoescolha da cor de fundo 
configuracao3:
   jmp  escolha2

; Função escolha comprimento
configuracao4:
   jmp  escolha2

; Função voltar atrás
configuracao5:
   jmp  inicio

escolha0:
   mov rsi, termina          ; rsi <- endereço da string a escrever
   mov rdx, compTerm         ; rdx <- nº de caracteres a escrever (até EoS)
   jmp escreve
escolhaE:
   mov rsi, errada           ; rsi <- endereço da string a escrever
   mov rdx, compErro         ; rdx <- nº de caracteres a escrever (até EoS)
   jmp escreve

escreve:
; escrever escolha lida
   mov rax, SYS_write        ; função escrever 
   mov rdi, StdOut           ; output standard (ecrã)
   syscall                   ; chamada de função do SO (system call)
; escrever a string newLine
   mov rax, SYS_write        ; função escrever 
   mov rdi, StdOut           ; output standard (ecrã)
   mov rsi, newLine          ; rsi <- endereço da string a escrever
   mov rdx, compNL           ; rdx <- nº de caracteres a escrever (até EoS)
   syscall                   ; chamada de função do SO (system call)
   jmp  inicio

escrever:
   ; parâmetros passados nos registos rsi (variável) e rdx (comprimento)
   push rax                  ; conteúdo do registo rax guardado na stack
   push rdi                  ; conteúdo do registo rdi guardado na stack
   mov rax, SYS_write        ; função escrever 
   mov rdi, StdOut           ; output standard (ecrã)
   syscall                   ; chamada de função do SO (system call)
   pop rdi                   ; conteúdo do registo rdi guardado na stack
   pop rax                   ; conteúdo do registo rax guardado na stack
   ret                       ; retoma a execução na instrução seguinte ao call

saida:
; terminar o programa 
   mov rax, SYS_exit     ; operação sair - devolver o controlo ao SO
   mov rdi, EXIT_SUCCESS ; sair com sucesso (sem erros)
   syscall               ; chamar (executar) a função do SO

; assemble: yasm -f elf64 -g dwarf2 -l ac-proj-G3.lst ac-proj-G3.as
;     link: ld -g ac-proj-G3.o -o ac-proj-G3.x
;  execute: ./ac-proj-G3.x
;    debug: gdb ./ac-proj-G3.x