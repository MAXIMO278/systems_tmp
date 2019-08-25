; take character input and display

.model tiny
.stack 200
.data

linefeed db 13, 10, "$"
msg1     db 'Enter char: $'
msg2     db 'Entered char: $'

.code
call main
mov  ax, 4c00h      ; exit with error code 0
int  21h            ; raise interrupt

main proc
    mov ax, @data   ; initialize ds to address
    mov ds, ax      ; of data segment
    
    lea dx, msg1    ; get address of message
    mov ah, 9       ; display string function
    int 21h         ; display call
    
    mov ah, 1       ; read char function
    int 21h         ; read call
    
    mov bl, al      ; store value from accumulator
    
    call ins_linefeed
    
    lea dx, msg2    ; get address of message
    mov ah, 9       ; display string function
    int 21h         ; call display
    
    mov ah, 2       ; write character to stdout
    
    mov dl, bl      ; store value in dl
    int 21h         ; call display

    ret
main endp

ins_linefeed proc
    lea dx, linefeed
    mov ah, 9
    int 21h
    ret
ins_linefeed endp

end
