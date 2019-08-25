; loop until user decides to quit

.model tiny
.stack 100
.data
    linefeed    db 13, 10, "$"
    msg1        db "Starting prompt loop$"
    msg2        db "Continue? (0=yes, other=no) :$"
    msg3        db "Ending prompt loop$"

.code
call main
mov  ax, 4c00h           ; terminate with exit code 00
int  21h  

main proc 
    mov ax, @data
    mov ds, ax
    
    lea dx, msg1
    mov ah, 9
    int 21h  
    call ins_linefeed

looper:
    lea dx, msg2
    mov ah, 9
    int 21h
    
    mov ah, 1       ; read char
    int 21h         ; interrupt
    call ins_linefeed
    cmp al, '0'
    jnz looper

    lea dx, msg3    ; Get address of message
    mov ah, 9       ; disp str
    int 21h         ; interrupt
    call ins_linefeed

    ret
main endp

ins_linefeed proc
    lea dx, linefeed
    mov ah, 9
    int 21h
    ret
ins_linefeed endp

end
