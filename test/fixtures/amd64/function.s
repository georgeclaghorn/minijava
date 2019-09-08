.text
#ifdef __APPLE__
.globl _main

_main:
#else
.globl main

main:
#endif
call HelloWorld.main
xor %rax, %rax
ret

HelloWorld.main:
xor %r12, %r12
mov %r12, %rdi
call Foo.bar
mov %rax, %r13
mov %r13, %rdi
call __println
ret
Foo.bar:
mov $9, %r14
mov %r14, %rax
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
#ifdef __APPLE__
call _printf
#else
call printf@plt
#endif
leave
ret
