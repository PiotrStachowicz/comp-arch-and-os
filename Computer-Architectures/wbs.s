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
        .globl  wbs
        .type wbs, @function

/*
 * W moim rozwiązaniu używam następującej techniki:
        Zastanówmy się ile razy jaki bit powinien zostać policzony
        v = x  x  x  x  x ... x  x  x 
            63 62 61 60 59    2  1  0

        Naszym celem będzie jak najszybsze policzenie, każdych z tych pozycji, więc:
        (Policzmy === użyjmy popcnt)

        (1) Policzmy każdy niepatrzysty bit, tym samym sprowadzamy sytuację do:
        v = x  x  x  x  x ... x  x  x  x 
            62 62 60 60 58    2  2  0  0

        (2) Zauważmy teraz, że jesteśmy w stanie policzyć co drugi bit dwa razy i dodajemy do wyniku...
        v = x  x  x  x  x ... x  x  x  x 
            60 60 60 60 58    0  0  0  0

        (3) Teraz liczymy co czwarty bit 4 razy i dodajemy do wyniku...

        (4) I tak dalej...

        (Ta metoda używa instrukcji popcnt...)
 */

wbs:
        mov     %rdi, %r8 /* W %r8 robimy obliczenia na x */
        mov     $12297829382473034410, %r9 /* %r9 -> 0xAA... */
        and     %r9, %r8 /* Wyłuskujemy odpowiednie bity */
        popcnt  %r8, %r10 /* Liczymy ilość bitów zapalonych */
        mov     %r10, %rax /* W %rax trzymamy wynik */
        mov     %rdi, %r8 
        mov     $14757395258967641292, %r9 /* %r9 -> 0xCC... */
        and     %r9, %r8
        popcnt  %r8, %r10 /* -//- */
        shl     $1, %r10 /* Liczymy zapalone bity dwa razy */
        add     %r10, %rax /* Dodajemy do wyniku */
        mov     %rdi, %r8 /* I tak dalej... */
        mov     $17361641481138401520, %r9 /* %r9 -> 0xF0F0... */
        and     %r9, %r8
        popcnt  %r8, %r10
        shl     $2, %r10
        add     %r10, %rax
        mov     %rdi, %r8
        mov     $18374966859414961920, %r9 /* %r9 -> 0xFF00FF00... */
        and     %r9, %r8
        popcnt  %r8, %r10
        shl     $3, %r10
        add     %r10, %rax
        mov     %rdi, %r8
        mov     $18446462603027742720, %r9 /* %r9 -> 0xFFFF0000... */
        and     %r9, %r8
        popcnt  %r8, %r10
        shl     $4, %r10
        add     %r10, %rax
        mov     %rdi, %r8
        mov     $18446744069414584320, %r9 /* %r9 -> 0xFFFFFFFF00000000 */
        and     %r9, %r8
        popcnt  %r8, %r10
        shl     $5, %r10
        add     %r10, %rax
        ret
        .size wbs, .-wbs
