; print terminating message

.model tiny

.stack 200

.data

msg db 'Program terminated.$'

.code

call main
mov  ax, 4c00h       ; exit with error code 0
int  21h             ; raise interrupt

main proc
    mov ax, @data    ; initialize ds to address
    mov ds, ax       ; of data segment
    
    lea dx, msg      ; load address of message
    mov ah, 09h      ; display string
    int 21h          ; raise interrupt
    
    ret
main endp

end
