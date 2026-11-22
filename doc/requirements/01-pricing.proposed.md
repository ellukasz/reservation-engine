# Wymagania biznesowe: Cennik

> Dokument nadrzędny: `00-overview.md`; ustalenia otwarte: §7. **Decyzje właściciela:** ceny za noc w pełnych złotych, bez ceny minimalnej i bez poziomów procentowych; jeden narzut procentowy na Booking i Airbnb; zaliczka 10–100%, domyślnie 30%, wyłącznie dla rezerwacji z naszego linku, zaokrąglana w górę; minimalny czas pobytu domyślnie 1 noc (1–14), nadpisywany w wybranych miesiącach.

## 1. Cel modułu

Właściciel ustawia ceny całego ośrodka na jednym ekranie telefonu — bez tabel i osobnych cenników. Cennik ma **trzy elementy**: cenę za noc w środku tygodnia (`nd–czw`), cenę za noc w weekend (`pt–sob`) i jeden narzut na Booking i Airbnb. Na tym samym ekranie są **dwa ustawienia z wartościami domyślnymi**: wysokość zaliczki (30%, od 10% do 100%) i minimalny czas pobytu (1 noc, od 1 do 14). Gość z naszego linku widzi pełną kwotę do zapłaty przed wpłatą (§1.1). W module nie ma świąt ani opłat dodatkowych.

Cena jest wspólna dla wszystkich jednostek: przy 1–20 domkach, apartamentach lub pokojach zakładamy jednostki jednorodne, a własna cena obiektu jest poza MVP (§2).

## 1.1. Pojęcia

- **Noc** — liczy się według dnia, w którym się zaczyna. Weekendowe są dwie noce: z piątku na sobotę i z soboty na niedzielę (`pt–sob`); pozostałe pięć, także z niedzieli na poniedziałek i z czwartku na piątek, ma cenę środka tygodnia (`nd–czw`).
- **Cena za noc, cena bazowa** — kwota za jedną noc w pełnych złotych, większa od zera; zawiera podatki, więc ponad nią gość nic nie dopłaca. Cena bazowa to cena ośrodka przed wpisami na wybrane miesiące.
- **Cena w wybranych miesiącach** (sezon) — kwota za noc na wybrane miesiące, osobno dla `nd–czw` i `pt–sob`; zastępuje cenę bazową w tych miesiącach.
- **Cena pobytu** — suma cen wszystkich nocy pobytu, po cenach z wybranych miesięcy.
- **Narzut** — jeden procent (0–100%) dodawany do ceny wysyłanej do Booking i Airbnb.
- **Cena portalu** — cena za noc powiększona o narzut i zaokrąglona w górę do pełnych złotych; za pobyt to suma takich nocy.
- **Pełna kwota do zapłaty** — cena pobytu; gość z naszego linku widzi ją razem z zaliczką i resztą przed wpłatą (§3.3).
- **Zaliczka** — kwota płatna online z naszego linku: ustawiony procent ceny pobytu (10–100%, domyślnie 30%) zaokrąglony w górę do pełnych złotych. **Reszta** to cena pobytu minus zaliczka, bez drugiego zaokrąglenia, więc obie kwoty sumują się dokładnie do ceny pobytu. Podstawą jest zawsze cena pobytu, także w miesiącach z inną ceną; cena portalu nigdy nie jest podstawą.
- **Minimalny czas pobytu** — najmniejsza liczba nocy do zarezerwowania: jedna wartość dla ośrodka (1–14, domyślnie 1), nadpisywana wpisem na wybrane miesiące.
- **Gość z naszego linku** — gość rezerwujący bezpośrednio u właściciela.
- **Wpis ręczny** — rezerwacja zapisana przez właściciela samodzielnie (telefon, zeszyt, wczasy.pl, OLX, Facebook).

## 2. Zakres MVP

- **KRYTYCZNE (bez tego nie startujemy):** cena za noc w środku tygodnia (`nd–czw`), cena za noc w weekend (`pt–sob`) i jeden narzut procentowy na ceny w Booking i Airbnb; obok nich dwa ustawienia z wartościami domyślnymi: wysokość zaliczki i minimalny czas pobytu.
- **W MVP:** „Zmień ceny w miesiącach" — dwie kwoty za noc i opcjonalne minimum nocy dla wybranych miesięcy (§4.1).
- **POZA MVP:** obiekt z własną ceną (VIP), szybka zmiana ceny z kalendarza, minimum nocy dla dowolnego zakresu dat, obniżka na ostatnią chwilę, osobna zaliczka dla obiektu, sezonu albo portalu, porównywanie ceny z kosztami.
- **WYCIĘTE:** uzupełnianie pojedynczej wolnej nocy, rabaty za długi pobyt, ceny zależne od liczby osób, opłaty dodatkowe (sprzątanie, zwierzęta), kody rabatowe.

## 3. Jak liczy się cena

### 3.1. Cena zawsze dodatnia

Cena za noc jest zawsze większa od zera i podana w pełnych złotych. Zero, liczby ujemne i grosze są blokowane w każdym polu cenowym. Narzut tylko podnosi cenę w portalu — ujemny narzut nie istnieje. Nie ma ceny minimalnej ani poziomów procentowych.

### 3.2. Kolejność

1. **Cena bazowa:** cena dla środka tygodnia (`nd–czw`) albo weekendu (`pt–sob`) (§1.1).
2. **Cena z wybranych miesięcy, jeśli ustawiona:** zastępuje cenę bazową w tych miesiącach, osobno dla `nd–czw` i `pt–sob` (§4.1).
3. **Narzut:** doliczany wyłącznie do ceny wysyłanej do Booking i Airbnb, od każdej nocy osobno, w górę do pełnych złotych. Przykład: 450 zł i narzut 16% dają 522 zł. Cena portalu za pobyt to suma nocy z narzutem, nie narzut od sumy.

**Zaliczka nie jest ceną nocy.** Liczy się raz, od ceny całego pobytu (§3.3).

### 3.3. Co płaci gość

| Kto rezerwuje | Co widzi przed wpłatą | Co płaci online |
|---|---|---|
| **Gość z naszego linku** | cenę pobytu bez narzutu, wyliczoną zaliczkę i resztę na miejscu | zaliczkę |
| **Gość Booking lub Airbnb** | cenę portalu, czyli sumę nocy z narzutem | portal według własnych zasad; nasz system nic nie pobiera |
| **Wpis ręczny** | kwotę wpisaną przez właściciela | nic; rozliczenie po stronie właściciela |

- **Zaliczka i reszta sumują się do ceny pobytu** i obie są widoczne przed wpłatą; przy 100% reszta wynosi zero, a gość widzi „całość zapłacona online".
- **Wysokość zaliczki dotyczy wyłącznie rezerwacji z naszego linku.** Gość z linku nigdy nie widzi narzutu.

## 4. Szczegóły ustawień

### 4.1. Zmiana cen w wybranych miesiącach

Jeden przycisk na ekranie cennika. Właściciel zaznacza miesiące, wpisuje dwie kwoty za noc i w razie potrzeby inne minimum nocy (§4.3). Wpis może dać kwotę wyższą albo niższą od bazy.

- **Miesiące:** zaznaczony miesiąc oznacza ten miesiąc w każdym roku; jeden miesiąc należy tylko do jednego wpisu, więc okresy się nie nakładają. Usunięcie wpisu wraca do ceny bazowej.
- **Ceny:** większe od zera, w pełnych złotych (§3.1).
- **Zapis:** wysyła ceny na 12 miesięcy do przodu; okno przesuwa każdy zapis (§7 pkt 4).
- **Gość:** przed wyborem daty widzi ceny bazowe (`nd–czw` i `pt–sob`, §4.2) oraz domyślne minimum nocy; ceny z wpisów sezonowych pojawiają się po wyborze daty, w cenie pobytu (§3.3).
- **Rezerwacje:** „Potwierdzona" i „Oczekuje na wpłatę" pozostają bez zmian (§6 pkt 1).

### 4.2. Dwie ceny bazowe

Weekend to dwie noce — z piątku na sobotę i z soboty na niedzielę; pozostałe pięć ma cenę środka tygodnia (§1.1). Nie ma cen świątecznych ani zależnych od liczby osób. Pobyt na przełomie cen to suma nocy (§6 pkt 2).

### 4.3. Minimalny czas pobytu

Jedna wartość dla całego ośrodka: domyślnie 1 noc, od 1 do 14. Wpis na wybrane miesiące nadpisuje ją tylko w tych miesiącach (§4.1). O wymogu decyduje **dzień przyjazdu**: jeśli przypada w miesiącu z wpisem, obowiązuje minimum z tego wpisu, inaczej wartość ośrodka (§6 pkt 3). Przed wyborem daty gość widzi wartość ośrodka; wymóg z wpisu pojawia się po wyborze daty przyjazdu (§4.1). Wymóg trafia do Booking i Airbnb razem z cenami, żeby portal nie przyjął krótszego pobytu. Zmiana nie dotyczy rezerwacji „Potwierdzona" ani „Oczekuje na wpłatę" (§6 pkt 1).

## 5. Wymagania funkcjonalne

### 5.1. Wspólne ustawienia cennika — [KRYTYCZNE]; „Zmień ceny w miesiącach" — [w MVP]

Jako właściciel chcę ustawić ceny całego ośrodka na jednym ekranie, aby nie poprawiać każdego domku osobno.

- **Cena za noc w środku tygodnia (`nd–czw`)** — kwota w pełnych złotych, większa od zera (§3.1).
- **Cena za noc w weekend (`pt–sob`)** — kwota w pełnych złotych, większa od zera (§3.1).
- **Narzut na Booking i Airbnb** — jedna wartość procentowa od 0% do 100%; zero znaczy „nie podnosimy ceny w portalach"; system nie różnicuje portali.
- **Wysokość zaliczki** — od 10% do 100%, domyślnie 30%; dotyczy wyłącznie rezerwacji z naszego linku (§3.3).
- **Minimalny czas pobytu** — domyślnie 1 noc, od 1 do 14; wpis na wybrane miesiące ją nadpisuje (§4.3).

System nie zna prowizji portalu ani opłaty operatora, więc nie policzy zysku i nie zablokuje zapisu.

**Kryteria akceptacji:**

- **Jeśli** właściciel zapisze nowe ceny, nową wysokość zaliczki albo nowe minimum nocy, **gdy** dotknie „Zapisz", **to** w ciągu kilku sekund ceny są na stronie rezerwacji oraz w Booking i Airbnb na 12 miesięcy do przodu, a nowa zaliczka obowiązuje wyłącznie nowe rezerwacje z naszego linku; istniejące rezerwacje zachowują warunki (§6 pkt 1).
- **Jeśli** właściciel wpisze zero, liczbę ujemną albo kwotę z groszami, ujemny narzut, zaliczkę poza 10–100% albo minimum poza 1–14 nocy, **gdy** próbuje zapisać, **to** system nie zapisuje i pokazuje powód; dla narzutu zero jest dozwolone.
- **Jeśli** właściciel ustawi zaliczkę 40% i minimum 2 noce z wpisem na lipiec na 1 noc, **gdy** gość z naszego linku otworzy pobyt za 1000 zł, **to** przed wpłatą widzi 1000 zł, zaliczkę 400 zł i 600 zł na miejscu, a w lipcu obowiązuje 1 noc, w pozostałych miesiącach 2.

### 5.2. Funkcje poza MVP

Nie są wymaganiami startowymi; wrócą po świadomej decyzji (§2): własna cena obiektu (VIP), szybka zmiana ceny z kalendarza, minimalny czas pobytu dla dowolnego zakresu dat i obniżka na ostatnią chwilę. Reguły z §3.1 oraz §6 pkt 1 i 3 obowiązują także po ich wdrożeniu.

## 6. Przypadki brzegowe

1. **Istniejące rezerwacje są nienaruszalne.** Zmiana cen, zaliczki ani minimum nocy nie zmienia kwoty i warunków rezerwacji „Potwierdzona" ani „Oczekuje na wpłatę".
2. **Pobyt na przełomie cen i miesięcy.** Cena pobytu to suma cen kolejnych nocy: 350 zł i 450 zł dają 800 zł; przy zaliczce 30% to 240 zł i 560 zł na miejscu, przy 40% — 320 zł i 480 zł.
3. **Minimum nocy na przełomie miesięcy.** Decyduje dzień przyjazdu: przyjazd w miesiącu z wymogiem 1 nocy oznacza 1 noc, także gdy kolejna noc wypada w miesiącu z wymogiem 3 nocy.
4. **Narzut nie wchodzi do ceny z naszego linku.** Zaliczka nigdy nie liczy się od ceny portalu, więc ta sama noc nie ma dwóch kwot.
5. **Pieniądze z portalu.** Rezerwacja z Booking lub Airbnb zamyka termin od razu i jest „Potwierdzona"; portal pobiera wpłatę według własnych zasad, a nasza zaliczka jej nie dotyczy.
6. **Wpis ręczny.** Wpis z telefonu, zeszytu, wczasy.pl, OLX i Facebooka zamyka termin także w Booking i Airbnb w kilka sekund; nie wysyłamy tam ceny, więc nie ma narzutu.

## 7. Ustalenia otwarte przed startem

1. **Zaliczka a dokument nadrzędny.** `00-overview.md` podaje stałe 30%, ten dokument 10–100% — rozstrzygnięcie przed startem.
2. **Zasady zwrotu zaliczki.** `00-overview.md` je obiecuje, ale żaden dokument ich nie podaje — warunek startu.
3. **Limit dotknięć.** Przy kilku miesiącach „Zmień ceny w miesiącach" wymaga 5 dotknięć zamiast 2–3 — potrzebna zgoda właściciela przed startem.
4. **Okno 12 miesięcy.** Przesuwa je tylko zapis cennika; zachowanie cen w portalach po roku — do ustalenia.
