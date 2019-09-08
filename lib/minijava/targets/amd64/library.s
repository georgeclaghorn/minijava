.data
__println_format: .asciz "%i\n"

.text
__println:
push %rbp
mov %rsp, %rbp
and $-16, %rsp
mov %rdi, %rsi
lea __println_format(%rip), %rdi
mov $0, %al
#ifdef __APPLE__
call _printf
#else
call printf@plt
#endif
leave
ret
