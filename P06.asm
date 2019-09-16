.model tiny
.stack 100
.data
linefeed    db 13, 10, "$"
prompt1     db "First 10 terms of fibonacci are: $"
dec_out     db 0, 0, 0, "$"
a           dw 0
b           dw 0
c           dw 0            

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
    
    mov cl, 1
    mov a, 1
    mov b, 0
    mov c, 0
main_loop:
    mov ax, a
    add ax, b
    
    call disp_dec_val
    call ins_linefeed
    
    mov dx, b
    mov a, dx
    mov b, ax
    
    inc cl
    cmp cl, 10
    jle main_loop
    
    ret
main endp

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