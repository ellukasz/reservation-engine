# Kontekst projektu: Mobilny panel właściciela do zarządzania obiektami w systemie rezerwacyjnym

Tworzysz interfejs mobilny (Flutter) przeznaczony dla właścicieli obiektów noclegowych do zarządzania nieruchomościami oraz rezerwacjami.

## Priorytety produktu i UX
- **Użytkownik docelowy:** Właściciel obiektów zarządzający operacjami w ruchu (często jedną ręką, w jasnym świetle lub w pośpiechu między zadaniami).
- **Czytelność i gęstość informacji:** Interfejs ma być przejrzysty, łatwy do szybkiego przeskanowania wzrokiem i nastawiony na działanie. Priorytet mają kluczowe dane (obłożenie, dzisiejsze przyjazdy/wyjazdy) oraz szybkie akcje, a nie elementy dekoracyjne.
- **Spójność statusów:** Statusy rezerwacji i obiektów muszą wykorzystywać identyczne, semantyczne oznaczenia kolorystyczne (badge) w całej aplikacji.
- **Język interfejsu:** Wszystkie teksty widoczne dla użytkownika, etykiety, komunikaty błędów i placeholdery muszą być napisane poprawną **polszczyzną**.

## Internacjonalizacja (i18n / l10n) i formatowanie danych
- **Zakaz wpisywania tekstów na sztywno:** NIGDY nie umieszczaj surowych ciągów znaków widocznych dla użytkownika (np. `Text('Rezerwacje')`) bezpośrednio w kodzie UI.
- **Elastyczność układu na długie tłumaczenia:** Projektuj przyciski, chipy i nagłówki zakładek tak, aby nie uległy przepełnieniu (`overflow`), gdy tekst w innym języku (np. niemieckim lub angielskim) będzie o 30% dłuższy niż w języku polskim.
