# Wymagania biznesowe: Rezerwacja i zaliczka

> Dokument nadrzędny: `00-overview.md`. Ten dokument opisuje przebieg rezerwacji i zaliczki: stany rezerwacji, blokadę terminu, płatność, potwierdzenie, wygaśnięcie, anulowanie, zwrot i zamykanie terminów w portalach. Jak liczy się cena pobytu, zaliczka, reszta, narzut i minimalny czas pobytu opisuje `01-pricing.md`.

## 1. Cel modułu

Gość z naszego linku rezerwuje nocleg na telefonie, widzi pełną kwotę przed wpłatą i płaci zaliczkę bez zakładania konta. Właściciel widzi każdą rezerwację w kalendarzu, a ten sam termin nie może być sprzedany dwa razy.

## 2. Pojęcia

- **Gość z naszego linku** — gość rezerwujący bezpośrednio u właściciela przez link do rezerwacji.
- **Wpis ręczny** — rezerwacja zapisana przez właściciela samodzielnie (telefon, zeszyt, wczasy.pl, OLX, Facebook).
- **Oczekuje na wpłatę** — termin zablokowany po rozpoczęciu rezerwacji z naszego linku; blokada trwa 1 godzinę i obowiązuje także w Booking i Airbnb.
- **Potwierdzona** — rezerwacja opłacona, wpisana ręcznie przez właściciela albo przyjęta z Booking lub Airbnb.
- **Anulowana / Wygasła** — rezerwacja zakończona bez utrzymania terminu; termin wraca do sprzedaży w naszym linku, Booking i Airbnb.
- **Zaliczka** — część ceny pobytu płatna online przy rezerwacji z naszego linku. Wysokość i wyliczenie opisuje `01-pricing.md`.
- **Reszta** — część ceny pobytu pozostająca do zapłaty poza systemem, zgodnie z ustaleniami właściciela. Wyliczenie opisuje `01-pricing.md`.

## 3. Zakres MVP

- **KRYTYCZNE (bez tego nie startujemy):** rezerwacja z naszego linku bez konta, pełna kwota przed wpłatą, płatność zaliczki BLIK-iem lub kartą, blokada terminu na 1 godzinę, automatyczne potwierdzenie lub zwolnienie terminu, brak podwójnych rezerwacji, synchronizacja zmian terminu z Booking i Airbnb w kilka sekund.
- **W MVP:** wpis ręczny zamykający termin także w portalach, potwierdzenie dla gościa i powiadomienie dla właściciela po udanej rezerwacji.
- **POZA MVP:** konta gości, kody rabatowe, płatność pełnej kwoty online jako osobny tryb poza ustawieniem zaliczki, zmiana terminu przez gościa, wiele zasad zwrotu zależnych od sezonu lub obiektu.
- **WYCIĘTE:** płatność gotówką online, zaliczki zależne od portalu, ręczne przedłużanie blokady terminu.

## 4. Przebieg rezerwacji z naszego linku

### 4.1. Dane i zgody

Jako gość chcę zarezerwować nocleg bez zakładania konta, aby szybko dokończyć rezerwację na telefonie.

- Gość wybiera termin i widzi pełną kwotę do zapłaty przed wpłatą: cenę pobytu, zaliczkę i resztę na miejscu.
- Gość podaje imię, nazwisko, telefon i e-mail.
- Gość akceptuje regulamin i RODO przed przejściem do płatności.
- Przed wpłatą gość widzi też krótkie zasady zwrotu zaliczki.

**Kryteria akceptacji:**

- **Jeśli** gość wybrał wolny termin, **gdy** przechodzi do podsumowania, **to** widzi pełną kwotę, zaliczkę, resztę i zasady zwrotu przed jakąkolwiek wpłatą.
- **Jeśli** brakuje wymaganych danych albo zgód, **gdy** gość próbuje przejść do płatności, **to** system nie rozpoczyna płatności i pokazuje, co trzeba uzupełnić.

### 4.2. Blokada terminu i płatność

- Po rozpoczęciu płatności termin dostaje stan **Oczekuje na wpłatę** i jest blokowany na 1 godzinę.
- Blokada działa także w Booking i Airbnb w kilka sekund.
- Gość płaci zaliczkę BLIK-iem lub kartą.
- Kwota zapamiętana przy utworzeniu rezerwacji nie zmienia się w czasie oczekiwania na wpłatę, nawet jeśli właściciel zmieni cennik.

**Kryteria akceptacji:**

- **Jeśli** gość rozpocznie płatność, **gdy** termin jest wolny, **to** termin od razu staje się niedostępny dla innych gości w naszym linku i w portalach.
- **Jeśli** wpłata zakończy się w ciągu godziny, **gdy** termin nadal jest zarezerwowany dla tej rezerwacji, **to** rezerwacja staje się **Potwierdzona**.

### 4.3. Po upływie godziny

- Brak wpłaty w ciągu godziny zmienia rezerwację na **Wygasła** i zwalnia termin wszędzie.
- Jeśli wpłata dotrze po upływie godziny, a termin jest nadal wolny, system potwierdza rezerwację.
- Jeśli wpłata dotrze po upływie godziny, a termin jest już zajęty, system nie tworzy podwójnej rezerwacji i automatycznie zwraca zaliczkę.

**Kryteria akceptacji:**

- **Jeśli** godzina minie bez wpłaty, **gdy** system sprawdzi status rezerwacji, **to** termin wraca do sprzedaży w naszym linku, Booking i Airbnb.
- **Jeśli** wpłata przyjdzie po czasie i termin jest zajęty, **gdy** system przetworzy płatność, **to** gość nie dostaje rezerwacji, a zaliczka wraca automatycznie.

## 5. Potwierdzenie, anulowanie i zwrot

### 5.1. Potwierdzenie

- Po udanej wpłacie rezerwacja od razu jest **Potwierdzona**.
- Gość dostaje potwierdzenie e-mail z kwotą, terminem i statusem płatności.
- Właściciel dostaje powiadomienie e-mail o nowej rezerwacji.

### 5.2. Anulowanie i zwrot zaliczki

Zasady zwrotu są proste, takie same dla wszystkich rezerwacji z naszego linku i widoczne przed wpłatą:

- **Pełny zwrot zaliczki:** gdy właściciel odwoła rezerwację, gdy termin jest już zajęty w chwili przetwarzania wpłaty po czasie albo gdy gość zrezygnuje najpóźniej 7 dni przed przyjazdem.
- **Brak zwrotu zaliczki:** gdy gość zrezygnuje później niż 7 dni przed przyjazdem.
- **Reszta:** nie jest pobierana online, więc system jej nie zwraca.

Po anulowaniu lub wygaśnięciu termin wraca do sprzedaży w naszym linku, Booking i Airbnb w kilka sekund.

**Kryteria akceptacji:**

- **Jeśli** gość zrezygnuje 7 dni lub wcześniej przed przyjazdem, **gdy** anulowanie zostanie przyjęte, **to** rezerwacja zmienia stan na **Anulowana**, a zaliczka jest zwracana w całości.
- **Jeśli** gość zrezygnuje mniej niż 7 dni przed przyjazdem, **gdy** anulowanie zostanie przyjęte, **to** rezerwacja zmienia stan na **Anulowana**, a zaliczka zostaje u właściciela.
- **Jeśli** właściciel odwoła potwierdzoną rezerwację, **gdy** zapisze anulowanie, **to** gość dostaje pełny zwrot zaliczki, a termin wraca do sprzedaży.

## 6. Rezerwacje z portali i wpisy ręczne

- **Booking lub Airbnb:** rezerwacja z portalu zamyka termin od razu i ma stan **Potwierdzona**. Portal pobiera płatność według własnych zasad; nasz system nie pobiera zaliczki z naszego linku.
- **Wpis ręczny:** właściciel zapisuje rezerwację sam. Wpis ręczny zamyka termin w naszym linku, Booking i Airbnb w kilka sekund i ma stan **Potwierdzona**.
- Każdy termin w kalendarzu pokazuje źródło: nasz link, Booking, Airbnb albo wpis ręczny.

**Kryteria akceptacji:**

- **Jeśli** właściciel zapisze wpis ręczny na wolny termin, **gdy** dotknie zapisu, **to** termin staje się niedostępny w naszym linku i w portalach w kilka sekund.
- **Jeśli** przyjdzie rezerwacja z Booking lub Airbnb, **gdy** system ją odbierze, **to** termin jest od razu zamknięty w kalendarzu jako **Potwierdzona** z właściwym źródłem.

## 7. Przypadki brzegowe

1. **Podwójna rezerwacja.** Ten sam termin nie może zostać potwierdzony dwa razy. Pierwsza skuteczna rezerwacja lub blokada wygrywa, a późniejsza próba nie przechodzi do potwierdzenia.
2. **Wpłata po czasie.** Termin wolny: potwierdzamy. Termin zajęty: automatyczny zwrot zaliczki, bez rezerwacji.
3. **Zmiana cennika w trakcie oczekiwania.** Nie zmienia ceny pobytu, zaliczki ani reszty zapisanych w rezerwacji oczekującej na wpłatę.
4. **Anulowanie potwierdzonej rezerwacji.** Termin wraca do sprzedaży wszędzie, a zasady zwrotu są zawsze takie same jak pokazane przed wpłatą.
5. **Brak internetu lub błąd synchronizacji.** System nie może pokazać terminu jako wolnego, jeśli nie ma pewności, że jest wolny także w portalach; w razie wątpliwości blokuje sprzedaż terminu i pokazuje prosty komunikat.

## 8. Ustalenia przed startem

1. **Wysokość zaliczki.** `01-pricing.md` przewiduje zaliczkę 10–100%, domyślnie 30%, a `00-overview.md` mówi o stałych 30%. Przed startem trzeba wybrać jedną zasadę i ujednolicić dokumenty.
2. **Operator płatności.** Wybór operatora, konto wypłat właściciela i sposób realizacji zwrotów technicznych są poza tym dokumentem, ale muszą być gotowe przed startem.
3. **Treść potwierdzeń.** Szablony e-mail dla gościa i właściciela wymagają krótkiej akceptacji przed startem: kwota, termin, źródło, status i zasady zwrotu.
4. **Reguły odwołania.** Obecnie przyjęto jeden prosty próg 7 dni. Jeśli właściciel chce innej reguły, trzeba zmienić ją przed startem w jednym miejscu i pokazać gościowi przed wpłatą.
