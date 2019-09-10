.data
System.out.println.format: .asciz "%i\n"

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

System.out.println:
push %rbp
mov %rsp, %rbp
and $-16, %rsp
mov %rdi, %rsi
lea System.out.println.format(%rip), %rdi
mov $0, %al
#ifdef __APPLE__
call _printf
#else
call printf@plt
#endif
leave
ret

HelloWorld.main:
push %rbp
mov %rsp, %rbp
sub $48, %rsp
mov %r12, 0(%rsp)
mov %r13, 8(%rsp)
mov %r14, 16(%rsp)
mov %r15, 24(%rsp)
mov %rbx, 32(%rsp)
xor %r12, %r12
mov $5, %r13
mov $4, %r14
mov %r12, %rdi
mov %r13, %rsi
mov %r14, %rdx
call Foo.bar
mov %rax, %r15
mov %r15, %rdi
call System.out.println
mov 0(%rsp), %r12
mov 8(%rsp), %r13
mov 16(%rsp), %r14
mov 24(%rsp), %r15
mov 32(%rsp), %rbx
leave
ret

Foo.bar:
push %rbp
mov %rsp, %rbp
sub $48, %rsp
mov %r12, 0(%rsp)
mov %r13, 8(%rsp)
mov %r14, 16(%rsp)
mov %r15, 24(%rsp)
mov %rbx, 32(%rsp)
mov %rdi, %r12
mov %rsi, %r13
mov %rdx, %r14
mov %r13, %r15
add %r14, %r15
mov %r15, %rax
mov 0(%rsp), %r12
mov 8(%rsp), %r13
mov 16(%rsp), %r14
mov 24(%rsp), %r15
mov 32(%rsp), %rbx
leave
ret
