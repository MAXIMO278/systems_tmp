.model tiny
.stack 100
.data
linefeed    db 13, 10, "$"
prompt1     db "Primes between 1 to 100 are: $"
dec_out     db 0, 0, 0, "$"
is_prime    db ?

.code 	                    ; code segment
call main
mov  ax, 4c00h              ; terminate properly
int  21h  

main proc
    mov ax, @data
    mov ds, ax
    
    mov dx, offset prompt1
    call show_msg
    call ins_linefeed
    
    mov bl, 2
    mov cl, 0
main_loop:
    mov ah, 0
    mov al, bl
    call check_if_prime
    
    mov al, is_prime
    cmp al, 1
    jne main_loop_update
    
    inc cl
    mov ah, 0
    mov al, bl
    call disp_dec_val
    mov al, 32
    call show_char
    
    mov al, 1
    and al, cl
    jz main_loop_update
    call ins_linefeed
    
main_loop_update:
    inc bl
    cmp bl, 100
    jle main_loop
    
    ret
main endp

; check if ax is prime
check_if_prime proc
    push ax
    push bx
    push cx
    push dx
    
    mov cl, 0
    mov ch, 0
    
check_if_prime_loop:
    inc cl
    push ax
    
    div cl
    cmp ah, 0
    jne not_divisible
    inc ch
not_divisible:
    pop ax
    cmp cl, 255
    jne check_if_prime_loop
    
    cmp ch, 2
    jne not_prime
    mov is_prime, 1
    jmp prime_check_done
not_prime:
    mov is_prime, 0
    
prime_check_done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
check_if_prime endp

; display ax value in decimal
disp_dec_val proc
    push ax
    push bx
    push cx
    push dx

    mov cl, 3
disp_dec_val_loop:
    dec cl
    cmp cl, 0
    jl disp_dec_val_loop_done
    mov bx, offset dec_out
    push cx
    mov ch, 0
    add bx, cx
    pop cx
    
    mov ch, 10
    div ch
    push ax
    add ah, 48
    mov [bx], ah
    pop ax
    
    mov ah, 0
    jmp disp_dec_val_loop

disp_dec_val_loop_done:
    mov dx, offset dec_out
    call show_msg

    pop dx
    pop cx
    pop bx
    pop ax
    ret
disp_dec_val endp

; show character, ascii value in al
show_char proc
    push ax
    push dx
    
    mov dl, al
    mov ah, 2
    int 21h
    
    pop dx
    pop ax
    ret
show_char endp

; show message, location in dx
show_msg proc
    push ax
    mov ah, 9
    int 21h
    pop ax
    ret
show_msg endp

; get a single character, modify ah, store in al
get_char proc
    mov ah, 1
    int 21h
    ret
get_char endp

; insert new-line
ins_linefeed proc
    push ax
    push dx
    lea dx,linefeed
    mov ah,9
    int 21h
    pop dx
    pop ax
    ret
ins_linefeed endp

end