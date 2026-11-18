# Wymagania biznesowe: Moduł Zarządzania Cennikiem

## 1. Cel modułu
Umożliwienie nietechnicznemu właścicielowi skonfigurowania cen całego ośrodka (w tym droższych obiektów VIP) w mniej niż 2 minuty na smartfonie oraz dokonywania szybkich korekt cen bezpośrednio z grafiku — bez skomplikowanych tabel, planów cenowych i ryzyka sprzedaży poniżej kosztów.

## 2. Priorytety funkcji (Zakres MVP)
- **KRYTYCZNE (Bez tego nie startujemy):** Stawki bazowe ośrodka (`nd–czw` oraz `pt–sob`), podłoga bezpieczeństwa w PLN, narzut procentowy na portale OTA (`+%`).
- **WAŻNE (Kluczowe dla wygody i marży):** Obiekty VIP z dziedziczeniem ceny, szybka edycja ceny z grafiku (suwak `%` i przyciski), blokady minimalnego pobytu (`Min-Stay`), prosty przełącznik Last Minute (`48 h`).
- **WYCIĘTE Z MVP (Po MVP):** Łatanie dziur (*Gap-Night*), rabaty za długość pobytu (*LOS 7+*), ceny zależne od liczby osób, opłaty dodatkowe (sprzątanie, zwierzęta), kody rabatowe.

## 3. Hierarchia wyliczania ceny (Kolejność reguł)
Dla każdej pojedynczej nocy kalendarzowej system wylicza cenę według ścisłej kolejności (od bazy do limitu):

1. **Stawka bazowa ośrodka:** Cena dla **środka tygodnia (`nd–czw`)** lub **weekendu (`pt–sob`)**.
2. **Modyfikator obiektu VIP (jeśli włączony):**
   - *Tryb dopłaty:* `Stawka bazowa + stała dopłata w PLN` (np. `+150 zł/doba`).
   - *Tryb własny:* Niezależna stała kwota w PLN przypisana do domku VIP (np. `650 zł/doba`).
3. **Korekta ręczna z grafiku (jeśli ustawiona):** Nadpisanie ceny na wybrany termin za pomocą suwaka `%` lub gotowego przycisku promocji/podwyżki.
4. **Reguła Last Minute (jeśli włączona i brak ręcznej korekty):** Automatyczny rabat `%` dla wolnych terminów na `48 h` przed datą zameldowania.
5. **Podłoga bezpieczeństwa (Price Floor w PLN):** Jeśli cena po obniżkach spadnie poniżej minimum, system podnosi ją do poziomu podłogi.
6. **Narzut na portale OTA (`+%`):** Doliczany wyłącznie przy wysyłce ceny do Booking.com i Airbnb (zaokrąglenie matematyczne do pełnych złotych). Gość rezerwujący bezpośrednio (`DIRECT`) płaci cenę z kroku 5.

## 4. Wymagania funkcjonalne

### F-1: Ustawienia globalne cennika (Baza ośrodka) — [KRYTYCZNE]
Właściciel na jednym ekranie w telefonie konfiguruje parametry wspólne dla wszystkich obiektów:
- **Stawka bazowa: Środek tygodnia (`nd–czw`)** — kwota w PLN.
- **Stawka bazowa: Weekend (`pt–sob`)** — kwota w PLN.
- **Podłoga bezpieczeństwa (Cena minimalna)** — kwota w PLN, poniżej której nie zejdzie żaden rabat ani suwak.
- **Narzut na portale OTA (`+%`)** — wartość procentowa (np. `16%`), o którą system automatycznie powiększa ceny wysyłane do Booking.com i Airbnb.

**Kryteria akceptacji:**
- Po zapisaniu zmian system przelicza ceny na `12 miesięcy` do przodu i w ciągu kilku sekund wysyła zaktualizowane stawki do połączonych portali.
- Cena bazowa nie może być niższa niż podłoga bezpieczeństwa.

### F-2: Obiekty droższe (VIP / Premium) z dziedziczeniem — [WAŻNE]
Podczas dodawania lub edycji pojedynczego domku/pokoju właściciel może włączyć przełącznik **„Własna cena (Obiekt VIP)”**:
- **Wariant A (Dopłata kwotowa):** Właściciel wpisuje różnicę w PLN (np. `+150 zł`). Domek zachowuje podział na dni robocze i weekendy oraz automatycznie przesuwa swoje ceny przy każdej zmianie stawek głównych ośrodka.
- **Wariant B (Własna kwota stała):** Właściciel wpisuje niezależną cenę za noc (np. `700 zł`).
- Włączenie trybu VIP automatycznie wyświetla odznakę **VIP** na stronie rezerwacji dla gościa.

**Kryteria akceptacji:**
- Dla obiektu VIP z dopłatą `+150 zł` podłoga bezpieczeństwa automatycznie wynosi `Podłoga ośrodka + 150 zł` (z możliwością ręcznej zmiany przez właściciela).

### F-3: Szybka zmiana ceny bezpośrednio z grafiku (Mobile-First) — [WAŻNE]
Kliknięcie dowolnego dnia lub zaznaczenie zakresu dni na kalendarzu domku otwiera dolny panel (*bottom sheet*) obsługiwalny kciukiem:
- **Suwak procentowy** w zakresie od `-40%` do `+50%` z podglądem nowej kwoty w PLN na żywo.
- **Przyciski szybkiego wyboru:** `Promocja -20%`, `Promocja -10%`, `Podwyżka +20%`, `Przywróć cenę z bazy`.

**Kryteria akceptacji:**
- Zatwierdzenie zmiany jednym przyciskiem „Zapisz” natychmiast aktualizuje cenę na stronie rezerwacji oraz wysyła nową stawkę (z narzutem OTA) do Booking.com i Airbnb.
- Próba obniżenia ceny suwakiem poniżej podłogi bezpieczeństwa zatrzymuje suwak na kwocie minimalnej i wyświetla komunikat: *„Osiągnięto cenę minimalną”*.

### F-4: Blokady minimalnej długości pobytu (`Min-Stay`) — [WAŻNE]
- Właściciel ustawia domyślne minimum nocy dla ośrodka (np. `1` lub `2 noce`).
- Z poziomu kalendarza może zaznaczyć wybrany okres (np. Majówka, wakacje, Sylwester) i wymusić dłuższą minimalną długość pobytu (od `1` do `14 nocy`).

**Kryteria akceptacji:**
- Gość wybierający termin obejmujący choćby jeden dzień z wyższym wymogiem `Min-Stay` musi zarezerwować co najmniej wymaganą liczbę nocy.
- Restrykcja `Min-Stay` jest wysyłana przez API do Booking.com i Airbnb.

### F-5: Prosty automat Last Minute — [WAŻNE]
- Jeden przełącznik w ustawieniach cennika: *„Obniż cenę wolnych terminów o `X%` (np. `15%`) na `48 godzin` przed przyjazdem”*.
- Automat działa w tle codziennie i aktualizuje ceny zarówno na stronie bezpośredniej, jak i na portalach OTA.

## 5. Przypadki brzegowe i reguły bezpieczeństwa
1. **Nienaruszalność istniejących rezerwacji:** Żadna zmiana cen globalnych, suwaka na grafiku ani reguły Last Minute nigdy nie zmienia kwoty w już potwierdzonych (`CONFIRMED`) ani oczekujących na płatność (`PENDING_PAYMENT`) rezerwacjach.
2. **Pobyt na przełomie różnych stawek:** Jeśli pobyt obejmuje czwartek (`350 zł`) oraz piątek (`450 zł`), system sumuje ceny poszczególnych nocy (`350 + 450 = 800 zł`) i prezentuje gościowi pełną kwotę za cały pobyt.
3. **Brak możliwości ustawienia ceny 0 zł:** System blokuje zapisanie zerowej lub ujemnej kwoty w każdym polu cenowym.
 