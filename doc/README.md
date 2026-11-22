# System rezerwacyjny — dokumentacja główna

Jeden link, w którym gość rezerwuje nocleg na telefonie i płaci zaliczkę, oraz jeden kalendarz, w którym właściciel widzi wszystkie terminy i nie sprzedaje tego samego terminu dwa razy. Gość zawsze widzi pełną kwotę przed wpłatą.

To dokument nadrzędny produktu. Szczegóły modułów są w wymaganiach:

- **Cennik:** [`requirements/01-pricing.md`](requirements/01-pricing.md)
- **Rezerwacja i zaliczka:** [`requirements/02-reservation-and-deposit.md`](requirements/02-reservation-and-deposit.md)
- **Przegląd produktu (źródło):** [`requirements/00-overview.md`](requirements/00-overview.md)

## 1. Dla kogo

- **Właściciel:** 1–20 domków, apartamentów lub pokoi. Niskie kompetencje techniczne, obsługuje wszystko jedną ręką na smartfonie.
- **Gość:** rezerwuje ze smartfona z linku w social mediach lub wizytówce. Nie zakłada konta.

## 2. Jak gość rezerwuje

1. Otwiera link i wybiera wolny termin.
2. Widzi pełną kwotę pobytu, zaliczkę, resztę na miejscu i zasady zwrotu — zanim cokolwiek wpłaci.
3. Podaje imię, nazwisko, telefon i e-mail oraz akceptuje regulamin i RODO.
4. Płaci zaliczkę BLIK-iem lub kartą. Termin blokuje się na godzinę, także w Booking i Airbnb.
5. Po wpłacie dostaje potwierdzenie e-mail z kwotą i terminem. Brak wpłaty w ciągu godziny zwalnia termin.

Zajętego terminu nie da się zarezerwować. Jeśli wpłata dotrze po godzinie i termin jest wolny, rezerwacja zostaje potwierdzona; jeśli jest zajęty, system zwraca zaliczkę.

## 3. Jak pracuje właściciel

1. **Szybki start:** w kilka minut dodaje obiekt na telefonie (nazwa, adres, 1–5 zdjęć, liczba jednostek) i dostaje gotowy link do rezerwacji.
2. **Jeden kalendarz:** widzi wszystkie terminy ze źródłem — nasz link, Booking, Airbnb albo wpis ręczny.
3. **Wpis ręczny:** rezerwację z telefonu, zeszytu, wczasy.pl, OLX lub Facebooka zapisuje w minimalnej liczbie dotknięć; termin zamyka się także w portalach.
4. **Cennik:** ustawia ceny całego ośrodka na jednym ekranie telefonu.
5. **Synchronizacja:** rezerwacje z Booking i Airbnb pojawiają się w kalendarzu w kilka sekund; każda zmiana terminu idzie do portali.

## 4. Pięć funkcji startowych

1. **Szybki start.** Obiekt dodany na telefonie i gotowy link do rezerwacji.
2. **Jeden link.** Gość widzi dostępne terminy i pełną kwotę za pobyt przed wpłatą; zajętego terminu nie da się zarezerwować.
3. **Prosty cennik.** Spójny i zrozumiały dla nietechnicznych właścicieli.
4. **Synchronizacja i kalendarz.** Terminy z Booking i Airbnb w kilka sekund; wpis ręczny zamyka termin wszędzie; każdy termin pokazuje źródło.
5. **Rezerwacja i zaliczka.** Rezerwacja bez konta, zaliczka BLIK-iem lub kartą, reszta na miejscu, godzina na wpłatę.

## 5. Zasady bezpieczeństwa

1. **Bez podwójnych rezerwacji.** Każda zmiana terminu idzie do Booking i Airbnb w kilka sekund.
2. **Pełna kwota przed wpłatą.** Zaliczka to ustawiony procent właśnie tej kwoty.
3. **Potwierdzona rezerwacja jest nienaruszalna.** Zmiana ceny nie zmienia jej kwoty.
4. **Blokada na godzinę działa sama** i sama się zwalnia.
5. **Telefon na pierwszym miejscu.** Wszystkie czynności jedną ręką.
6. **Wpłata po czasie.** Wolny termin — rezerwacja potwierdzona; zajęty — automatyczny zwrot pieniędzy.

## 6. Moduły

### Cennik

Cztery elementy na jednym ekranie: cena za noc w środku tygodnia (`nd–czw`), cena za noc w weekend (`pt–sob`) i dwa osobne narzuty procentowe — dla Booking i dla Airbnb. Obok nich dwa ustawienia: wysokość zaliczki (10–100%, na start 30%) i minimalny czas pobytu (1–14 nocy, domyślnie 1), czyli sześć pól. Zmiana cen w wybranym miesiącu to jedna dodatkowa czynność na tym samym ekranie.

Gość z naszego linku widzi cenę pobytu bez narzutów, zaliczkę i resztę. Zaliczka i reszta sumują się dokładnie do ceny pobytu. Narzuty dotyczą wyłącznie cen wysyłanych do portali. Szczegóły: [`01-pricing.md`](requirements/01-pricing.md).

### Rezerwacja i zaliczka

Rezerwacja z naszego linku przechodzi przez stan **Oczekuje na wpłatę** (blokada 1 godzina), a po opłaceniu staje się **Potwierdzona**. Brak wpłaty w ciągu godziny oznacza **Wygasła** i zwolnienie terminu. Rezerwacje z Booking i Airbnb oraz wpisy ręczne są od razu **Potwierdzone** i zamykają termin wszędzie. Zasady zwrotu są proste, takie same dla wszystkich i widoczne przed wpłatą. Szczegóły: [`02-reservation-and-deposit.md`](requirements/02-reservation-and-deposit.md).

## 7. Słownik

- **Oczekuje na wpłatę** — termin zablokowany na 1 godzinę, także w Booking i Airbnb.
- **Potwierdzona** — zaliczka opłacona, wpis właściciela lub rezerwacja z portalu.
- **Anulowana / Wygasła** — termin wraca do sprzedaży wszędzie; zwrot zaliczki według zasad pokazanych gościowi przed wpłatą.
- **Źródła:** bezpośrednia (z naszego linku), Booking / Airbnb, ręczna (telefon, zeszyt, wczasy.pl, OLX / FB).
- **Cena pobytu** — suma cen za noce; jedna pełna kwota do zapłaty, którą gość widzi przed wpłatą.
- **Zaliczka** — ustawiony procent ceny pobytu płatny online; reszta na miejscu u właściciela.
- **Wpis ręczny** — rezerwacja zapisana przez właściciela samodzielnie.

## 8. Czego nie ma w MVP

- Konta gości, kody rabatowe, zmiana terminu przez gościa.
- Własna cena obiektu (VIP), szybka zmiana ceny z kalendarza, wpis obejmujący kilka miesięcy jednym zapisem, obniżka na ostatnią chwilę.
- Osobna zaliczka dla obiektu, sezonu albo portalu; zaliczki zależne od portalu.
- Opłaty dodatkowe (sprzątanie, zwierzęta), ceny zależne od liczby osób, rabaty za długi pobyt.
- Święta w cenniku, ręczne przedłużanie blokady terminu, płatność gotówką online.

## 9. Decyzje

- **Zaliczka:** 10–100% ceny pobytu, domyślnie 30%; dotyczy wyłącznie rezerwacji z naszego linku i jest zaokrąglana w górę. Kwota trafia na konto operatora płatności wskazane przez właściciela.
- **Synchronizacja:** gotowe połączenie z Booking i Airbnb, bez konfiguracji technicznej i własnych certyfikacji.
- **Ceny portali:** osobny narzut dla Booking i osobny dla Airbnb, bez obietnicy pokrycia prowizji.
- **Wczasy.pl:** właściciel wpisuje terminy ręcznie w minimalnej liczbie kliknięć.
- **Powiadomienia e-mail:** gość dostaje potwierdzenie z kwotą i terminem, właściciel powiadomienie o nowej rezerwacji.
- **Model opłat za system i warunki operatora płatności** są poza zakresem dokumentacji produktu.

## 10. Ustalenia przed startem

1. **Zaliczka w przeglądzie.** `00-overview.md` podaje stałe 30%, a cennik i ten dokument — 10–100%, domyślnie 30%. Przed startem trzeba poprawić przegląd, żeby dokumenty mówiły jednym głosem.
2. **Operator płatności.** Wybór operatora, konto wypłat właściciela i realizacja zwrotów muszą być gotowe przed startem.
3. **Treść e-maili.** Szablony potwierdzenia dla gościa i powiadomienia dla właściciela wymagają krótkiej akceptacji: kwota, termin, źródło, status i zasady zwrotu.
4. **Potwierdzenie cen przez portale.** Przed startem trzeba ustalić, jak system potwierdza przyjęcie cen przez Booking i Airbnb oraz co robi, gdy portal ich nie potwierdzi; interfejs pokazuje ten status właścicielowi.
5. **Reguła zwrotu.** Obecnie jeden próg: pełny zwrot przy rezygnacji najpóźniej 7 dni przed przyjazdem. Zmiana reguły wymaga decyzji przed startem.

## 11. Struktura projektu

- `doc/` — dokumentacja; ten plik jest punktem startu.
- `doc/requirements/` — wymagania biznesowe: przegląd, cennik, rezerwacja i zaliczka.
- `frontend-owner/` — mobilny panel właściciela (Flutter).
- `backend/` — backend systemu rezerwacyjnego.
