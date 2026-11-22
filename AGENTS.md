# Kontekst projektu: Mobilny system rezerwacyjny

Silnik rezerwacji dla małych obiektów noclegowych (1–20 domków, apartamentów lub pokoi). Język projektu i dokumentacji: polski.

Priorytety: najpierw bezpieczna rezerwacja, potem proste i zrozumiałe korzystanie, dopiero potem dodatkowe funkcje. Interfejs nie może gubić użytkownika ani go przytłaczać.

## Żelazne zasady (obowiązują wszystkich agentów)

1. **Stawiaj telefon na pierwszym miejscu:** każda funkcja działa wygodnie na ekranie telefonu.
2. **Zakładaj niskie kompetencje techniczne:** właściciel i gość obsługują wszystko na smartfonie jedną ręką, bez wiedzy technicznej.
3. **Mów po prostu:** używaj *dostępnych terminów*, *cennika* i *synchronizacji z Booking*. Nie używaj *allotment*, *rate plan*, *channel manager* ani innego żargonu.
4. **Trzymaj się MVP:** odrzucaj funkcje korporacyjne i rzadkie wyjątki, jeśli wymagają więcej niż 2–3 kliknięcia.
5. **Chroń rezerwację:** nie dopuszczaj do podwójnej rezerwacji; gość zawsze widzi pełną kwotę przed wpłatą.
6. **Mniej opcji, więcej automatyzacji:** nie dodawaj zbędnych opcji hotelowych; powtarzalne zadania wykonuj w tle.

## Struktura projektu
Projekt monorepo.
**./doc** - dokumentacja
**./doc/requirements** - wymagania biznesowe
**./frontend-owner**  - Mobilny panel właściciela do zarządzania obiektami w systemie rezerwacyjnym. Technologia flutter
**./backend** 