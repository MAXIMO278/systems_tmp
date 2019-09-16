.model small
.stack 100h
.data
linefeed    db 13, 10, "$"
original    db 100 DUP(0), "$"
find        db 100 DUP(0), "$"
result      db 100 DUP (0), "$"
i           dw ?             
j           dw ?           
prompt1     db "Initial string: $"
prompt2     db "Removal substring: $"
msg1        db "Final string: $"
str_inp     dw ?

.code
call main
mov ax, 4c00h
int 21h

main proc
    mov ax, @data
    mov ds, ax
    mov es, ax

    mov dx, offset original
    mov str_inp, dx
    mov dx, offset prompt1
    call show_msg
    call get_str_inp
    call ins_linefeed

    mov dx, offset find
    mov str_inp, dx
    mov dx, offset prompt2
    call show_msg
    call get_str_inp
    call ins_linefeed
    call ins_linefeed
    
    mov i, offset original 
    mov j, offset result
    mov si, offset find
    mov di, i
    
replace_loop:
    mov al, [si]
    
    cmp al, "$"
    je match
    
    cmp byte ptr [di], "$"
    je not_match
    
    cmp al, [di]
    jne not_match
    inc si
    inc di
    jmp replace_loop
    
match:
    mov si, offset find
    mov i, di
    cmp byte ptr [di], "$"
    je done
    jmp replace_loop
    

not_match:
    mov si, i
    mov di, j
    mov al, [si]
    mov byte ptr [di], al
    inc i
    inc j
    mov si, offset find
    mov di, i
    cmp byte ptr [di], "$"
    jne replace_loop
    
done:
    mov di, j
    mov byte ptr [di], "$"
    
    mov dx, offset msg1
    call show_msg
    call ins_linefeed
    mov dx, offset result
    call show_msg
    
    ret
main endp

; get string input, address supplied in str_inp
get_str_inp proc
    push ax
    push bx
    push cx
    push dx

    mov bx, str_inp
    
get_str_inp_loop:
    call get_char
    mov [bx], al
    inc bx
    
    cmp al, "$"
    jne get_str_inp_loop
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
get_str_inp endp

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