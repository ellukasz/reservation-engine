# Projekt: proste i wyraziste zasady w `AGENTS.md`

Data: 2026-11-18

## Intencja
`AGENTS.md` jest dziedziczony przez wszystkich agentów, także przez agenta projektującego interfejs. Ma być czytany jednym spojrzeniem i jednoznacznie mówić, co jest ważniejsze: bezpieczeństwo rezerwacji, prostota korzystania czy kolejne funkcje. Zmieniamy brzmienie i dodajemy dwa krótkie zdania we wstępie, nie zmieniamy sensu zasad.

## Cel
- Zachować wszystkie sześć treści: telefon, język, MVP, bezpieczeństwo rezerwacji, mniej opcji i automatyzacja, niskie kompetencje techniczne.
- Jedna reguła = jedno krótkie polecenie zaczynające się od czasownika.
- Dodać do wstępu zdanie o priorytetach i zdanie o interfejsie: bezpieczeństwo rezerwacji → proste i zrozumiałe korzystanie → dodatkowe funkcje; właściciel ani gość nie może się zgubić ani czuć przytłoczony. Agent UX dostaje wyraźną wytyczną, ale nie kosztem bezpieczeństwa.
- Zostawić sens reguły 4 w linii priorytetów; w samej regule nie powtarzać słowa „najpierw", żeby uniknąć duplikatu.
- Usunąć duplikaty: „żargon" w regule 2 i 5, „zbędne opcje" w 3 i 5, „jedną ręką" we wstępie i regule 6.
- Poprawić literówki i błędny marker „6. -".

## Poza zakresem
- Dodawanie przykładów, list kontrolnych i pytań weryfikacyjnych przy regułach.
- Wynoszenie prostoty ponad bezpieczeństwo rezerwacji.
- Osobna reguła tylko dla panelu administratora — powtarzałaby reguły 1, 3, 5 i 6.
- Przenoszenie zasad do promptów ewaluatorów i leada — `AGENTS.md` pozostaje jednym źródłem.
- Zmiana sensu którejkolwiek z sześciu zasad.

## Ograniczenia
- Plik pozostaje po polsku, bez żargonu IT.
- Nagłówek i lista sześciu reguł zostają; nowe zdania stoją przed listą, nie jako siódmy punkt.

## Podejścia
- **A (wybrane):** porządki + dwa krótkie zdania we wstępie. Agent UX dostaje wytyczną „projektuj prosto, nie gubi i nie przytłaczaj", a kolejność nie kłóci się z bezpieczeństwem. Lista zostaje sześciopunktowa.
- **B:** osobna siódma reguła „Panel administratora ma być prosty". Odrzucone — powtarza reguły 1, 3, 5 i 6 i wydłuża listę.
- **C:** pytania kontrolne przy każdej regule. Odrzucone — plik rośnie i powtarza dokumenty wymagań; priorytety nadal nie byłyby w jednym miejscu.

## Projekt zmiany — docelowa treść `AGENTS.md`

```markdown
# Kontekst projektu: Mobilny system rezerwacyjny

Silnik rezerwacji dla małych obiektów noclegowych (1–20 domków, apartamentów lub pokoi). Język projektu i dokumentacji: polski.

Priorytety: najpierw bezpieczna rezerwacja, potem proste i zrozumiałe korzystanie, dopiero potem dodatkowe funkcje. Interfejs nie może gubić użytkownika ani go przytłaczać.

## Żelazne zasady (obowiązują wszystkich agentów)

1. **Stawiaj telefon na pierwszym miejscu:** każda funkcja działa wygodnie na ekranie telefonu.
2. **Mów po prostu:** używaj *dostępnych terminów*, *cennika* i *synchronizacji z Booking*. Nie używaj *allotment*, *rate plan*, *channel manager* ani innego żargonu.
3. **Trzymaj się MVP:** odrzucaj funkcje korporacyjne i rzadkie wyjątki, jeśli wymagają więcej niż 2–3 kliknięcia.
4. **Chroń rezerwację:** nie dopuszczaj do podwójnej rezerwacji; gość zawsze widzi pełną kwotę przed wpłatą.
5. **Mniej opcji, więcej automatyzacji:** nie dodawaj zbędnych opcji hotelowych; powtarzalne zadania wykonuj w tle.
6. **Zakładaj niskie kompetencje techniczne:** właściciel i gość obsługują wszystko na smartfonie jedną ręką, bez wiedzy technicznej.
```

## Pozostawione wykonawcy
Brak. Zmiana polega wyłącznie na podmianie treści tego jednego pliku.
