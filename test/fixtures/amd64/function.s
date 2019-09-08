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
xor %r12, %r12
mov %r12, %rdi
sub $48, %rsp
mov %r12, 0(%rsp)
mov %r13, 8(%rsp)
mov %r14, 16(%rsp)
mov %r15, 24(%rsp)
mov %rbx, 32(%rsp)
call Foo.bar
mov 0(%rsp), %r12
mov 8(%rsp), %r13
mov 16(%rsp), %r14
mov 24(%rsp), %r15
mov 32(%rsp), %rbx
add $48, %rsp
mov %rax, %r13
mov %r13, %rdi
sub $48, %rsp
mov %r12, 0(%rsp)
mov %r13, 8(%rsp)
mov %r14, 16(%rsp)
mov %r15, 24(%rsp)
mov %rbx, 32(%rsp)
call System.out.println
mov 0(%rsp), %r12
mov 8(%rsp), %r13
mov 16(%rsp), %r14
mov 24(%rsp), %r15
mov 32(%rsp), %rbx
add $48, %rsp
leave
ret

Foo.bar:
push %rbp
mov %rsp, %rbp
mov $9, %r14
mov %r14, %rax
leave
ret
