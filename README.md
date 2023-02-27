# Proiect-Assembly
133_Sumurduc_Teodora_0.s contine doua probleme:
  1. se citesc listele de adiacenta a unui graf orientat cu n noduri si se construieste matricea de adiacenta.
  2. se construieste matricea de adiacenta si se va calcula numarul de drumuri de lungime k dintre doua noduri date . Pentru a determina numarul de drumuri de lungime k 
dintre doua noduri trebuie sa inmultim matricea pana ajunge la puterea k , iar pozitia ij din matrice corespunde cu ceea ce trebuie sa aflam (i si j reprezinta numarul 
nodurilor citite).

133_Sumurduc_Teodora_1.s rezolva problema 2 , de mai sus , dar intr-un mod diferit : pentru matricea de adiacenta se aloca spatiu in mod dinamic , folosind apelul de 
sistem mmap2.
