; is second number lesser
.model tiny
.stack 200
.data
    linefeed    db  13, 10, "$"
    num1        db  ?
    num2        db  ?
    prompt1     db  "Enter first num: $"
    prompt2     db  "Enter second num: $"
    msg1        db  "Second number is not lesser.$"
    msg2        db  "Second number is lesser.$"

.code
call main
mov  ax, 4c00h      ; exit with error code 0
int  21h            ; raise interrupt

main proc
    mov ax, @data
    mov ds, ax
    
    lea dx, prompt1
    mov ah, 9
    int 21h
    call get_num
    mov num1, al
    call ins_linefeed
    
    lea dx, prompt2
    mov ah, 9
    int 21h
    call get_num
    mov num2, al
    call ins_linefeed
    
    mov dl, num2
    cmp dl, num1
    jb lesser       ; check if num2 < num1 (unsigned)
    
    lea dx, msg1    ; get address of message
    mov ah, 9       ; display string function
    int 21h         ; display call 
    ret
    
lesser:
    lea dx, msg2    ; get address of message
    mov ah, 9       ; display string function
    int 21h         ; display call
    ret
main endp

; get 8-bit hex number in decimal form, modify ax, store in al
get_num proc
    push cx
    push dx

    mov dl, 00
get_characters:
    call get_char
    cmp al, 72 ; cmp w/ H
    je done
    
    mov cl, 4
    shl dl, cl
    
    sub al, 48 ; 48 = ascii of '0'
    cmp al, 9
    jle is_number
    sub al, 7
    
is_number:
    add dl, al
    jmp get_characters
    
done:
    mov al, dl
    pop dx
    pop cx
    ret
get_num endp

; get a single character, modify ah, store in al
get_char proc
    mov ah, 1
    int 21h
    ret
get_char endp

; insert new-line, modify ax
ins_linefeed proc
    push dx
    lea dx, linefeed
    mov ah, 9
    int 21h
    pop dx
    ret
ins_linefeed endp

end
