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
        .globl  clz
        .type   clz, @function

/*
 * W moim rozwiązaniu używam następującej techniki:
        Najpierw liczbę z wejścia "v" modyfikujemy na v' w taki sposób, że
        v  = 00....1xxxxx....x =>
        v' = 00....111111....1

        Teraz zostaje nam pare opcji działania...
        1. Możemy zliczyć liczbę jedynek w v'
        2. Możemy "wyłuskać" najbardziej znaczący zapalony bit w v',
                v'' = 00....10....0
                            i
                po czym użyć jakiejś szybkiej metody na znalezienie jego indeksu "i"
                w liczbie v''...
        3. ...

        Pozostanę przy pomyśle nr. 1, ponieważ był on treścią jednego z zadań na liście 1,
        oraz jest on bardziej zrozumiały.

        Czas tego rozwiązania będzie równy:         [ n to długość wejścia "v" ]

                zmodyfikuj(v) -> O(log(n))
                +
                policz_zapalone_bity(v') -> O(log(n))

        Co razem daje nam złożoność O(log(n))

        Wynikiem będzie 64 - policz_zapalone_bity(v').

        Przejdźmy teraz do implementacji tej metody w assembly...
*/

clz:
        push    %r10             /* W architekturze x86 rejest %r10 jest "Callee-Saved", więc jesteśmy zobowiązani do zapisania jego stanu przed użyciem na stosie*/
        push    %r11             /* - || - */
        mov     %rdi, %r10       /* W rejestrze %r10 będziemy przeprowadzać wszystkie nasze obliczenia ze stałymi itd. (pomocniczy rejestr) */
        shr     $1,   %r10       /* Zaczynamy teraz modyfikować wejście "v" w taki sposób, że najbardziej znacząca jedynka będzie nam zapalała wszystkie bity na prawo od niej */
        or      %r10, %rdi       /* Po pierwszej takiej operacji wiemy że w v już są conajmniej 2 bity zapalone na prawo więc możemy teraz nimi zapalić conajmniej 4 itd...*/
        mov     %rdi, %r10
        shr     $2,   %r10       /* Przesuwamy v tym razem o 2 bity w prawo */
        or      %r10, %rdi       /* Mamy po tej operacji conajmniej 4 bity zapalone na prawo */
        mov     %rdi, %r10       /* Zapisujemy nowy stan v */
        shr     $4,   %r10       /* i tak dalej zapalamy wszystkie bity na prawo... */
        or      %r10, %rdi       /* ... */
        mov     %rdi, %r10
        shr     $8,   %r10
        or      %r10, %rdi
        mov     %rdi, %r10
        shr     $16,  %r10
        or      %r10, %rdi
        mov     %rdi, %r10
        shr     $32,  %r10
        or      %r10, %rdi      /* Stworzyliśmy więc v' w postaci v' = 00...111...1 , teraz przejdźmy do zliczenia ilości zapalonych bitów w v' */
        mov     $6148914691236517205, %r11  /* Zapamiętujemy stałą 0x5555555555555555 w pomocniczym rejestrze %r11 */
        mov     %rdi, %r10      /* Zapamiętujemy oryginalną wartość aktualnego v' w rejestrze %r10 */
        shr     $1, %r10        /* Przesuwamy rejestr %r10 o jeden bit w prawo, aby potem można było zastosować tą samą maskę to wyłuskania bitów" */
        and     %r11, %r10      /* Tą operacją wiemy jakie i ile jest zapalonych bitów w v' na co drugiej pozycji (w "kubełkach" o długości 1 bitu) */
        and     %r11, %rdi      /* - || -  (ale mamy informacje o ilości bitów międy kubełkami z poprzedniej instrukcji) */
        add     %r10, %rdi      /* Wiemy, że wynik zmieści się na 2 bitach więc możemy dodać do siebie te dwie liby z %rdi i %r10, tym samym otrzymując informacje o ilości zapalonych bitów */
                                /* na danych pozycjach w liczbie, w kubełkach o wielkości 2. */
        mov     $3689348814741910323, %r11  /* Zapamiętujemy stałą 0x3333333333333333 w pomocniczym rejestrze %r11 */
        mov     %rdi, %r10      /* ... */
        and     %r11, %rdi
        shr     $2, %r10
        and     %r11, %r10
        add     %r10, %rdi
        mov     $1085102592571150095, %r11  /* Zapamiętujemy stałą 0xF0F0F0F0F0F0F0F w pomocniczym rejestrze %r11 */
        mov     %rdi, %r10      /* ... */
        and     %r11, %rdi
        shr     $4, %r10
        and     %r11, %r10
        add     %r10, %rdi
        mov     $72340172838076673, %rax   /* Zapamiętujemy stałą 0x0101010101010101 w rejestrze %rax, żeby go użyć podczas mnożenia */
        imul    %rax, %rdi            /* Mnożymy x przez stałą w %rax, tym trickiem oszczędzamy dużo instrukcji, chodzi tutaj o to ... */
        shr     $56, %rdi             /* ... aby zsumować ze sobą wartości w każdym kubełku wielkości 8 (takie dotychczas stworzyliśmy) do najbardziej znaczącego bajtu,
                                         po czym przesuwamy wynikowy bajt o 56 co daje nam wynik. Możemy tak zrobić ponieważ wynik mieści się już na 8 bitach. */
        mov     $64, %eax      
        sub     %edi, %eax            /* Ustawiamy wynik clz na 64 - policz_zapalone_bity(v') */
        pop     %r11                  /* Przywracamy stan rejestru %r11 */
        pop     %r10                  /* Przywracamy stan rejestru %r10 */
        ret                           /* Zwracamy wynik procedury clz */

        .size   clz, .-clz
