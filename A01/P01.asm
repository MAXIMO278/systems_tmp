.model tiny

.stack 100

.data

linefeed      db 13, 10, "$"
name_str      db "Arpan Basu$"
prog_name_str db "P01.asm$" 

.code 	                    ; code segment

call main
mov  ax, 4c00h
int  21h  

main proc
    mov ax, @data
    mov ds, ax
    
    lea dx, name_str
    mov ah, 9
    int 21h
    
    call ins_linefeed
    
    lea dx, prog_name_str
    mov ah, 9
    int 21h
    
    call wait_for_key
    
    ret   
main endp

ins_linefeed proc
    lea dx, linefeed
    mov ah, 9
    int 21h
    ret
ins_linefeed endp

wait_for_key proc
    mov  ah, 7
    int  21h
    ret
wait_for_key endp

end