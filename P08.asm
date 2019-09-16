.model tiny
.stack 200
.data
linefeed    db 13, 10, "$"
prompt1     db "Enter num 1: $"
prompt2     db "Enter num 2: $"
prompt3     db "Enter num 3: $"
msg1        db "GCD: $"
msg2        db "LCM: $"
dec_out     db 0, 0, 0, 0, 0, "$"
num1        dw ?
num2        dw ?
num3        dw ?
gcd_inp_1   dw ?
gcd_inp_2   dw ?
gcd         dw ?
lcm_inp_1   dw ?
lcm_inp_2   dw ?
lcm         dw ?

.code 	                    ; code segment
call main
mov  ax, 4c00h              ; terminate properly
int  21h  

main proc
    mov ax, @data
    mov ds, ax
    
    mov dx, offset prompt1
    call show_msg
    call get_dec_val
    mov num1, ax
    ; call ins_linefeed
    
    mov dx, offset prompt2
    call show_msg
    call get_dec_val
    mov num2, ax
    ; call ins_linefeed
    
    mov dx, offset prompt3
    call show_msg
    call get_dec_val
    mov num3, ax
    ; call ins_linefeed
    
    mov ax, num1
    mov gcd_inp_1, ax
    mov ax, num2
    mov gcd_inp_2, ax
    call get_gcd
    mov ax, gcd
    mov gcd_inp_1, ax
    mov ax, num3
    mov gcd_inp_2, ax
    call get_gcd
    mov ax, gcd
    
    mov dx, offset msg1
    call show_msg
    call disp_dec_val
    call ins_linefeed
    
    mov ax, num1
    mov lcm_inp_1, ax
    mov ax, num2
    mov lcm_inp_2, ax
    call get_lcm
    mov ax, lcm
    mov lcm_inp_1, ax
    mov ax, num3
    mov lcm_inp_2, ax
    call get_lcm
    mov ax, lcm
    
    mov dx, offset msg2
    call show_msg
    call disp_dec_val
    call ins_linefeed
    
    ret
main endp

; get gcd
get_gcd proc
    push ax
    push bx
    push cx
    push dx
    
    mov ax, gcd_inp_1
    mov bx, gcd_inp_2
    
get_gcd_loop:
    cmp ax, 0
    je get_gcd_loop_done
    
    mov dx, 0
    xchg ax, bx
    div bx
    
    mov ax, dx
    
    jmp get_gcd_loop
    
get_gcd_loop_done:
    mov gcd, bx
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
get_gcd endp

; get lcm
get_lcm proc
    push ax
    push bx
    push cx
    push dx
    push gcd
    push gcd_inp_1
    push gcd_inp_2
    
    mov ax, lcm_inp_1
    mov bx, lcm_inp_2
    mov gcd_inp_1, ax
    mov gcd_inp_2, bx
    call get_gcd
    
    cwd
    mov cx, gcd
    div cx
    call disp_dec_val
    call ins_linefeed
    cwd
    mul bx
    call disp_dec_val
    call ins_linefeed
    mov lcm, ax
    
    pop gcd_inp_2
    pop gcd_inp_1
    pop gcd
    pop dx
    pop cx
    pop bx
    pop ax
    ret
get_lcm endp

; get decimal value, store in ax
get_dec_val proc
    push bx
    push cx
    push dx
    
    mov dx, 0
get_characters:
    call get_char
    cmp al, 13 ; cmp w/ [enter]
    je done
    
    sub al, 48
    
    mov bx, dx
    mov cl, 3
    shl bx, cl
    shl dx, 1
    add dx, bx
    add dl, al
    jnc get_characters
    add dh, 1
    jmp get_characters
    
done:
    mov ax, dx
    
    pop dx
    pop cx
    pop bx
    ret
get_dec_val endp

; display ax value in decimal
disp_dec_val proc
    push ax
    push bx
    push cx
    push dx

    mov cl, 5
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