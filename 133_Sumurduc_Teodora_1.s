.data
v:.space 40
cerinta:.space 4
m2:.space 1600
mres:.space 1600
i:.space 4
j:.space 4
n:.space 4
n_n:.space 4
dimensiune:.space 4
k:.space 4
ik:.space 4
cod:.space 4
x:.space 4
im:.space 4
jm:.space 4
afis:.asciz "%ld "
citire:.asciz "%ld"
newline:.asciz "\n"
.text
matrix_mult:
#for(i=0;i<n;i++)
#  for(j=0;j<n;j++)
#      { mres[i][j]=0
#        for(k=0;k<n;k++)
#           mres[i][j]+=m1[i][k]*m2[k][j]
#      }
#unde m1 este matricea alocata dinamic

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

movl 20(%ebp),%esi

movl $0,(%esi,%eax,4) #mres[i][j]=0

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

movl -20(%ebp),%ebx 
movl (%esi,%ebx,4),%eax 
xorl %edx,%edx
movl -24(%ebp),%ecx 
mull (%edi,%ecx,4) #%eax=m1[i][k]*m2[k][j]

mov 20(%ebp),%esi 
movl -16(%ebp),%ebx 
movl (%esi,%ebx,4),%ecx 
addl %eax,%ecx 
movl %ecx,(%esi,%ebx,4) #mres[i][j]=mres[i][j]+m1[i][k]*m2[k][j]

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
#citim numarul cerintei
pusha
pushl $cerinta
pushl $citire
call scanf
addl $8,%esp
popa

#verificam daca cerinta este 3, daca nu programul se incheie
movl $3,%ecx
cmp cerinta,%ecx
jne exit

#citim numarul de noduri
pusha
pushl $n
pushl $citire
call scanf
addl $8,%esp
popa

#citim numarul de legaturi pentru fiecare nod pe care le punem intr-un vector , iar indicile fiecarei valorii indica nodul 
movl $0,i 
for_vector:
movl i,%ecx
cmp %ecx,n 
je cont1

#citim legatura
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

declarare_dimensiune:
xorl %edx,%edx 
movl n,%eax 
movl n,%ebx  
mull %ebx 
movl %eax,n_n 
movl $4,%ebx 
mull %ebx 
movl %eax,dimensiune 

mmap2:
mov $192,%eax #valoarea 192 este corespunzatoare functiei mmap2
xor %ebx,%ebx #%ebx este 0
mov dimensiune,%ecx # %ecx este n*n*4  dimensiunea matricei de n*n long-uri
mov $0x3,%edx #%edx PROT_READ(0x1)|PROT_WRITE(0x2)- puteam sa citim si sa scriem in spatiul alocat - 3 reprezinta permisia pentru a puteam scrie si citi in acest spatiu
mov $0x22,%esi #MAP_PRIVATE(0x2) | MAP_ANON(0x20) - schimbarile sunt private
mov $-1,%edi #nu exista fd daca avem MAP_ANON
xor %ebp,%ebp #punctul de la care incepe sa fie scris in memorie
int $0x80 #este system call si verifica registrii

movl %eax,cod #in variabila cod vom retine adresa din eax pentru ca mai avem nevoie de registrul eax 

#de aici citim nodurile adiacente cu fiecare nod , luate in ordine
#for(i=0;i<n;i++)
#   {x=v[i];
#     for(j=o;j<n;j++)
#        {cin>>nod;
#         m1[i][nod]=1;
#        }}
movl $0,i 
legaturi:
movl i,%ecx
cmp %ecx,n 
je contk

lea v,%esi 
movl (%esi,%ecx,4),%ebx 

movl $0,j
cit_nod:
mov j,%edx
cmp %edx,%ebx 
je cont_cit_nod1

#citim nodul adiacent
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
movl %eax,%ecx 
mov  cod,%eax
movl $1,(%eax,%ecx,4)

incl j
jmp cit_nod 

cont_cit_nod1:
incl i
jmp legaturi
 
contk:
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
movl %eax,%ecx
mov cod,%eax
lea m2,%edi
movl (%eax,%ecx,4),%ebx
movl %ebx,(%edi,%ecx,4)

incl j
jmp f2

c1:
incl i
jmp f1

continuare:
pusha
push $k
push $citire
call scanf
add $8,%esp
popa

pusha
push $i
push $citire
call scanf
add $8,%esp
popa

pusha
push $j
push $citire
call scanf
add $8,%esp
popa

movl $1,ik
et1:
movl ik,%ecx
cmp k,%ecx
je c_et1

movl cod,%eax

pushl $mres
pushl %eax
pushl $m2
pushl n
call matrix_mult
addl $16,%esp

movl $0,im
et_mov1:
movl  im,%ecx
cmp n,%ecx
je et_continua1

movl $0,jm
et_mov2:
movl jm,%edx
cmp n,%edx
je et_continua2

movl im,%eax
xorl %edx,%edx
mull n
addl jm,%eax
movl %eax,%ecx
mov cod,%eax
lea mres,%edi

movl (%edi,%ecx,4),%ebx
movl %ebx,(%eax,%ecx,4)

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
push %ebx
push $afis
call printf
addl $8,%esp
popa

pusha
pushl $0
call fflush
addl $4,%esp
popa

free:
movl $91,%eax
movl cod ,%ebx
movl dimensiune,%ecx
int $0x80
exit:
movl $1,%eax
xor %ebx,%ebx
int $0x80
