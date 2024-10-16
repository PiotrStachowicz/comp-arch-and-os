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
        .globl  addsb
        .type   addsb, @function

/*
 * W moim rozwiązaniu używam następującej techniki:
        Mamy dwie liczby uint64_t (dalej x i y), w każdej z nich znajduje się 8 wektorów int8_t.
        Każdy taki bajt dodajemy oddzielnie, oraz jeśli dojdzie do sytuacji w której:
        (1) Bajt z x i y były ujemne a ich suma dodatnia to wynikowym bajtem jest: 10000000
        (2) Bajt z x i y były dodatnie a ich suma ujemna to wynikowym bajtem jest: 01111111

        (*) Przed dodaniem do siebie, należy wyłączyć najbardziej znaczące bity każdego bajtu. Potem odpowiednio należy skorygować wynik.
        (sum_vector = x + y    z (*)
         x_sign = x & 0x8080808080808080
         y_sign = y & 0x8080808080808080)
         
        Pierwszą maską wykrywamy każdy bajt, w którym doszło do (1):
        Wykrywamy to poprzez: (~(x_sign ^ y_sign) & ~sum_vector) & x & 0x8080808080808080

        (Czyli bit znaczący bajtu zapali się tylko wtedy, gdy odpowiednie bajty x i y były ujemne a ich wynik dodawania był dodatni)

        mask = 0000 0000....1000 0000 0000 0000...0000
        Następnie negacją tej maski włączamy bit na odpowiedniej pozycji w wyniku i tworzymy mask' (*):
        mask' = 1111 1111....1000 0000 1111 1111...1111
        Teraz operacją "and" wyłączamy odpowiednie bity na wybranych bajtach.

        (**) Korzystając z tricku podobnego do tego z pracowni "clz" jesteśmy w stanie stworzyć mask' zamiast:
                mask >>= 1
                mask |= mask >> 1
                mask |= mask >> 2
                mask |= mask >> 3
                
                to:
                mask = (mask >> 7) * 0x0111111 

        Analogicznie załatwiamy przypadek (2) ((~(x_sign ^ y_sign) & sum_vector) & (~x) & 0x8080808080808080)
        mask' = 0000 0000...01111 1111 0000 0000...0000
        (Tutaj korygujemy wynik operacją "or")
 */

addsb:
        mov     $-9187201950435737472, %r8 /* Zapisujemy maskę 0x8080808080808080 do wyznaczania bitów znaku */
        mov     %rdi, %rdx 
        and     %r8, %rdx       /* Wyznaczamy bity znaku poszczególnych bajtów z x */
        mov     %rsi, %rcx 
        and     %r8, %rcx       /* -//- z y */
        mov     %rdi, %r9
        not     %r8
        and     %r8, %r9 
        mov     %rsi, %rax
        and     %r8, %rax  
        not     %r8
        add     %rax, %r9       /* Dodajemy ze sobą liczby jak napisano w (*) */
        mov     %rdx, %rax
        xor     %rcx, %rax
        xor     %rax, %r9       /* Korygujemy wynik dodawania */
        not     %rax
        not     %r9
        and     %r9, %rax
        not     %r9
        and     %rdi, %rax
        and     %r8, %rax       /* Pierwsza maska do wykrywania (1) */
        or      %rax, %r9       /* Włączamy bit */
        shr     $7, %rax
        imul    $127, %rax      /* Generujemy maskę do końca */
        not     %rax
        and     %rax, %r9       /* Zmieniamy odpowednie bajty na 1000 0000 */
        mov     %rdx, %rax
        xor     %rcx, %rax
        not     %rax
        and     %r9, %rax
        not     %rdi
        and     %rdi, %rax
        and     %r8, %rax        /* Pierwsza maska do wykrywania (2) */
        not     %rax
        and     %rax, %r9        /* Wyłączamy odpowiednie bity */
        not     %rax
        shr     $7, %rax
        imul    $127, %rax       /* Generujemy drugą maskę do końca */
        or      %rax, %r9        /* Zmieniamy odpowednie bajty na 0111 1111 */
        mov     %r9, %rax
        ret                      /* Zwracamy wynik */

        .size   addsb, .-addsb
