# Wymagania biznesowe: Cennik

> Dokument nadrzędny: `00-overview.md`. Ten dokument opisuje wyłącznie działanie cennika (zgodnie z `00-overview.md` §4): jak liczą się ceny, zaliczka, narzut i minimalny czas pobytu. Przebieg rezerwacji, płatności, potwierdzeń, zwrotów i zamykania terminów należy opisać w osobnym dokumencie wymagań, a ten dokument ma się do niego tylko odwoływać. **Decyzje właściciela:** ceny za noc w pełnych złotych, bez ceny minimalnej i bez poziomów procentowych; osobne narzuty — na Booking i na Airbnb —; zaliczka od 10% do 100%, domyślnie 30%, wyłącznie dla rezerwacji z naszego linku, zaokrąglana w górę; minimalny czas pobytu domyślnie 1 noc (1–14), nadpisywany w wybranych miesiącach.

## 1. Cel modułu

Właściciel ustawia ceny całego ośrodka na jednym ekranie telefonu — bez tabel i osobnych cenników. Cennik ma **cztery elementy**: cena za noc w środku tygodnia (`nd–czw`), cena za noc w weekend (`pt–sob`), narzut na Booking i narzut na Airbnb — tak, że każdy portal otrzymuje własną cenę. Na tym samym ekranie jest **sześć pól**: te cztery elementy cennika oraz wysokość zaliczki i minimalny czas pobytu — jeden ekran, obecna prostota MVP (bez tabel, wykresów ani skrótów technicznych). Zmiana cen w wybranych miesiącach to jedna dodatkowa czynność na tym ekranie, a nie drugi cennik (§4.1). Gość z naszego linku widzi pełną kwotę do zapłaty bez narzutów, zaliczkę i resztę przed wpłatą (§1.1, §3.3). W module nie ma świąt ani opłat dodatkowych.

Wszystko mieści się na jednym ekranie telefonu, obsługiwanym jedną ręką: sześć pól do wpisania lub zatwierdzenia — cena nocy środka tygodnia (`nd–czw`), cena nocy weekendu (`pt–sob`), narzut na Booking, narzut na Airbnb, wysokość zaliczki i minimalny czas pobytu — i jeden przycisk „Zapisz zmiany". Sześć pól mieści się na jednym ekranie; na mniejszych telefonach ekran może się przewijać, a przycisk „Zapisz zmiany" pozostaje widoczny na dole. Po dotknięciu „Zmień ceny w miesiącach" na tym samym ekranie otwiera się przewijana siatka dwunastu miesięcy — przyciski, nie tabela — którą obsługuje się jedną ręką. Nie ma tabel, wykresów ani skrótów technicznych. Jeżeli gość przed wpłatą ma widzieć zasady zwrotu lub inne warunki rezerwacji, ten dokument je tylko wymienia jako odwołanie do osobnego wymagania procesu rezerwacji.

Cena jest wspólna dla wszystkich jednostek: przy 1–20 domkach, apartamentach lub pokojach zakładamy jednostki jednorodne, a własna cena obiektu jest poza MVP (§2).

## 1.1. Pojęcia

- **Noc** — liczy się według dnia, w którym się zaczyna. Weekendowe są dwie noce: z piątku na sobotę i z soboty na niedzielę (`pt–sob`); pozostałe pięć, także z niedzieli na poniedziałek i z czwartku na piątek, ma cenę środka tygodnia (`nd–czw`).
- **Cena za noc, cena bazowa** — kwota za jedną noc w pełnych złotych, większa od zera; zawiera podatki, więc ponad nią gość nic nie dopłaca. Cena bazowa to cena ośrodka przed wpisami na wybrane miesiące.
- **Cena w wybranych miesiącach** (sezon) — kwota za noc na wybrany miesiąc, osobno dla `nd–czw` i `pt–sob`; zastępuje cenę bazową w tym miesiącu. Jeden wpis obejmuje jeden miesiąc i jest pokazywany, zmieniany i usuwany jako całość (§4.1).
- **Cena pobytu** — suma cen wszystkich nocy pobytu, po cenach z wybranych miesięcy.
- **Narzut na Booking** — procent (0–100%) dodawany do ceny wysyłanej do Booking; gość z naszego linku go nie widzi (§3.2, §3.3).
- **Narzut na Airbnb** — procent (0–100%) dodawany do ceny wysyłanej do Airbnb; gość z naszego linku go nie widzi (§3.2, §3.3).
- **Cena portalu** — kwota wysłana do portalu i pokazana gościowi jako cena noclegu: cena za noc powiększona o narzut danego portalu (Booking lub Airbnb) i zaokrąglona w górę do pełnych złotych; za pobyt to suma takich nocy. Opłaty samego portalu są poza tą kwotą i poza tym dokumentem.
- **Pełna kwota do zapłaty** — cena pobytu; gość z naszego linku widzi ją razem z zaliczką i resztą przed wpłatą (§3.3).
- **Zaliczka** — kwota płatna online z naszego linku: ustawiony procent ceny pobytu (10–100%, domyślnie 30%) zaokrąglony w górę do pełnych złotych. **Reszta** to cena pobytu minus zaliczka, bez drugiego zaokrąglenia, więc obie kwoty sumują się dokładnie do ceny pobytu. Podstawą jest zawsze cena pobytu, także w miesiącach z inną ceną; cena portalu nigdy nie jest podstawą. 30% to wartość, którą pole zaliczki ma wypełnione na start; właściciel może ją zmienić w zakresie 10–100%. Moment pobrania, potwierdzenia i zwrotu zaliczki opisuje osobny dokument procesu rezerwacji.
- **Minimalny czas pobytu** — najmniejsza liczba nocy do zarezerwowania: jedna wartość dla ośrodka (1–14, domyślnie 1), nadpisywana wpisem na wybrany miesiąc.
- **Gość z naszego linku** — gość rezerwujący bezpośrednio u właściciela.
- **Wpis ręczny** — rezerwacja zapisana przez właściciela samodzielnie (telefon, zeszyt, wczasy.pl, OLX, Facebook).

## 2. Zakres MVP

- **KRYTYCZNE (bez tego nie startujemy):** cena za noc w środku tygodnia (`nd–czw`), cena za noc w weekend (`pt–sob`), narzut na Booking, narzut na Airbnb, wysokość zaliczki i minimalny czas pobytu — sześć pól.
- **W MVP:** „Zmień ceny w miesiącach" — dwie kwoty za noc i opcjonalne minimum nocy dla jednego miesiąca, w trzech dotknięciach (§4.1).
- **POZA MVP:** obiekt z własną ceną (VIP), szybka zmiana ceny z kalendarza, minimum nocy dla dowolnego zakresu dat, obniżka na ostatnią chwilę, wpis obejmujący kilka miesięcy jednym zapisem, osobna zaliczka dla obiektu, sezonu albo portalu, porównywanie ceny z kosztami.
- **WYCIĘTE:** uzupełnianie pojedynczej wolnej nocy, rabaty za długi pobyt, ceny zależne od liczby osób, opłaty dodatkowe (sprzątanie, zwierzęta), kody rabatowe.

## 3. Jak liczy się cena

### 3.1. Cena zawsze dodatnia

Cena za noc jest zawsze większa od zera, podana w pełnych złotych i nie większa niż 99 999 zł. Zero, liczby ujemne, grosze i kwoty powyżej 99 999 zł są blokowane w każdym polu cenowym. Narzut tylko podnosi cenę w portalu — ujemny narzut nie istnieje. Nie ma ceny minimalnej ani poziomów procentowych.

### 3.2. Kolejność

1. **Cena bazowa:** cena dla środka tygodnia (`nd–czw`) albo weekendu (`pt–sob`) (§1.1).
2. **Cena z wybranego miesiąca, jeśli ustawiona:** zastępuje cenę bazową w tym miesiącu, osobno dla `nd–czw` i `pt–sob` (§4.1).
3. **Narzut na Booking i narzut na Airbnb:** osobne narzuty dla każdego portalu — doliczane wyłącznie do ceny wysyłanej do tego portalu, od każdej nocy osobno, w górę do pełnych złotych. Przykład: noc 450 zł, narzut Booking 16% i narzut Airbnb 10% — gość z linku widzi 450 zł, Booking pokazuje 522 zł, Airbnb pokazuje 495 zł. Cena portalu za pobyt to suma nocy z narzutem danego portalu, nie narzut od sumy.

**Zaliczka nie jest ceną nocy.** Liczy się raz, od ceny całego pobytu (§3.3).

### 3.3. Co płaci gość

| Kto rezerwuje | Co widzi przed wpłatą | Jak liczy się kwota w cenniku |
|---|---|---|
| **Gość z naszego linku** | cenę pobytu bez narzutu, wyliczoną zaliczkę i resztę na miejscu | zaliczka to procent ceny pobytu; reszta to cena pobytu minus zaliczka |
| **Gość Booking lub Airbnb** | cenę portalu, czyli kwotę wysłaną do portalu — sumę nocy z narzutem tego portalu | cena portalu to suma nocy z narzutem danego portalu; nasz system nie liczy tu zaliczki |
| **Wpis ręczny** | kwotę wpisaną przez właściciela | kwota poza kalkulatorem cennika |

- **Cena portalu to kwota wysłana przez nasz system** i pokazana gościowi jako cena noclegu; opłaty samego portalu są poza nią i poza tym dokumentem.
- **Zaliczka i reszta sumują się do ceny pobytu** i obie są widoczne przed wpłatą; przy 100% reszta wynosi zero, a gość widzi „całość zapłacona online".
- **Wysokość zaliczki dotyczy wyłącznie rezerwacji z naszego linku.** Gość z linku nigdy nie widzi narzutu.
- **Kwota rezerwacji pochodzi z cennika.** Rezerwacja z naszego linku zapisuje cenę pobytu, zaliczkę i resztę wyliczone w chwili jej utworzenia. Szczegóły przebiegu: oczekiwanie na wpłatę, potwierdzenie, wygaśnięcie, odwołanie i zwrot opisuje osobny dokument procesu rezerwacji.

## 4. Szczegóły ustawień

### 4.1. Zmiana cen w wybranych miesiącach

Jeden przycisk na ekranie cennika. Właściciel zaznacza jeden miesiąc, wpisuje dwie kwoty za noc i w razie potrzeby inne minimum nocy (§4.3). Wpis może dać kwotę wyższą albo niższą od bazy.

- **Miesiące:** zaznaczony miesiąc oznacza ten miesiąc w każdym roku; jeden miesiąc należy tylko do jednego wpisu, więc okresy się nie nakładają. Usunięcie wpisu wraca do ceny bazowej.
- **Widok na telefonie:** po dotknięciu „Zmień ceny w miesiącach" na tym samym ekranie pojawia się przewijana siatka dwunastu miesięcy — przyciski, nie tabela. Każdy kafelek pokazuje pełną nazwę miesiąca, oznaczenie „własna cena" albo „cena wspólna", obie ceny za noc i minimum nocy; dotknięcie otwiera wpis. Właściciel od razu widzi, gdzie ma własną cenę, a gdzie wspólną. Nie ma drugiego ekranu ani osobnej listy wpisów. Legenda wyjaśnia, że tydzień to noce od niedzieli do czwartku (`nd–czw`), a weekend to noce z piątku na sobotę i z soboty na niedzielę (`pt–sob`). Na małym ekranie lub przy dużej czcionce kafelki układają się w jedną kolumnę.
- **Zmiana i usunięcie:** dotknięcie miesiąca pokazuje jego dwie kwoty i minimum, wypełnione tym, co obowiązuje (wpis albo baza). Cały formularz, łącznie z otwartym wpisem, zmienia się jednym „Zapisz zmiany", a wpis usuwa się jednym „Usuń wpis"; wtedy miesiąc wraca do ceny bazowej. Dotknięcie miesiąca z istniejącego wpisu otwiera ten wpis, więc nie da się przypadkiem zrobić drugiego.
- **Dotknięcia:** otwarcie „Zmień ceny w miesiącach", dotknięcie miesiąca i „Zapisz zmiany" to trzy dotknięcia; wpisanie kwot to dane, nie dodatkowe dotknięcia. Usunięcie wpisu to dwa dotknięcia od otwartego wpisu („Usuń wpis" i potwierdzenie). Jeden wpis dotyczy jednego miesiąca, więc zasada minimalnej liczby dotknięć jest dotrzymana (§7 pkt 4).
- **Ceny:** większe od zera, w pełnych złotych (§3.1).
- **Zapis i okno 12 miesięcy:** zapis wysyła ceny na 12 miesięcy do przodu. Ceny nie wygasają: poza wpisami obowiązuje cena bazowa, a system sam dopisuje kolejny miesiąc i wysyła go do portali, więc właściciel nie musi nic powtarzać. Okno przesuwa każdy zapis oraz codzienne odświeżanie w tle (§7 pkt 5).
- **Gość:** przed wyborem daty widzi ceny bazowe oznaczone jako „od" (`nd–czw` i `pt–sob`, §4.2) oraz domyślne minimum nocy — to nie jest cena wybranego terminu; po wyborze daty widzi cenę pobytu, w tym wpisy sezonowe (§3.3).
- **Istniejące rezerwacje:** zmiana cennika nie zmienia kwot zapisanych w już utworzonych rezerwacjach; szczegóły stanów rezerwacji opisuje osobny dokument procesu rezerwacji.

### 4.2. Dwie ceny bazowe

Weekend to dwie noce — z piątku na sobotę i z soboty na niedzielę; pozostałe pięć ma cenę środka tygodnia (§1.1). Nie ma cen świątecznych ani zależnych od liczby osób. Pobyt na przełomie cen to suma nocy (§6 pkt 2).

### 4.3. Minimalny czas pobytu

Jedna wartość dla całego ośrodka: domyślnie 1 noc, od 1 do 14. Wpis na wybrany miesiąc może nadpisać ją tylko w tym miesiącu; jeśli wpis nie podaje własnego minimum, obowiązuje wartość ośrodka (§4.1). O wymogu decyduje **dzień przyjazdu**: jeśli przypada w miesiącu z wpisem, obowiązuje minimum z tego wpisu, inaczej wartość ośrodka (§6 pkt 3). Przed wyborem daty gość widzi wartość ośrodka; wymóg z wpisu pojawia się po wyborze daty przyjazdu, razem z informacją, ile nocy trzeba zarezerwować (§4.1). Wymóg trafia do Booking i Airbnb razem z cenami, żeby portal nie przyjął krótszego pobytu. Zmiana nie dotyczy istniejących rezerwacji (§6 pkt 1).

## 5. Wymagania funkcjonalne

### 5.1. Wspólne ustawienia cennika — [KRYTYCZNE]; „Zmień ceny w miesiącach" — [w MVP]

Jako właściciel chcę ustawić ceny całego ośrodka na jednym ekranie, aby nie poprawiać każdego domku osobno.

- **Cena za noc w środku tygodnia (`nd–czw`)** — kwota w pełnych złotych, większa od zera (§3.1).
- **Cena za noc w weekend (`pt–sob`)** — kwota w pełnych złotych, większa od zera (§3.1).
- **Narzut na Booking** — procent od 0% do 100%; 0 znaczy „nie podnosimy ceny w Booking"; przy polu widać wyliczoną cenę portalu dla ceny bazowej — 450 zł i 16% dają 522 zł — więc właściciel zna kwotę bez wchodzenia do portalu (§1.1, §3.2).
- **Narzut na Airbnb** — procent od 0% do 100%; 0 znaczy „nie podnosimy ceny w Airbnb"; przy polu widać wyliczoną cenę portalu dla ceny bazowej — 450 zł i 10% dają 495 zł.
- **Wysokość zaliczki** — pole edytowalne, na start wypełnione 30%, do zmiany w zakresie 10–100%; dotyczy wyłącznie rezerwacji z naszego linku (§3.3).
- **Minimalny czas pobytu** — domyślnie 1 noc, od 1 do 14; wpis na wybrany miesiąc może ją nadpisać, a bez własnego minimum obowiązuje wartość ośrodka (§4.3).

Przy polu narzutu widać wyliczoną cenę portalu dla ceny bazowej, więc właściciel porównuje ją ze stawką portalu i sam ocenia, czy narzut pokrywa koszt; prowizje Booking/Airbnb i opłata operatora nie są doliczane automatycznie i pozostają poza tym dokumentem (§7 pkt 3). Po zapisie ekran pokazuje potwierdzenie przyjęcia cen przez Booking i Airbnb; jeśli portal ich nie potwierdzi albo nadpisze cenę, pojawia się czytelny komunikat, a system wysyła ceny ponownie.

**Kryteria akceptacji:**

- **Jeśli** właściciel zapisze nowe ceny, nową wysokość zaliczki, nowe minimum nocy albo wpis na wybrany miesiąc, **gdy** dotknie „Zapisz zmiany", **to** w ciągu kilku sekund ceny są na stronie rezerwacji oraz w Booking i Airbnb na 12 miesięcy do przodu, a nowe wartości obowiązują wyłącznie nowe wyliczenia i nowe rezerwacje; istniejące rezerwacje zachowują zapisane kwoty (§6 pkt 1). System pokazuje potwierdzenie przyjęcia cen przez Booking i Airbnb; jeśli portal nie potwierdzi albo nadpisze cenę, pojawia się czytelny komunikat, a ceny są wysyłane ponownie.
- **Jeśli** właściciel wpisze zero, liczbę ujemną, kwotę z groszami albo kwotę powyżej 99 999 zł, ujemny narzut, zaliczkę poza 10–100% albo minimum poza 1–14 nocy, **gdy** próbuje zapisać, **to** system nie zapisuje i pokazuje powód; dla narzutu zero jest dozwolone.
- **Jeśli** cennik nie może się wczytać, **gdy** właściciel otwiera ekran, **to** system blokuje zapis i pokazuje „Nie udało się wczytać cennika" oraz „Spróbuj ponownie".
- **Jeśli** właściciel ustawi zaliczkę 40%, minimum 2 noce i wpis na lipiec z minimum 1 noc, **gdy** gość z naszego linku wybierze 2 noce z przyjazdem 10 lipca za 1000 zł, **to** przed wpłatą widzi 1000 zł, zaliczkę 400 zł i 600 zł na miejscu; **gdy** wybierze przyjazd 10 czerwca na 1 noc, **to** system nie pozwala przejść dalej i pokazuje wymóg 2 nocy. **Jeśli** właściciel ustawi narzut Booking 16% i narzut Airbnb 10%, **gdy** gość z Booking wybierze noc z ceną bazową 450 zł, **to** w Booking pokazuje się 522 zł, a gość z Airbnb — 495 zł; obie ceny różnią się od ceny pobytu z naszego linku (§1.1, §3.2).

### 5.2. Funkcje poza MVP

Nie są wymaganiami startowymi; wrócą po świadomej decyzji (§2): własna cena obiektu (VIP), szybka zmiana ceny z kalendarza, minimalny czas pobytu dla dowolnego zakresu dat, wpis obejmujący kilka miesięcy jednym zapisem i obniżka na ostatnią chwilę. Reguły z §3.1 oraz §6 pkt 1 i 3 obowiązują także po ich wdrożeniu.

## 6. Przypadki brzegowe

1. **Istniejące rezerwacje są nienaruszalne.** Zmiana cen, zaliczki ani minimum nocy nie zmienia kwot zapisanych w istniejących rezerwacjach. Stany rezerwacji i zasady ich zmiany opisuje osobny dokument procesu rezerwacji.
2. **Pobyt na przełomie cen i miesięcy.** Cena pobytu to suma cen kolejnych nocy: 350 zł i 450 zł dają 800 zł; przy zaliczce 30% to 240 zł zaliczki i 560 zł na miejscu, przy 40% — 320 zł zaliczki i 480 zł.
3. **Minimum nocy na przełomie miesięcy.** Decyduje dzień przyjazdu: przyjazd w miesiącu z wymogiem 1 nocy oznacza 1 noc, także gdy kolejna noc wypada w miesiącu z wymogiem 3 nocy.
4. **Narzut nie wchodzi do ceny z naszego linku.** Zaliczka liczy się wyłącznie od ceny pobytu z naszego linku, a cena portalu jest osobną kwotą dla gościa portalu. Dlatego ta sama noc ma trzy kwoty zależne od źródła — link, Booking, Airbnb — a gość płaci według źródła, z którego rezerwuje: 450 zł z linku, 522 zł w Booking, 495 zł w Airbnb.
5. **Cena w portalu.** Rezerwacja z Booking lub Airbnb korzysta z ceny portalu, czyli kwoty wysłanej przez nasz system i pokazanej gościowi jako cena noclegu; nasz system nie liczy od niej zaliczki z naszego linku, a opłaty samego portalu pozostają poza tą kwotą.
6. **Wpis ręczny.** Właściciel zapisuje kwotę wpisu ręcznego sam; system nie dolicza do niej narzutu portalu ani zaliczki z naszego linku.
7. **Wpis na jeden miesiąc.** Usunięcie wpisu przywraca cenę bazową w tym miesiącu; rezerwacje już zapisane zachowują kwotę (§6 pkt 1).
8. **Miesiąc z wpisem wybrany ponownie.** Dotknięcie takiego miesiąca otwiera istniejący wpis, więc ten sam miesiąc nie trafia do dwóch wpisów i ceny się nie nakładają.

## 7. Ustalenia przed startem

1. **Zaliczka — jedna zasada.** Obowiązuje zaliczka od 10% do 100%, domyślnie 30%, pole edytowalne (§5.1); gość zawsze widzi wyliczoną zaliczkę przed wpłatą. `00-overview.md:38` podaje 30% — ta wartość jest domyślna, a edytowalny zakres 10–100% jest wiążący w cenniku.
2. **Narzuty portali.** Cennik stosuje osobny narzut dla Booking i osobny dla Airbnb, zgodnie z dokumentem nadrzędnym; każdy portal otrzymuje własną cenę.
3. **Prowizje i opłaty operatora.** Prowizje Booking/Airbnb i opłata operatora płatności nie są doliczane automatycznie i pozostają poza tym dokumentem. Przy polu narzutu ekran pokazuje wyliczoną cenę portalu dla ceny bazowej, więc właściciel porównuje ją ze stawką portalu i sam ustala narzut (§5.1).
4. **Liczba dotknięć.** Zmiana jednego miesiąca to trzy dotknięcia, a usunięcie wpisu dwa od otwartego wpisu, więc obie czynności mieszczą się w zasadzie minimalnej liczby dotknięć. Dojście do wpisu wymaga otwarcia miesięcy i wyboru miesiąca, jak przy zmianie; usunięcie od wejścia w miesiące to cztery dotknięcia i jest świadomym odstępstwem dla rzadszej czynności. Jeden wpis dotyczy jednego miesiąca; wpis obejmujący kilka miesięcy jednym zapisem jest poza MVP (§2, §5.2). Jedno „Zapisz zmiany" zapisuje cały formularz, łącznie z otwartym wpisem (§4.1).
5. **Okno 12 miesięcy.** Ceny nie wygasają: system sam dopisuje kolejny miesiąc i wysyła go do portali, a poza wpisami obowiązuje cena bazowa. Właściciel nie musi powtarzać zapisu (§4.1).
