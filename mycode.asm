name "sort"

; simple sort
          
; this program inputs 3 numbers and
; sorts them from largest to smallest


; this macro prints a char in AL and advances
; the current cursor position:
putc    macro   char
        push    ax
        mov     al, char
        mov     ah, 0eh
        int     10h     
        pop     ax
endm


; this macro sets current cursor position:
gotoxy  macro   col, row
        push    ax
        push    bx
        push    dx
        mov     ah, 02h
        mov     dh, row
        mov     dl, col
        mov     bh, 0
        int     10h
        pop     dx
        pop     bx
        pop     ax
endm


data    segment
cr        equ   0dh
lf        equ   0ah
dollar    equ   '$'
new_line  db    lf, cr, dollar
msg1      db    "enter first value (-32768..32767)!"
          db    lf, cr, dollar
msg2      db    lf, cr, "enter second value (-32768..32767)!"
          db    lf, cr, dollar
msg3      db    lf, cr, "enter third value (-32768..32767)!"
          db    lf, cr, dollar
msg4      db    cr, lf, cr, lf, "after sorting from biggest to smallest:", dollar
msg5      db    cr, lf, "num1 = ", dollar
msg6      db    cr, lf, "num2 = ", dollar
msg7      db    cr, lf, "num3 = ", dollar    
num1      dw    ?
num2      dw    ?
num3      dw    ?
marks     dw    100,75,60,55,95,97,100,80,99,90,88,81,70,93,94,87,84,80,91,91,77,80,90,92,96
student   dw    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
msg8      db    cr, lf, "student number ", dollar
msg9      db    cr, "with mark = ", dollar 
msg10     db    lf, cr, "enter student number greater than zero: "
          db    lf, cr, dollar
msg11     db    lf, cr, "enter the student mark<0..100>: "
          db    lf, cr, dollar 
msg12     db    cr, lf, cr, lf, "ERROR !!", dollar
          
msg13     db    lf, cr, "enter number of students<1..25>: "
          db    lf, cr, dollar                        
temp      dw    ?
number    db    ? 
msg14     db    lf, cr, "Do you want to enter the two arrays manually ? 0-No  1-Yes"
          db    lf, cr, dollar 
option    dw    ?        
ends

stack segment
                dw      100h    dup(?)
ends

code segment
 start  proc    far

; prepare for return to os:
    push    ds
    mov     ax, 0
    push    ax
; set segment registers:                
    mov     ax, data
    mov     ds, ax
    mov     es, ax

; clear the screen:
    call    clear_screen

; position the cursor at row=3 and column=0
    gotoxy 0, 3


     

;input arrays or sorting exisitng arrays

oneorzero:
    lea     dx,msg14
    call    puts
    call    scan_num
    mov     option,cx
    cmp     option,1h
    je      sn
    cmp     option,0h
    mov     number,24
    je      bubble
    lea     dx,msg12
    call    puts
    jmp     oneorzero
      
    
;scan number of students
sn:
    lea     dx, msg13
    call    puts       ; display the message.      
    call    scan_num
    mov     number,cl
    cmp     number,0001H
    jl      nerror
    cmp     number,0019H
    jg      nerror
    jmp     pass
    
nerror:
    lea     dx,msg12
    call    puts
    jmp     sn





pass:



;students numbers and marks input :
        
    lea     si,marks
    mov     cl,number  
    lea     di,student
    
input: 



    lea     dx, msg10
    call    puts       ; display the message.      
    push    cx
    call    scan_num
    mov     [di],cx
    pop     cx
    cmp     WORD PTR [di],0000H
    jl      error1
    jmp     cont

error1:
    lea     dx,msg12
    call    puts
    jmp     input
             

                    
cont:
    lea     dx,msg11
    call    puts
    push    cx                    
    call    scan_num   ; input the number into cx.  
    mov     [si], cx
    pop     cx   
    cmp     WORD PTR [si],0000H
    jl      error2 
    cmp     WORD PTR [si],0064H
    jg      error2
    jmp     continue 

error2:
    lea     dx,msg12
    call    puts
    jmp     cont               
        
    
    
continue:    
    inc     si
    inc     si
    inc     di
    inc     di 
    dec     cl 
    jnz     input       
    
   
    
    
;bubble sort:

bubble:
    mov     cl,number
    dec     cl

outer: ;outer loop 
    lea     di,student
    lea     si,marks
    mov     ch,number
    dec     ch         

inner:  ;inner loop
    mov     ax,[si]  
 
    inc     si 
    inc     si
 
    inc     di 
    inc     di
      
    
    cmp     ax,[si]
    jge     ahead
    
    mov     ax,[si]
    mov     temp,ax
    mov     ax,[si-2]
    mov     [si],ax 
    mov     ax,temp
    mov     [si-2],ax    
    mov     ax,[di]
    mov     temp,ax
    mov     ax,[di-2]
    mov     [di],ax 
    mov     ax,temp
    mov     [di-2],ax    


ahead:
    dec     ch
    jnz     inner
    dec     cl
    jnz     outer 

                    
;bubble sort finish    


;printing 
                     
                  
    lea     si,marks
    mov     cl,number  
    lea     di,student
    
    lea     dx, msg4
    call    puts  
    
    lea     dx,new_line
    call    puts
    lea     dx,new_line
    call    puts    
    
output:
                      
 
    
    lea     dx,msg8
    call    puts
    mov     ax, WORD PTR [di]
    call    print_num ; print ax.       
    
    lea     dx,new_line
    call    puts 
    lea     dx,new_line
    call    puts   
    
    lea     dx,msg9
    call    puts                  
    mov     ax, WORD PTR [si]
    call    print_num ; print ax.
    
    lea     dx,new_line
    call    puts
    
    inc     si
    inc     si 
    inc     di
    inc     di
    dec     cl
    jnz     output


    mov     ah, 0
    int     16h


    retf
 start          endp

;***********************************

; displays the message (dx-address),
; uses dos function to print:
puts    proc    near
        push    ax
        mov     ah, 09h
        int     21h
        pop     ax
        ret
endp

;************************************

; if bx < cx then exchanges them
; (works with signed numbers)
sort    proc    near
        cmp     bx, cx
        jge     compared
        xchg    bx, cx
compared:
        ret
endp

;************************************





; gets the multi-digit SIGNED number from the keyboard,
; and stores the result in CX register:
SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

        ; reset flag:
        MOV     CS:make_minus, 0

next_digit:

        ; get char from keyboard
        ; into AL:
        MOV     AH, 00h
        INT     16h
        ; and print it:
        MOV     AH, 0Eh
        INT     10h

        ; check for MINUS:
        CMP     AL, '-'
        JE      set_minus

        ; check for ENTER key:
        CMP     AL, 13  ; carriage return?
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8                   ; 'BACKSPACE' pressed?
        JNE     backspace_checked
        MOV     DX, 0                   ; remove last digit by
        MOV     AX, CX                  ; division:
        DIV     CS:ten                  ; AX = DX:AX / 10 (DX-rem).
        MOV     CX, AX
        PUTC    ' '                     ; clear position.
        PUTC    8                       ; backspace again.
        JMP     next_digit
backspace_checked:


        ; allow only digits:
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for next input.       
ok_digit:


        ; multiply CX by 10 (first time the result is zero)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten                  ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX

        ; check if the number is too big
        ; (result should be 16 bits)
        CMP     DX, 0
        JNE     too_big

        ; convert from ASCII code:
        SUB     AL, 30h

        ; add AL to CX:
        MOV     AH, 0
        MOV     DX, CX      ; backup, in case the result will be too big.
        ADD     CX, AX
        JC      too_big2    ; jump if the number is too big.

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX      ; restore the backuped value before add.
        MOV     DX, 0       ; DX was zero before backup!
too_big:
        MOV     AX, CX
        DIV     CS:ten  ; reverse last DX:AX = AX*10, make AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for Enter/Backspace.
        
        
stop_input:
        ; check flag:
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       ; used as a flag.
SCAN_NUM        ENDP





; this procedure prints number in AX,
; used with PRINT_NUM_UNS to print signed numbers:
PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:
        ; the check SIGN of AX,
        ; make absolute if it's negative:
        CMP     AX, 0
        JNS     positive
        NEG     AX

        PUTC    '-'

positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP



; this procedure prints out an unsigned
; number in AX (not just a single digit)
; allowed values are from 0 to 65535 (FFFF)
PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

        ; flag to prevent printing zeros before number:
        MOV     CX, 1

        ; (result of "/ 10000" is always less or equal to 9).
        MOV     BX, 10000       ; 2710h - divider.

        ; AX is zero?
        CMP     AX, 0
        JZ      print_zero

begin_print:

        ; check divider (if zero go to end_print):
        CMP     BX,0
        JZ      end_print

        ; avoid printing zeros before number:
        CMP     CX, 0
        JE      calc
        ; if AX<BX then result of DIV will be zero:
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0   ; set flag.

        MOV     DX, 0
        DIV     BX      ; AX = DX:AX / BX   (DX=remainder).

        ; print last digit
        ; AH is always ZERO, so it's ignored
        ADD     AL, 30h    ; convert to ASCII code.
        PUTC    AL


        MOV     AX, DX  ; get remainder from last div.

skip:
        ; calculate BX=BX/10
        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten  ; AX = DX:AX / 10   (DX=remainder).
        MOV     BX, AX
        POP     AX

        JMP     begin_print
        
print_zero:
        PUTC    '0'
        
end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
PRINT_NUM_UNS   ENDP



ten             DW      10      ; used as multiplier/divider by SCAN_NUM & PRINT_NUM_UNS.


; this procedure clears the screen,
; (done by scrolling entire screen window),
; and sets cursor position on top of it:
CLEAR_SCREEN PROC NEAR
        PUSH    AX      ; store registers...
        PUSH    DS      ;
        PUSH    BX      ;
        PUSH    CX      ;
        PUSH    DI      ;

        MOV     AX, 40h
        MOV     DS, AX  ; for getting screen parameters.
        MOV     AH, 06h ; scroll up function id.
        MOV     AL, 0   ; scroll all lines!
        MOV     BH, 07  ; attribute for new lines.
        MOV     CH, 0   ; upper row.
        MOV     CL, 0   ; upper col.
        MOV     DI, 84h ; rows on screen -1,
        MOV     DH, [DI] ; lower row (byte).
        MOV     DI, 4Ah ; columns on screen,
        MOV     DL, [DI]
        DEC     DL      ; lower col.
        INT     10h

        ; set cursor position to top
        ; of the screen:
        MOV     BH, 0   ; current page.
        MOV     DL, 0   ; col.
        MOV     DH, 0   ; row.
        MOV     AH, 02
        INT     10h

        POP     DI      ; re-store registers...
        POP     CX      ;
        POP     BX      ;
        POP     DS      ;
        POP     AX      ;

        RET
CLEAR_SCREEN ENDP



code    ends
       
       
        end     start    ; stop assembler and set entry point.
