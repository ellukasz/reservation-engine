# 00. Przegląd produktu i założenia ogólne (Minimalne MVP — Pragmatyczny Channel Manager)

## 1. Cel produktu
Stworzenie najprostszego na rynku, mobilnego silnika rezerwacji dla małych obiektów noclegowych w Polsce (domki, apartamenty, pokoje).
Właściciel w kilka minut konfiguruje obiekt na telefonie, ustawia cenę za noc i udostępnia gościom gotowy link (na Facebooka, Instagrama, WhatsAppa lub wizytówkę Google), aby przyjmować rezerwacje bezpośrednie z zaliczką online oraz mieć **natychmiastową, dwukierunkową synchronizację w czasie rzeczywistym** z Booking.com i Airbnb (realizowaną pod spodem przez White-Label Channel Manager API).

## 2. Persony użytkowników

### Persona A: Właściciel obiektu (Gospodarz)
- **Profil:** Właściciel 1–20 jednostek noclegowych (domki, mieszkania, pokoje), ogłaszający się jednocześnie na Booking.com, Airbnb, wczasy.pl oraz w social mediach.
- **Kompetencje techniczne:** Niskie. Obsługuje wszystko na smartfonie jedną ręką, w biegu. Nie rozumie technicznych pojęć typu *rate plan*, *allotment* czy *channel mapping*.
- **Cel:** Mieć jeden kalendarz na telefonie aktualizujący się w czasie rzeczywistym, bezpiecznie dodawać rezerwacje telefoniczne i z wczasy.pl bez ryzyka podwójnych rezerwacji oraz przyjmować zaliczki online bez prowizji portali.

### Persona B: Gość (Turysta)
- **Profil:** Osoba rezerwująca nocleg ze smartfona (z linku w social mediach, Google lub wizytówki obiektu).
- **Cel:** Sprawdzić realnie wolny termin, zobaczyć od razu pełną cenę i opłacić zaliczkę BLIK-iem w 60 sekund bez zakładania konta.

## 3. Wspólny słownik statusów i źródeł rezerwacji
*(Obowiązuje we wszystkich plikach `01`–`04`)*

### Statusy rezerwacji
- **`PENDING_PAYMENT` (Oczekuje na wpłatę):** Gość przeszedł do płatności; termin jest tymczasowo zablokowany na 15 minut lokalnie oraz natychmiast zamykany w Booking.com i Airbnb.
- **`CONFIRMED` (Potwierdzona):** Zaliczka została opłacona online, właściciel dodał rezerwację ręcznie lub rezerwacja wpadła w czasie rzeczywistym z Booking.com / Airbnb.
- **`CANCELLED` (Anulowana):** Rezerwacja odwołana; termin natychmiast otwiera się lokalnie oraz na Booking.com i Airbnb.
- **`EXPIRED` (Wygasła):** Gość nie opłacił zaliczki w ciągu 15 minut; termin automatycznie się odblokowuje we wszystkich kanałach.

### Źródła rezerwacji (skąd przyszedł gość)
- **`DIRECT` (Link bezpośredni):** Rezerwacja złożona przez własny link silnika z zaliczką online.
- **`OTA_SYNC` (Synchronizacja real-time):** Rezerwacja lub zmiana odebrana w czasie rzeczywistym z Booking.com lub Airbnb przez silnik synchronizacji.
- **`MANUAL` (Ręczna / Portal ogłoszeniowy):** Termin dodany przez właściciela w 2 kliknięciach na telefonie z oznaczeniem źródła: *Telefon / Zeszyt*, *wczasy.pl*, *OLX / FB* lub *Inny portal* (natychmiast zamyka dostępność w Booking.com i Airbnb).

## 4. Zakres Minimalnego MVP vs Po MVP

### Zakres MVP (Wersja 1.0 — rdzeń produktu)
1. **Szybki start na telefonie:** Rejestracja numerem telefonu lub e-mailem i dodanie obiektu: nazwa, adres, 1–5 zdjęć, liczba jednostek.
2. **Jeden link do rezerwacji:** Gotowa strona rezerwacji pod unikalnym adresem (np. `rezerwuj.pl/nazwa-obiektu`) do wklejenia na Facebooka, Instagrama, Google Maps lub w opisie ogłoszenia (np. na wczasy.pl).
3. **Prosty cennik z narzutem na portale:** Jedna stała cena za noc dla danej jednostki (z możliwością ręcznej zmiany ceny dla wybranych dni w kalendarzu), minimalna liczba nocy oraz opcjonalny prosty przelicznik procentowy dla portali (np. +15% na Booking/Airbnb na pokrycie ich prowizji).
4. **Dwukierunkowa synchronizacja w czasie rzeczywistym:** Integracja z White-Label Channel Manager API (np. Channex.io) zapewniająca natychmiastowe przesyłanie dostępności, cen i rezerwacji z Booking.com i Airbnb w obie strony (ukryta za prostym kreatorem „Połącz konto” na telefonie).
5. **Mobilny kalendarz właściciela:** Widok kalendarza na telefonie pokazujący źródło rezerwacji (*Bezpośrednia*, *Booking*, *Airbnb*, *wczasy.pl / Telefon*) oraz przycisk dodania terminu w 2 kliknięciach (co w ciągu kilku sekund zamyka termin także na Booking i Airbnb).
6. **Rezerwacja gościa bez konta:** Wybór dat, imię, nazwisko, telefon, e-mail oraz akceptacja regulaminu i RODO.
7. **Jeden prosty model płatności:** Stały procent zaliczki (np. 30% płatne od razu BLIK-iem/kartą, reszta na miejscu u właściciela).
8. **Powiadomienia e-mail:** Automatyczny e-mail z potwierdzeniem dla gościa i powiadomieniem dla właściciela po każdej nowej rezerwacji.

### Wycięte z MVP (Świadomie odłożone na Po MVP)
- Budowa własnych, bezpośrednich certyfikacji API z Booking.com i Airbnb od zera (korzystamy z gotowego silnika White-Label API, zachowując warstwę adapterów na wypadek zmiany dostawcy w przyszłości).
- Automatyczny odczyt wiadomości e-mail z portali ogłoszeniowych typu wczasy.pl (w MVP właściciel blokuje taki termin w 2 kliknięciach na telefonie).
- Widżety i kalendarze do osadzania na zewnętrznych stronach www (w MVP tylko gotowy link).
- Ceny weekendowe, zaawansowane sezony, dopłaty za dzieci, zwierzęta oraz osobne opłaty za sprzątanie.
- Powiadomienia SMS, aplikacje w App Store / Google Play oraz fakturowanie (KSeF).


## 6. Dziennik decyzji i kompromisów
- **Decyzja 1 (White-Label Channel Manager API zamiast własnych certyfikacji i iCal):** Wybieramy pragmatyczny kompromis — natychmiastową dwukierunkową synchronizację (eliminującą ryzyko podwójnych rezerwacji przy wpisach ręcznych i z wczasy.pl) przy starcie w kilka tygodni zamiast wielomiesięcznych certyfikacji. Złożoność techniczna pośrednika jest całkowicie ukryta przed właścicielem.
- **Decyzja 2 (Prosty narzut procentowy na ceny w portalach):** Właściciele często mają wyższe ceny na Booking/Airbnb niż bezpośrednio. Jedno pole „Cena na portalach wyższa o X%” pozwala zautomatyzować wysyłkę cen bez skomplikowanych planów cenowych.
- **Decyzja 3 (Ręczne etykiety dla portali ogłoszeniowych):** Portale takie jak wczasy.pl nie mają otwartego API rezerwacyjnego. Właściciel blokuje taki termin w 2 kliknięciach, a nasz system natychmiast zamyka dostępność na Booking.com i Airbnb.
- **Preferowany bezposredni dostep do platofrm jesli nie wymagana certyfikacja**

## 7. Otwarte pytania do decyzji
- [ ] **Rozliczenie zaliczek:** Czy płatności BLIK/kartą trafiają bezpośrednio na konto operatora płatności właściciela (np. Stripe Connect / Przelewy24), czy przechodzą przez konto platformy?
- [ ] **Wysokość zaliczki:** Czy właściciel wpisuje swój procent zaliczki (np. 30%), czy przyjmujemy jedną stałą wartość dla wszystkich na start?
- [ ] **Model cenowy SaaS:** Stały abonament miesięczny (np. 59–79 zł/mies., który z zapasem pokrywa koszt ~2 zł/jednostkę u pośrednika API) czy model hybrydowy?
