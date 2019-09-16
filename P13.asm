.model tiny
.stack 100
.data

linefeed    db 13, 10, "$"  
prompt1     db "Date: $"
prompt2     db "Time: $"
date_out    db 4 DUP(?), "-", 2 DUP(?), "-", 2 DUP(?), "$"
time_out    db 2 DUP(?), ":", 2 DUP(?), ":", 2 DUP(?), "$"

.code

call main
mov  ax, 4c00h              ; terminate properly
int  21h  

main proc
    mov ax, @data
    mov ds, ax

    mov dx, offset prompt1
    call show_msg
    
    call get_date
    mov dx, offset date_out
    call show_msg
    
    call ins_linefeed
    
    mov dx, offset prompt2
    call show_msg
    
    call get_time
    mov dx, offset time_out
    call show_msg
    
    ret
main endp

; get the system date, store in variable date_out
get_date proc
    push ax
    push bx
    push cx
    push dx
    
    mov ah, 2ah
    int 21h     ; Return: CX = year (1980-2099) DH = month DL = day
    
    mov ax, cx   
    mov di, 3
    
date_year_loop:
    mov bl, 10
    div bl
    add ah, 48
    mov date_out[di], ah
    mov ah, 0
    
    dec di
    cmp di, 0
    jge date_year_loop
    
    mov al, dh
    mov ah, 0
    mov di, 6
    
date_month_loop:
    mov bl, 10
    div bl
    add ah, 48
    mov date_out[di], ah
    mov ah, 0
    
    dec di
    cmp di, 5
    jge date_month_loop
    
    mov al, dl
    mov ah, 0
    mov di, 9
    
date_day_loop:
    mov bl, 10
    div bl
    add ah, 48
    mov date_out[di], ah
    mov ah, 0
    
    dec di
    cmp di, 8
    jge date_day_loop
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
get_date endp

; get system time, store in variable time_out
get_time proc
    push ax
    push bx
    push cx
    push dx
    
    mov ah, 2ch
    int 21h     ; Return: CH = hour CL = minute DH = second
    
    mov ah, 0
    mov al, ch
    mov ch, 10
    div ch
    add ax, 3030h ; add 48 to ah and al
    mov time_out[0], al
    mov time_out[1], ah
    
    mov ah, 0
    mov al, cl
    mov ch, 10
    div ch
    add ax, 3030h ; add 48 to ah and al
    mov time_out[3], al
    mov time_out[4], ah
    
    mov ah, 0
    mov al, dh
    mov ch, 10
    div ch
    add ax, 3030h ; add 48 to ah and al
    mov time_out[6], al
    mov time_out[7], ah

    pop dx
    pop cx
    pop bx
    pop ax
    ret
get_time endp

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