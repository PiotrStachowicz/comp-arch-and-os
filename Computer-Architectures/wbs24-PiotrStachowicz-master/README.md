[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/kVLBmadM)
Ważona suma bitów
===

W pliku `wbs.s` zaprogramuj w asemblerze `x86-64` procedurę o sygnaturze
`uint64_t wbs(uint64_t)`. Dla danego słowa maszynowego
<tt>b<sub>n-1</sub>...b<sub>0</sub></tt> procedura ma wyznaczyć jego
ważoną sumę bitów (przyjmujemy, że waga bitu <tt>b<sub>i</sub></tt>, wynosi
<tt>i</tt>), czyli wynikiem działania programu powinna być suma
<tt>Σ b<sub>i</sub>*i</tt>. Rozwiązanie ma działać w złożoności `O(log n)`,
gdzie `n` jest długością słowa maszynowego w bitach.


### Ważne

1. Można używać wyłącznie instrukcji arytmetyczno-logicznych poznanych na
   wykładzie i ćwiczeniach.
2. Użycie instrukcji sterujących (poza `ret`) jest niedozwolone!
3. Modyfikowanie innych plików niż `wbs.s` jest niedozwolone!
4. Twoje rozwiązanie nie może być dłuższe niż 90 instrukcji.
5. Za rozwiązania używające funkcji `popcnt` będzie można uzyskać do 2 punktów.
6. Pełną liczbę punktów można uzyskać wyłącznie za rozwiązanie, które jest
   nie dłuższe niż 50 instrukcji. Dokładniejsze informacje można znaleźć
   w pliku `.github/classroom/autograding.json`.
7. Za rozwiązanie spełniające powyższe oraz dodatkowe wymogi określone
   w pliku `Makefile`, można uzyskać punkt bonusowy.



### Pamiętaj:

1. Podpisz się w treści rozwiązania.
2. Nie zamykaj _Pull Request_ o nazwie _Feedback_!
3. W zakładce _zmienione pliki_ (ang. _changed files_) _Pull Request_ o nazwie
   _Feedback_ ma być widać wyłącznie treść Twojego rozwiązania!
