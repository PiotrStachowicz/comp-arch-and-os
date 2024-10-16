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
        .globl  mod17
        .type   mod17, @function

/*
 * W moim rozwiązaniu używam następującej techniki: 
        Korzystamy ze wskazówki. Chcemy szybko zsumować razem liczby znajdujące się
        (1) W parzystych "kubełkach" o długości 4 bitów 
        (2) W nieparzystych -//-

        Wiemy, że wynik zmieści się na 8 bitach, więc możemy tutaj śmiało zastosować
        metodę divide & conquer, w której najpierw nakładamy jedną połowę liczby na drugą 
        i dodajemy je. Po tej operacji mamy wynik rozłożony na 32 bitach (na każdych 4 bajtach).
        Potem nakładamy ćwiartkę... itd.

        Po tej operacji dostajemy:
        (1) Suma_even
        (2) Suma_odd

        Obliczamy ich różnicę (przedział wartości różnicy to [-120, 120])

        Teraz jeśli liczba jest ujemna, to póki taka pozostaje, dodajemy 17.
        Jeśli liczba jest dodatnia i większa od 17, to odejmujemy 17, póki taka pozostanie.

        (Moja implementacja używa instrukcji skoku warunkowego...)
 */

mod17:
        mov     $1085102592571150095, %r9 /* Tworzymy maskę 0x0F0F..., żeby oddzielić kubełki */
        mov     %rdi, %rdx
        mov     %rdi, %rcx
        and     %r9, %rdx /* %rdx -> Suma_even */
        shr     $4, %rcx
        and     %r9, %rcx /* %rcx -> Suma_odd */
        mov     %rdx, %r9 
        mov     %rcx, %r10
        shr     $32, %r9 /* "Nakładamy" na siebie dwie części liczby */
        shr     $32, %r10 /* -//- */
        add     %r9, %rdx /* Sumujemy */
        add     %r10, %rcx /* -//- */
        mov     %rdx, %r9
        mov     %rcx, %r10
        shr     $16, %r9 /* itd. */
        shr     $16, %r10
        add     %r9, %rdx
        add     %r10, %rcx
        mov     %rdx, %r9
        mov     %rcx, %r10
        shr     $8, %r9
        shr     $8, %r10
        add     %r9, %rdx
        add     %r10, %rcx
        mov     $255, %r9
        and     %r9, %rdx  /* Suma_even & 0xFF */
        and     %r9, %rcx  /* Suma_odd & 0xFF */
        mov     %rdx, %rax
        sub     %rcx, %rax /* %rax -> Suma_even - Suma_odd */
        jns     .L2
.L1:    
        add     $17, %rax /* %rax było ujemne, więc odpowiednio zmieniamy wynik (zachowując modulo 17) */
        js      .L1
.L2:
        cmp     $16, %rax /* %rax było dodatnie, większe równe 17, -//- */
        jle     .L5
.L3:
        sub     $17, %rax
        jns     .L3
        add     $17, %rax
.L5:
        ret
        .size   mod17, .-mod17
