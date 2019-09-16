.model tiny
.stack 100
.data
linefeed    db 13, 10, "$"
prompt1     db "Enter Len: $"
prompt2     db "Enter Num: $"
prompt3     db "Enter Search Term: $"
msg1        db "Linear Search:$"
msg2        db "Binary Search:$"
msg3        db "Found, index = $"
msg4        db "Not found$"
len         db ?
nums        db 10 DUP(?), "$"
search_term db ?
dec_out     db 2 DUP(?), "$"

.code 	                    ; code segment
call main
mov  ax, 4c00h              ; terminate properly
int  21h  

main proc
    mov ax, @data
    mov ds, ax
    
    call get_arr_inp
    call ins_linefeed
    
    mov dx, offset prompt3
    call show_msg
    call get_dec_val
    mov search_term, al
    
    call ins_linefeed
    mov dx, offset msg1
    call show_msg
    call ins_linefeed
    call linear_search
    
    call ins_linefeed
    mov dx, offset msg2
    call show_msg
    call ins_linefeed
    call binary_search
    
    ret
main endp

; linear search the array
linear_search proc
    push ax
    push bx
    push cx
    push dx
    
    mov ch, 0
    mov cl, len
linear_search_loop:
    dec cl
    cmp cl, 0
    jl linear_search_not_found
    mov bx, offset nums
    add bx, cx
    
    mov dl, [bx]
    cmp dl, search_term
    jne linear_search_loop
    
    mov dx, offset msg3
    call show_msg
    mov ah, 0
    mov al, cl
    call disp_dec_val
    call ins_linefeed
    jmp done_linear_search
    
linear_search_not_found:
    mov dx, offset msg4
    call show_msg
    call ins_linefeed
    
done_linear_search:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
linear_search endp

; binary search the array
binary_search proc
    push ax
    push bx
    push cx
    push dx
    
    mov cl, 0
    mov ch, len
binary_search_loop:
    cmp cl, ch
    jge binary_search_not_found
    
    mov bh, 0
    mov bl, cl
    add bl, ch
    adc bh, 0
    
    shr bx, 1
    mov dx, bx
    mov bx, offset nums
    add bx, dx
    
    mov al, [bx]
    cmp al, search_term
    jb binary_search_mid_less
    ja binary_search_mid_more
    
    mov ax, dx
    mov dx, offset msg3
    call show_msg
    call disp_dec_val
    call ins_linefeed
    jmp done_binary_search

binary_search_mid_less:
    mov cl, dl
    inc cl
    jmp binary_search_loop

binary_search_mid_more:
    mov ch, dl
    dec ch
    jmp binary_search_loop
    
binary_search_not_found:
    mov dx, offset msg4
    call show_msg
    call ins_linefeed

done_binary_search:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
binary_search endp

; get array as input
get_arr_inp proc
    push ax
    push bx
    push cx
    push dx
    
    mov dx, offset prompt1
    call show_msg
    call get_dec_val
    mov len, al
    
    call ins_linefeed
    
    mov cx, 0
get_arr_elems_loop:
    mov bx, offset nums
    add bx, cx
    
    mov dx, offset prompt2
    call show_msg
    call get_dec_val
    mov [bx], al
    
    inc cl
    cmp cl, len
    jl get_arr_elems_loop
    
done_get_arr_elems:
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
get_arr_inp endp

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

    mov cl, 2
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