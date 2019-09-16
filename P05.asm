.model tiny
.stack 200
.data
linefeed    db 13, 10, "$"
prompt1     db "Dividend: $"
prompt2     db "Divisor: $"
msg1        db "Quotient: $"  
msg2        db "Remainder: $"
dividend    dw 0
divisor     db 0
hex_out     db 4 DUP(0), "H$"

.code 	                    ; code segment
call main
mov  ax, 4c00h              ; terminate properly
int  21h  

main proc
    mov ax, @data
    mov ds,ax
    
    ; get dividend
    mov dx, offset prompt1
    call show_msg
    call get_num
    mov dividend, ax
    call ins_linefeed
    
    ; get divisor
    mov dx, offset prompt2
    call show_msg
    call get_num
    mov divisor, al
    call ins_linefeed
    
    ; divide
    mov ax, dividend
    div divisor
    
    ; display
    mov dx, offset msg1
    call show_msg
    mov dl, al
    mov dh, 0
    call print_hex
    call ins_linefeed
    
    mov dx, offset msg2
    call show_msg
    mov dl, ah
    mov dh, 0
    call print_hex
    
    ret   
main endp

; display decimal value of dx reg in hex form; does not modify any reg
print_hex proc
    push ax
    push bx
    push cx
    push dx
    
    mov cx, 4
c_loop:
    dec cx
    mov ax, dx
    
    shr dx,1
    shr dx,1
    shr dx,1
    shr dx,1
    
    and ax,0fh
    
    mov bx, offset hex_out
    add bx,cx
    
    cmp ax,0ah
    jl set_digit
    add al,07h

set_digit:
    add al,30h
    mov [bx],al
    
    cmp cx,0
    jne c_loop
    
    lea dx, hex_out
    mov ah,9
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_hex endp

; get 16-bit hex number in decimal form, modify ax, store in ax
get_num proc
    push bx
    push cx
    push dx

    mov dx, 0
get_characters:
    call get_char
    cmp al, 72 ; cmp w/ H
    je done
    
    mov cl, 4
    shl dx, cl
    
    sub al, 48 ; 48 = ascii of '0'
    cmp al, 9
    jle is_number
    sub al, 7
    
is_number:
    mov bh, 0
    mov bl, al
    add dx, bx
    jmp get_characters
    
done:
    mov ax, dx
    pop dx
    pop cx
    pop bx
    ret
get_num endp

; get a single character, modify ah, store in al
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