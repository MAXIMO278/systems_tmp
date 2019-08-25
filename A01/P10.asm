; display A to Z

.model tiny
.stack 100
.data
    msg db "Letters are: $"

.code
call main
mov  ax, 4c00h           ; terminate with exit code 00
int  21h  

main proc 
    mov ax, @data
    mov ds, ax
    
    lea dx, msg
    mov ah, 9
    int 21h
    
    mov bl,65
    mov cl,26

print:
    mov ah, 2
    mov dl, bl
    int 21h
    mov dl, 32
    int 21h
    inc bl
    dec cl
    jnz print

    ret
main endp

end
