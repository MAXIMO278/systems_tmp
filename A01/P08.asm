.model small

.stack 200

.data

linefeed    db 13, 10, "$"
prompt1     db "Enter Len: $"
prompt2     db "Enter Num: $"
len         db ?
nums        db 10 DUP(?), "$"
hex_out     db 2 DUP(?), "H$"
msg1        db "Highest: $"
msg2        db "Lowest: $" 

.code 	                    ; code segment

call main
mov  ax, 4c00h
int  21h

main proc
    mov ax, @data
    mov ds, ax
    
    call inp_array
    
    mov cl, 0
    mov al, nums[0]
    mov ah, nums[0]
    mov bx, offset nums
    inc cl
    inc bx
    
loop_over_nums:
    inc bx
    inc cl
    cmp cl, len
    jge disp
    
    cmp al, [bx]
    jle not_lesser
    mov al, [bx]
not_lesser:
    cmp ah, [bx]
    jge not_greater
    mov ah, [bx]
not_greater:
    jmp loop_over_nums
    
disp:
    mov dx, offset msg1
    call show_msg
    mov dh, 00
    mov dl, ah
    call print_hex

    call ins_linefeed
    
    mov dx, offset msg2
    call show_msg
    mov dh, 00
    mov dl, al
    call print_hex
    
    ret
main endp

; take array as input
inp_array proc
    push bx
    push cx
    push dx
    
    mov dx, offset prompt1
    call show_msg
    call get_num
    call ins_linefeed
    mov len, al
    
    mov cl, len
    mov bx, offset nums
get_len_nums:
    mov dx, offset prompt2
    call show_msg
    call get_num
    call ins_linefeed
    mov [bx], al
    inc bx
    dec cl
    jnz get_len_nums
    
    pop dx
    pop cx
    pop bx
    ret
inp_array endp

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

; show message, location in dx
show_msg proc
    push ax
    mov ah, 9
    int 21h
    pop ax
    ret
show_msg endp

; display decimal value of dx reg in hex form; does not modify any reg
print_hex proc
    push ax
    push bx
    push cx
    push dx
    
    mov cx,2
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
    
    lea dx,hex_out
    mov ah,9
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_hex endp

; insert linefeed
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
