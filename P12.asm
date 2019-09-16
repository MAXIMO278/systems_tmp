.model tiny
.stack 100
.data

linefeed    db 13, 10, "$"
curr_name   db 40 DUP(?)
new_name    db 40 DUP(?)   
prompt1     db "Enter curr name of file: $"
prompt2     db "Enter new name of file: $"
msg1        db "Rename Success$"
msg2        db "Rename Failure$" 

.code

call main
mov  ax, 4c00h              ; terminate properly
int  21h  

main proc
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    mov dx, offset prompt1
    call show_msg
    mov bx, offset curr_name
    call accept_string
    
    mov dx, offset prompt2
    call show_msg
    mov bx, offset new_name
    call accept_string
    
    mov ah, 56h ; rename file
    mov dx, offset curr_name
    mov di, offset new_name
    int 21h
    
    call ins_linefeed
    
    jnc success
    mov dx, offset msg2
    call show_msg
    jmp return_from_main

success:
    mov dx, offset msg1
    call show_msg
    
return_from_main:
    ret
main endp

; take string as input, buffer address stored in bx
accept_string proc
    push bx
    
get_char_loop:
    call get_char

    cmp al, 13
    je done
    mov [bx], al
    inc bx
    jmp get_char_loop
    
done:    
    mov byte ptr [bx], 36 ; 36 = '$'
    pop bx
    ret
accept_string endp

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