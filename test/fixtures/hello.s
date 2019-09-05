.text
.globl _main

_main:
call HelloWorld.main
xor %rax, %rax
ret

HelloWorld.main:
mov $5, %r12
mov $4, %r13
mov %r12, %r14
add %r13, %r14
mov %r14, %rdi
call __println
ret

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
call _printf
leave
ret
