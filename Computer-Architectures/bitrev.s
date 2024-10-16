/*
 * UWAGA! W poniższym kodzie należy zawrzeć krótki opis metody rozwiązania
 *        zadania. Będzie on czytany przez sprawdzającego. Przed przystąpieniem
 *        do rozwiązywania zapoznaj się dokładnie z jego treścią. Poniżej należy
 *        wypełnić oświadczenie o samodzielnym wykonaniu zadania.
 *
 * Oświadczam, że zapoznałem(-am) się z regulaminem prowadzenia zajęć
 * i jestem świadomy(-a) konsekwencji niestosowania się do podanych tam zasad.
 *
 * Imię i nazwisko, numer indeksu: Piotr Stachowicz, 337942
 */

        .text
        .globl  bitrev
        .type bitrev, @function

/*
 * W moim rozwiązaniu używam następującej techniki:
       W moim rozwiązaniu używam klasycznej metody Divide & Conquer oraz metody zamiany liczby w wersji little-endian na big-endian (z ćwiczeń).

       (1) Skorzystamy z wiedzy z ćwiczeń, żeby zmniejszyć ilość instrukcji, jesteśmy w stanie najpierw liczbę z wejścia:
       v = 1234 5678 (gdzie np. 3 oznacza 3 bajt od lewej strony), zamienić na v = 8765 4321, używając instrukcji ror.

       (2) Potem wyłuskujemy odpowiednimi maskami bity w każdym kubełku wielkości 8 i przesuwamy na odpowiednią pozycję itd...
       Na samym na końcu otrzymując v z odwróconymi bitami.

       Oto implementacja w assembly... (32 instrukcje)
 */

bitrev:
        /* rdi: 1234 5678 */
        mov   %edi, %eax   /* eax: 5678 */
        ror   $8, %ax      /* eax: 5687 */
        ror   $16, %eax    /* eax: 8756 */
        ror   $8, %ax      /* eax: 8765 (więc rax: 0000 8765) */
        shl   $32, %rax    /* rax: 8765 0000 */
        shr   $32, %rdi    /* rdi: 0000 1234 */
        ror   $8, %di      /* edi: 1243 */
        ror   $16, %edi    /* edi: 4312 */
        ror   $8, %di      /* edi: 4321 (więc rdi: 0000 4321) */
        or    %rax, %rdi   /* rdi: 8765 4321, teraz wystarczy poobracać bity na każdym bajcie, klasyczną metodą Divide & Conquer */
        mov   %rdi, %rax
        mov   $17361641481138401520, %rsi
        and   %rsi, %rdi   /* "Wyłuskujemy" bity, aby móc je potem bezproblemowo przesunąć */
        shr   $4, %rdi     /* Przesuwamy bity o 4 w prawo na pożądaną pozycję */
        shl   $4, %rax     /* Przesuwamy bity kopii o 4 w lewo */
        and   %rsi, %rax 
        or    %rax, %rdi   /* Zapisujemy nowy stan v */
        mov   %rdi, %rax   /* ... */
        mov   $14757395258967641292, %rsi
        and   %rsi, %rdi   
        shr   $2, %rdi    
        shl   $2, %rax   
        and   %rsi, %rax 
        or    %rax, %rdi   
        mov   %rdi, %rax   /* ... */
        mov   $12297829382473034410, %rsi
        and   %rsi, %rdi   
        shr   $1, %rdi    
        shl   $1, %rax   
        and   %rsi, %rax 
        or    %rdi, %rax   
        ret                 /* Zwracamy wynik procedury bitrev */

        .size bitrev, .-bitrev
