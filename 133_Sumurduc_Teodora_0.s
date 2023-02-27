.data
cerinta:.space 4
n:.space 4
v:.space 400
m1:.space 160000
m2:.space 160000
mres:.space 160000
i:.space 4
j:.space 4
x:.space 4
k:.space 4
ik:.space 4
im:.space 4
jm:.space 4
afis:.asciz "%ld "
citire:.asciz "%ld"
newline:.asciz "\n"
.text

matrix_mult:
pushl %ebp
movl %esp,%ebp
subl $24,%esp

movl $0,-4(%ebp)
f1p:
movl -4(%ebp),%ecx
cmp 8(%ebp),%ecx
je c1p

movl $0,-8(%ebp)
f2p:
movl -8(%ebp),%ecx
cmp 8(%ebp),%ecx
je c2p

movl -4(%ebp),%eax
xorl %edx,%edx
mull 8(%ebp)
addl -8(%ebp),%eax
movl %eax,-16(%ebp)

mov 20(%ebp),%esi
movl $0,(%esi,%eax,4)

movl $0,-12(%ebp)
f3p:
movl -12(%ebp),%ecx
cmp 8(%ebp),%ecx
je c3p

movl -4(%ebp),%eax
xorl %edx,%edx
mull 8(%ebp)
addl -12(%ebp),%eax
movl %eax,-20(%ebp)

movl -12(%ebp),%eax
xorl %edx,%edx
mull 8(%ebp)
addl -8(%ebp),%eax
movl %eax,-24(%ebp)

mov 16(%ebp),%esi
mov 12(%ebp),%edi

mov -20(%ebp),%ebx
movl (%esi,%ebx,4),%eax
xorl %edx,%edx
movl -24(%ebp),%ecx
mull (%edi,%ecx,4)

mov 20(%ebp),%esi
movl -16(%ebp),%ebx
movl (%esi,%ebx,4),%ecx
addl %eax,%ecx
movl %ecx,(%esi,%ebx,4)

incl -12(%ebp)
jmp f3p

c3p:
incl -8(%ebp)
jmp f2p

c2p:
incl -4(%ebp)
jmp f1p

c1p:
addl $24,%esp
popl %ebp
ret

.global main
main:
pusha
pushl $cerinta
pushl $citire
call scanf
addl $8,%ebx
popa

movl cerinta,%ecx
cmp $1,%ecx
je cerinta1
cmp $2,%ecx
je cerinta2

cerinta2:
cerinta1:
pusha
pushl $n
pushl $citire
call scanf
addl $12,%esp
popa

movl $0,i
for_vector:
movl i,%ecx
cmp %ecx,n
je cont1

pusha
pushl $x
pushl $citire
call scanf
addl $8,%esp
popa

lea v,%esi
movl x,%edx
movl %edx,(%esi,%ecx,4)

incl i
jmp for_vector
cont1:
movl $0,i
legaturi:
movl i,%ecx
cmp %ecx,n
je afisare
lea v,%esi
movl (%esi,%ecx,4),%ebx
movl $0,j
cit_nod:
mov j,%edx
cmp %edx,%ebx
je cont2

pusha
push $x
push $citire
call scanf 
addl $8,%esp
popa

movl x,%ecx
movl $0,%edx
movl i,%eax
mull n
addl %ecx,%eax
lea m1,%edi
movl $1,(%edi,%eax,4)

incl j
jmp cit_nod

cont2:
incl i
jmp legaturi

afisare:
movl cerinta,%ecx
cmp $2,%ecx
je cerinta22

movl $0,i
afis_for:
movl i,%ecx
cmpl %ecx,n
je et_exit
movl $0,j
afis_for2:
mov j,%edx
cmp %edx,n
je cont3

lea m1,%edi
mov i,%eax
mov $0,%edx
mull n
add j,%eax
mov (%edi,%eax,4),%ebx

pusha
push %ebx
push $afis
call printf
addl $8,%esp
popa

pusha
push $0
call fflush
add $4,%esp
popa

incl j
jmp afis_for2

cont3:
movl $4,%eax
movl $1,%ebx
movl $newline,%ecx
movl $2,%edx
int $0x80

incl i
jmp afis_for

cerinta22:
movl $0,i
f1:
movl i,%ecx
cmp n,%ecx
je continuare

movl $0,j
f2:
movl j,%edx
cmp n,%edx
je c1

movl i,%eax
xorl %edx,%edx
mull n
addl j,%eax
lea m1,%esi
lea m2,%edi
movl (%esi,%eax,4),%ebx
movl %ebx,(%edi,%eax,4)

incl j
jmp f2

c1:
incl i
jmp f1

continuare:
pusha
pushl $k
pushl $citire
call scanf
addl $8,%esp
popa

pusha
pushl $i
pushl $citire
call scanf
addl $8,%esp
popa

pusha
pushl $j
pushl $citire
call scanf
addl $8,%esp
popa 

movl $1,ik
et1:
movl ik,%ecx
cmp k,%ecx
je c_et1

pushl $mres
pushl $m1
pushl $m2
pushl n
call matrix_mult
addl $16,%esp

movl $0,im
et_mov1:
movl im,%ecx
cmp n,%ecx
je et_continua1

et_mov2:
movl jm,%edx
cmp n,%edx
je et_continua2

movl im,%eax
xorl %edx,%edx
mull n
addl jm,%eax

lea m1,%esi
lea mres,%edi

movl (%edi,%eax,4),%ebx
movl %ebx,(%esi,%eax,4)

incl jm
jmp et_mov2

et_continua2:
incl im
jmp et_mov1
et_continua1:
incl ik
jmp et1

c_et1:
lea mres,%esi
movl i,%eax
xorl %edx,%edx
mull n
addl j,%eax

movl (%esi,%eax,4),%ebx

pusha
pushl %ebx
pushl $afis
call printf
addl $8,%esp
popa

pusha
pushl $0
call fflush
addl $4,%esp
popa

et_exit:
movl $1,%eax
xorl %ebx,%ebx
int $0x80
