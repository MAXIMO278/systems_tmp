.model tiny
.stack 100
.data
linefeed    db 13, 10, "$"
prompt1     db "Enter Binary: $"
prompt2     db "Enter Decimal: $"
msg1        db "Decimal: $"  
msg2        db "Binary: $"
bin_out     db 20 DUP(0), "$"
dec_out     db 4 DUP(0), "$"

.code 	                    ; code segment
call main
mov  ax, 4c00h              ; terminate properly
int  21h  

main proc
    mov ax, @data
    mov ds, ax
    
    call get_bin_input
    call ins_linefeed
    call disp_bin_to_dec
    call ins_linefeed
    call ins_linefeed
    call get_dec_input
    call ins_linefeed
    call disp_dec_to_bin
    
    ret
main endp

; get binary number as input, store in bin_out
get_bin_input proc
    push ax
    push bx
    push dx
    
    mov dx, offset prompt1
    call show_msg
    
    mov bx, offset bin_out
get_bin_loop:
    call get_char
    mov [bx], al
    inc bx
    cmp al, 66 ; 66 = 'B'
    jne get_bin_loop
    
done_bin_loop:

    pop dx
    pop bx
    pop ax
    ret
get_bin_input endp

disp_bin_to_dec proc
    push ax
    push bx
    push cx
    push dx

    mov dx, offset msg1
    call show_msg
    
    mov bx, offset bin_out
    mov ax, 0
make_dec_loop:
    mov ch, [bx]
    inc bx
    cmp ch, 66 ; 66 = 'B'
    je done_make_dec_loop
    
    shl ax, 1
    sub ch, 48
    add al, ch
    jnc make_dec_loop
    add ah, 1
    jmp make_dec_loop
    
done_make_dec_loop:
    call disp_dec_val

    pop dx
    pop cx
    pop bx
    pop ax
    ret
disp_bin_to_dec endp

; get decimal number as input, store in dec_out
get_dec_input proc
    push ax
    push bx
    push dx
    
    mov dx, offset prompt2
    call show_msg
    
    mov bx, offset dec_out
get_dec_loop:
    call get_char
    mov [bx], al
    inc bx
    cmp al, 68 ; 68 = 'D'
    jne get_dec_loop
    
done_dec_loop:

    pop dx
    pop bx
    pop ax
    ret
get_dec_input endp

; display dec to bin
disp_dec_to_bin proc
    push ax
    push bx
    push cx
    push dx

    mov dx, offset msg2
    call show_msg
    
    mov bx, offset dec_out
    mov ax, 0
make_dec_loop_2:
    mov ch, [bx]
    inc bx
    cmp ch, 68 ; 68 = 'D'
    je done_make_dec_loop_2
    
    mov dx, ax
    mov cl, 3
    shl dx, cl
    shl ax, 1
    add ax, dx
    
    sub ch, 48
    add al, ch
    jnc make_dec_loop_2
    add ah, 1
    jmp make_dec_loop_2
    
done_make_dec_loop_2:
    call disp_bin_val

    pop dx
    pop cx
    pop bx
    pop ax
    ret
disp_dec_to_bin endp

; display ax value in binary
disp_bin_val proc
    push ax
    push bx
    push cx
    push dx

    mov cl, 20
disp_bin_val_loop:
    dec cl
    cmp cl, 0
    jl disp_bin_val_loop_done
    mov bx, offset bin_out
    push cx
    mov ch, 0
    add bx, cx
    pop cx
    
    mov ch, 1
    and ch, al
    add ch, 48
    mov [bx], ch
    shr ax, 1
    jmp disp_bin_val_loop
    
disp_bin_val_loop_done:
    mov dx, offset bin_out
    call show_msg
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
disp_bin_val endp

; display ax value in decimal
disp_dec_val proc
    push ax
    push bx
    push cx
    push dx

    mov cl, 4
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

; get a single character, modify ax, store in al
get_char proc
    mov ah, 1
    int 21h
    ret
get_char endp

; show message, location in dx
show_msg proc
    push ax
    mov ah, 9
    int 21h
    pop ax
    ret
show_msg endp

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