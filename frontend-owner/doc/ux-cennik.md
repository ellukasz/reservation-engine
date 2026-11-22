# Dokumentacja UX: Cennik — panel właściciela (Flutter)

- **Data:** 2026-11-22
- **Status:** zaakceptowany (2026-11-22)
- **Zakres:** wyłącznie moduł cennika w `frontend-owner`; backend, rezerwacje, płatności i synchronizacja są poza zakresem tego dokumentu.
- **Źródła:** `doc/README.md`, `doc/requirements/01-pricing.md` (wersja po zmianie: dwa osobne narzuty, kafelki miesięcy z cenami i minimum, przewijanie dozwolone).

## 1. Cel i kontekst

Właściciel małego obiektu (1–20 jednostek) ustawia cały cennik na telefonie, jedną ręką, bez wiedzy technicznej. Ma zobaczyć skutek swojej decyzji od razu: ile zapłaci gość z naszego linku, ile zobaczy gość Booking, ile gość Airbnb. Nie może przypadkiem zapisać ceny, która zepsuje rezerwację.

Ten dokument opisuje wygląd i zachowanie ekranu cennika oraz sposób jego wykonania we Flutterze. Nie opisuje API, bazy danych ani synchronizacji z portalami — jedynie miejsca, w których interfejs musi pokazać ich stan.

## 2. Zasady projektowe

1. **Telefon i jedna ręka.** Wszystkie akcje w zasięgu kciuka; główny przycisk na dole.
2. **Czytelność w jasnym świetle.** Tekst podstawowy 16 sp, etykiety 14 sp, minimalny cel dotykowy 48 × 48 dp, kontrast tekstu co najmniej 4,5:1, elementów UI i fokusu co najmniej 3:1.
3. **Niskie kompetencje techniczne.** Proste polskie etykiety, żadnych skrótów technicznych. `nd–czw` i `pt–sob` są dopiskiem, nie główną nazwą.
4. **Mniej wpisywania, mniej błędów.** Jednostki (`zł`, `%`, `noc`) są przy wartości, nie wpisywane ręcznie. Minimum nocy ustawia się przyciskami `−` / `+`.
5. **Widoczna konsekwencja.** Przy każdym narzucie widać wyliczoną cenę portalu. Przy zaliczce widać przykład podziału kwoty.
6. **Bezpieczny zapis.** Błąd przy polu, zachowana wartość, potwierdzenie usunięcia wpisu, ostrzeżenie przy wyjściu z niezapisanymi zmianami.
7. **Jedna strona, rozwijana w miejscu.** Miesiące i edycja wpisu rozwijają się na tym samym ekranie; nie ma drugiego ekranu ani listy prowadzącej do osobnej strony.
8. **i18n od początku.** Żadnych tekstów na sztywno; układ odporny na tekst o 30% dłuższy.

## 3. Wybrana koncepcja i odrzucone warianty

**Wybrano: A — jedna kolumna, pola pełnej szerokości.** Najlepiej znosi dłuższe tłumaczenia, zostawia miejsce na komunikaty błędów i mieści sześć pól bez zagęszczania.

| Wariant | Opis | Decyzja |
|---|---|---|
| **A. Jedna kolumna** | Sześć pól jedno pod drugim, sekcje oddzielone odstępem. | **Wybrany.** Najczytelniejszy i odporny na i18n. |
| B. Dwie grupy z nagłówkami | „Ceny za noc" i „Ustawienia rezerwacji" jako wyraźne bloki. | Odrzucony: wydłuża ekran i zwiększa przewijanie bez zysku dla sześciu pól. |
| C. Pary pól obok siebie | Dwie kolumny dla cen, narzutów i ustawień. | Odrzucony: wąskie pola, skrócone etykiety, ryzyko przepełnienia i słabsza czytelność błędów. |
| D. Kreator krok po kroku | Osobne kroki dla cen, portali i rezerwacji. | Odrzucony: kilka ekranów, więcej dotknięć, sprzeczny z zasadą jednego ekranu. |

## 4. Architektura informacji i przepływ

```
Cennik (jeden ekran)
├── sekcja: Ceny za noc            (2 pola)
├── sekcja: Ceny w portalach       (2 pola + wyliczone ceny)
├── sekcja: Rezerwacja             (zaliczka + stepper nocy)
├── przycisk: Zmień ceny w miesiącach
│   └── rozwinięcie w miejscu
│       ├── siatka 12 miesięcy z cenami i minimum
│       └── edytor jednego wpisu (po dotknięciu kafelka)
└── pasek: Zapisz zmiany (przyklejony do dołu; zapisuje cały formularz, łącznie z otwartym wpisem)
```

- Powrót z niezapisanymi zmianami: dialog „Masz niezapisane zmiany. Odrzucić?" z akcjami **Zostań** / **Odrzuć**.
- Po zapisie: komunikat sukcesu i status wysyłki do portali.
- Brak drugiego ekranu i brak nawigacji do osobnej strony miesięcy.

## 5. Ekran główny

### 5.1. Układ

```
┌──────────────────────────────┐
│ ‹  Cennik                    │
│    Cały ośrodek              │
│                              │
│ CENY ZA NOC                  │
│ Noc w tygodniu (nd–czw)      │
│ ┌──────────────────────────┐ │
│ │ 350                    zł│ │
│ └──────────────────────────┘ │
│ Noc w weekend (pt–sob)       │
│ ┌──────────────────────────┐ │
│ │ 450                    zł│ │
│ └──────────────────────────┘ │
│                              │
│ CENY W PORTALACH             │
│ Booking — podwyższ cenę o    │
│ ┌──────────────────────────┐ │
│ │ 16                     % │ │
│ └──────────────────────────┘ │
│ Noc 450 zł pokaże się       │
│ w Booking jako 522 zł       │
│                              │
│ Airbnb — podwyższ cenę o     │
│ ┌──────────────────────────┐ │
│ │ 10                     % │ │
│ └──────────────────────────┘ │
│ Noc 450 zł pokaże się       │
│ w Airbnb jako 495 zł        │
│                              │
│ REZERWACJA                   │
│ Zaliczka                     │
│ ┌──────────────────────────┐ │
│ │ 30                     % │ │
│ └──────────────────────────┘ │
│ Tylko rezerwacje z naszego   │
│ linku. Przy 1 000 zł:        │
│ 300 zł online, 700 zł        │
│ na miejscu.                  │
│                              │
│ Minimalny pobyt              │
│ [ − ]    1    [ + ]     noc  │
│                              │
│ Zmień ceny w miesiącach →    │
│                              │
│ ┌──────────────────────────┐ │
│ │      Zapisz zmiany       │ │
│ └──────────────────────────┘ │
└──────────────────────────────┘
```

- Na mniejszych telefonach treść się przewija; pasek „Zapisz zmiany" pozostaje przyklejony do dołu nad bezpiecznym marginesem.
- Sekcje oddziela odstęp i etykieta małymi literami; bez ramek i tabel.

### 5.2. Pola i zachowanie

| Pole | Etykieta | Jednostka | Wprowadzanie |
|---|---|---|---|
| 1 | Noc w tygodniu (nd–czw) | zł | klawiatura numeryczna, tylko cyfry, pełne złote |
| 2 | Noc w weekend (pt–sob) | zł | jw. |
| 3 | Booking — podwyższ cenę o | % | klawiatura numeryczna, 0–100 |
| 4 | Airbnb — podwyższ cenę o | % | klawiatura numeryczna, 0–100 |
| 5 | Zaliczka | % | klawiatura numeryczna, 10–100 |
| 6 | Minimalny pobyt | noc | stepper `−` / `+`, zakres 1–14 |

- Jednostka jest wyrównana do prawej wewnątrz pola, wartość do lewej; przy fokusie pole dostaje wyraźną obwódkę.
- Wartości liczbowe formatujemy z separatorem tysięcy: `1 200 zł`.
- Pod polem narzutu pojawia się wyliczona cena portalu dla ceny bazowej (`450 zł + 16% = 522 zł`), zgodnie z `01-pricing.md` §5.1.
- Stepper nocy nie otwiera klawiatury; przytrzymanie `+`/`−` nie przyspiesza zmiany (świadomie, żeby uniknąć przeskoku).
- Przy narzucie 0% podpis mówi „Cena w portalu bez zmian"; przy zaliczce 100% — „Gość płaci całość online".
- Cena maksymalna to 99 999 zł; dłuższa liczba jest blokowana już w polu.
- Kolejność fokusu: od góry do dołu, na końcu „Zapisz zmiany".

### 5.3. Przycisk zapisu

| Stan | Wygląd | Zachowanie |
|---|---|---|
| Bez zmian | wyszarzony, nieaktywny | nic nie robi |
| Zmiany niezapisane | pełny niebieski | zapisuje |
| Zapisywanie | spinner + „Zapisuję…" | zablokowany |
| Zapisano | krótko „Zapisano ✓" | wraca do stanu bez zmian |

- Jedno „Zapisz zmiany" zapisuje **cały formularz**: ceny bazowe, oba narzuty, zaliczkę, minimum oraz otwarty wpis miesiąca. Nie ma drugiego przycisku zapisu.
- Przycisk jest zawsze widoczny na dole (sticky), także przy przewijaniu.
- Po zapisie pod przyciskiem pojawia się „Ostatnio zapisano dziś o 9:38.".

## 6. Walidacja

Zasady: sprawdzaj po opuszczeniu pola i przy próbie zapisu; nie kasuj wpisanej wartości; pokaż błąd pod polem; przy zapisie przenieś fokus do pierwszego błędu.

| Pole | Zasada | Komunikat |
|---|---|---|
| Cena nd–czw / pt–sob | liczba całkowita > 0 | „Cena musi być większa od zera." |
| Cena nd–czw / pt–sob | bez groszy | „Podaj pełne złote, bez groszy." |
| Cena nd–czw / pt–sob | maks. 99 999 zł | „Cena może wynosić najwyżej 99 999 zł." |
| Narzut Booking / Airbnb | 0–100 | „Podaj wartość od 0 do 100%." |
| Zaliczka | 10–100 | „Zaliczka od 10 do 100%." |
| Minimalny pobyt | 1–14 | „Minimum od 1 do 14 nocy." |
| Pole puste | wymagane | „Wpisz wartość." |

- Błąd ma ikonę i tekst (nie tylko kolor).
- Przyciski `−` / `+` blokują się na granicach zakresu; wartość nigdy nie wychodzi poza 1–14.
- Zero w narzucie jest poprawne i oznacza „nie podwyższamy ceny w portalu".

## 7. Zapis i synchronizacja z portalami

| Stan | Co widzi właściciel |
|---|---|
| Wczytywanie cennika | pola i „Zapisz zmiany" zablokowane; delikatny wskaźnik ładowania |
| Błąd wczytania | „Nie udało się wczytać cennika." + „Spróbuj ponownie"; zapis zablokowany |
| Zapis lokalny w toku | „Zapisuję…" na przycisku |
| Zapisany, wysyłka w toku | zielony pasek „Zapisano. Wysyłamy ceny do portali." + wiersze statusu |
| Booking potwierdził | „Booking — potwierdzone ✓" |
| Airbnb czeka | „Airbnb — czeka na potwierdzenie…" |
| Portalu nie potwierdził | pomarańczowy pasek „Airbnb nie potwierdził cen. Spróbujemy ponownie automatycznie." + przycisk „Spróbuj teraz" |
| Ponowienie | „Spróbuj teraz" wysyła **tylko portal, który nie potwierdził** |
| Powrót do aplikacji | status portali odtworzony z zapisu; nieudany nadal widoczny |
| Brak internetu | „Brak internetu. Nie możemy teraz wysłać cen do portali." |
| Błąd zapisu | „Nie udało się zapisać. Spróbuj ponownie." + „Spróbuj ponownie" |

- Komunikat o błędzie portalu nie blokuje edycji cennika.
- Sukces wysyłki nie chowa się od razu; pozostaje czytelny co najmniej do następnej zmiany.

## 8. Miesiące

### 8.1. Widok po dotknięciu „Zmień ceny w miesiącach"

```
┌──────────────────────────────┐
│ ‹  Cennik                    │
│    Ceny w miesiącach         │
│    dotyczą każdego roku      │
│                              │
│ Legenda            Rozwiń ▼ │
│ Po rozwinięciu:              │
│ tydzień (nd–czw)             │
│ Noce od niedzieli do         │
│ czwartku.                    │
│ weekend (pt–sob)             │
│ Noce z piątku na sobotę i    │
│ z soboty na niedzielę.       │
│ ─────────────────            │
│ ■ Własna cena — tylko dla    │
│   tego miesiąca.             │
│ □ Wspólna — gdy miesiąc nie  │
│   ma własnej ceny.           │
│                              │
│ ┌────────────┐ ┌────────────┐│
│ │ Lipiec     │ │ Sierpień   ││
│ │ Własna     │ │ Własna     ││
│ │ tydzień:   │ │ tydzień:   ││
│ │ 450 zł     │ │ 480 zł     ││
│ │ weekend:   │ │ weekend:   ││
│ │ 550 zł     │ │ 600 zł     ││
│ │ min. 2 noce│ │ min. 3 noce││
│ │ Zmień      │ │ Zmień      ││
│ └────────────┘ └────────────┘│
│ ┌────────────┐ ┌────────────┐│
│ │ Październik│ │ Grudzień   ││
│ │ Wspólna    │ │ Wspólna    ││
│ │ tydzień:   │ │ tydzień:   ││
│ │ 350 zł     │ │ 350 zł     ││
│ │ weekend:   │ │ weekend:   ││
│ │ 450 zł     │ │ 450 zł     ││
│ │ min. 1 noc │ │ min. 1 noc ││
│ │ Ustaw      │ │ Ustaw      ││
│ └────────────┘ └────────────┘│
└──────────────────────────────┘
```

- Siatka 2 kolumny (normalnie) lub 1 kolumna, gdy skala tekstu przekracza ok. 130% albo szerokość ekranu spada poniżej 340 dp. Kafelki mają co najmniej 48 dp.
- Kafelek pokazuje pełną nazwę miesiąca, plakietkę „Własna" albo „Wspólna", obie ceny w osobnych blokach — etykieta `tydzień:` / `weekend:` w jednej linii, kwota w następnej —, minimum nocy i akcję „Zmień" albo „Ustaw".
- Kolejność kalendarzowa (styczeń–grudzień); kafelek rośnie z treścią, bez sztywnej wysokości i bez ucinania tekstu.
- Gdy nie ma wpisów: komunikat „Nie masz jeszcze własnych cen na miesiące. Wszędzie obowiązuje cena wspólna." i wszystkie kafelki jako „Wspólna" z akcją „Ustaw".
- Legenda u góry ma nagłówek „Legenda", dwie definicje w osobnych wierszach („tydzień (nd–czw): noce od niedzieli do czwartku", „weekend (pt–sob): noce z piątku na sobotę i z soboty na niedzielę") oraz separator i dwa objaśnienia kolorów („Własna cena — ustawiona tylko dla tego miesiąca", „Wspólna — obowiązuje, gdy miesiąc nie ma własnej ceny"). Jest **domyślnie zwinięta**; nagłówek ma akcję „Rozwiń ▼", a po rozwinięciu „Zwiń ▲". Stan nie jest zapamiętywany między wejściami — po ponownym wejściu legenda jest zwinięta.
- Nagłówek „dotyczy każdego roku" jest zawsze widoczny w widoku miesięcy.
- Widok miesięcy zamyka się przyciskiem „Zwiń" lub ponownym dotknięciem „Zmień ceny w miesiącach".
- Po dotknięciu kafelka ekran automatycznie przewija się do edytora, żeby dotknięcie miało widoczny skutek.

### 8.2. Edycja wpisu

Po dotknięciu miesiąca lub wiersza na tym samym ekranie otwiera się panel:

```
┌──────────────────────────────┐
│ Lipiec — wpis                │
│ dotyczy każdego roku         │
│                              │
│ Cena nd–czw                  │
│ ┌──────────────────────────┐ │
│ │ 450                    zł│ │
│ └──────────────────────────┘ │
│ Cena pt–sob                  │
│ ┌──────────────────────────┐ │
│ │ 550                    zł│ │
│ └──────────────────────────┘ │
│                              │
│ Minimalny pobyt              │
│ [ ] Użyj minimum ośrodka (1) │
│ [ − ]    2    [ + ]     noce │
│                              │
│ ┌──────────────────────────┐ │
│ │      Zapisz zmiany       │ │
│ └──────────────────────────┘ │
│         Usuń wpis            │
└──────────────────────────────┘
```

- Minimum nocy: przełącznik **„Użyj minimum ośrodka"** jest domyślnie włączony dla nowego wpisu. Wyłączenie go odsłania stepper i zapisuje minimum tylko dla tego miesiąca. Lista pokazuje wtedy „Minimum: jak w ośrodku" albo wartość wpisu.
- „Usuń wpis" jest tekstowym przyciskiem oddzielonym od „Zapisz zmiany"; dotknięcie otwiera potwierdzenie:
  - „Usunąć wpis dla lipca?"
  - „Ceny wrócą do bazowych. Tej czynności nie da się cofnąć."
  - **Anuluj** / **Usuń**.
- Dotknięcia: otwarcie miesięcy (1) → wybór miesiąca (2) → „Zapisz zmiany" (3). Usunięcie: „Usuń wpis" (1) → „Usuń" w potwierdzeniu (2) — od otwartego wpisu; od wejścia w miesiące to cztery dotknięcia, świadome odstępstwo dla rzadszej czynności.
- Dotknięcie miesiąca z istniejącym wpisem otwiera ten wpis, nie tworzy drugiego.
- Zmiana obowiązuje od razu po zapisie; nie ma osobnego „drugiego cennika".

### 8.3. Stany brzegowe

- Miesiąc bez wpisu: cena wspólna; kafelek z plakietką „Wspólna".
- Wpis obejmuje zawsze jeden miesiąc; wielomiesięczny wpis jest poza MVP.
- Błąd w edytorze wpisu: ten sam mechanizm co na ekranie głównym, pod polem.
- Przełączanie miesiąca z niezapisanymi zmianami: dialog „Masz niezapisane zmiany. Odrzucić?".
- Wpis z cenami równymi bazowym i minimum dziedziczonym nie tworzy własnej ceny; kafelek zostaje „Wspólna", a ekran pokazuje „To są ceny bazowe — wpis nie został utworzony".
- Po zapisie edytor pozostaje otwarty, a kafelki od razu pokazują nowe wartości.
- Po usunięciu wpisu edytor się zamyka, plakietka wraca do „Wspólna", a miesiąc do ceny wspólnej.

## 9. Dostępność i i18n

- Wszystkie teksty przez lokalizację (`l10n`), bez stringów w UI. Klucze m.in.: `pricing_title`, `pricing_subtitle`, `pricing_section_nightly`, `pricing_weekday_label`, `pricing_weekend_label`, `pricing_section_portals`, `pricing_booking_increase`, `pricing_airbnb_increase`, `pricing_section_reservation`, `pricing_deposit_label`, `pricing_min_stay_label`, `pricing_save`, `pricing_months_action`, `pricing_months_hint`, `pricing_tile_own`, `pricing_tile_shared`, `pricing_weekday_short`, `pricing_weekend_short`, `pricing_min_stay_short`, `pricing_change`, `pricing_set`, `pricing_months_legend_week`, `pricing_months_legend_weekend`, `pricing_months_legend_color`, `pricing_delete_entry`, `pricing_delete_confirm_title`, `pricing_delete_confirm_body`, `pricing_cancel`, `pricing_delete`.
- Etykiety czytnika ekranu zawierają jednostkę: „Cena za noc w tygodniu, w złotych", „Narzut na Booking, w procentach".
- Błąd jest ogłaszany przez `Semantics`/`liveRegion`; nie tylko kolorem.
- Kontrast elementów niebędących tekstem: obramowania pól i kafelków, checkbox i fokus mają co najmniej 3:1.
- Testy Flutter Accessibility Guideline: `androidTapTargetGuideline`, `iOSTapTargetGuideline`, `labeledTapTargetGuideline`, `textContrastGuideline`.
- `TextScaler` zamiast `textScaleFactor`; test 200% z uwzględnieniem nieliniowego skalowania Androida 14.
- Dynamiczna wielkość tekstu do 200%: pola i przyciski rosną, tekst się zawija (`Wrap`, `Flexible`), nic nie jest ucinane.
- Kolejność fokusu i nawigacja klawiaturą zgodna z kolejnością wizualną.
- Kafelek miesiąca ma etykietę czytnika: „Lipiec, własna cena, tydzień 450 zł, weekend 550 zł, minimum 2 noce, zmień".
- Legenda ma osobną strukturę: nagłówek „Legenda", definicja tygodnia, definicja weekendu, separator, objaśnienie kolorów „Własna cena" i „Wspólna".
- Nagłówek legendy jest przyciskiem z `Semantics(button: true, expanded: ...)` i etykietą „Legenda, rozwinięta" / „Legenda, zwinięta"; domyślnie zwinięta.
- Siatka kafelków ma 2 kolumny, a przy skali tekstu powyżej ok. 130% lub szerokości poniżej 340 dp przechodzi na 1 kolumnę; kafelek nie ma sztywnej wysokości.
- Przyciski steppera mają etykiety „Zmniejsz minimalny pobyt o 1 noc" i „Zwiększ minimalny pobyt o 1 noc".
- Waluta i procenty są formatowane przez locale (`NumberFormat.currency`, `NumberFormat.percentPattern`), nie przez literalne „zł".
- Liczba nocy używa ICU plural: `{n, plural, one{# noc} few{# noce} many{# nocy} other{# nocy}}`; nie sklejamy „minimum" + liczba + „noce".
- Nazwy miesięcy pochodzą z `DateFormat.MMMM(locale)` / `DateFormat.MMM(locale)`, nie z listy w kodzie.
- Nie stosujemy `uppercase` do tekstów tłumaczonych; plakietki i akcje piszemy normalną wielkością liter.
- Budżet znaków: plakietka ≤ 12, akcja ≤ 10, etykieta ceny ≤ 12, nazwa miesiąca ≤ 14 (z zawijaniem do 2 linii); teksty mogą wydłużyć się o 40%.
- Kafelek ma elastyczną wysokość; nie używamy `FittedBox` do zmniejszania tekstu ani `maxLines: 1` dla treści krytycznych.
- Na tablecie formularz ma maksymalną szerokość ok. 480 dp i jest wyśrodkowany.
- Testy obowiązkowe: pseudo-lokalizacja (`en_XA` / `ar_XB`), `TextScaler.linear(2.0)`, szerokości 320/360/412/768 dp oraz golden testy dla 1/2/5 nocy i kwot do 99 999 zł.

## 10. Komponenty Flutter (propozycja wykonania)

- `PricingScreen` — jeden ekran, `Scaffold` + `CustomScrollView`/`ListView`, dolny `StickySaveBar` w `bottomNavigationBar` lub `Stack`; całość w `PopScope`.
- `AppTheme` — `ThemeData` z `ColorScheme.fromSeed`, `darkTheme` i `themeMode: ThemeMode.system`; kolory wyłącznie z ról M3.
- `PricingController` (`ChangeNotifier`) — stan formularza, walidacja, brudne zmiany, zapis.
- `PricingField` — M3 `TextField`: etykieta, wartość, `suffixText`, błąd, `TextInputAction`, `FilteringTextInputFormatter.digitsOnly`, `onTapOutside`.
- `NightStepper` — `−` / `+`, zakres 1–14, 48 dp.
- `MonthGrid` — 12 kafelków w 2 lub 1 kolumnie; elastyczna wysokość, zawijanie tekstu.
- `MonthTile` — nazwa miesiąca, plakietka „Własna"/„Wspólna", obie ceny, minimum, akcja „Zmień"/„Ustaw"; cały kafelek jest jednym przyciskiem.
- `MonthEntryEditor` — panel edycji wpisu; bez własnego przycisku zapisu, korzysta z paska „Zapisz zmiany".
- `SaveBar` — stany: bez zmian / zmiany / zapisywanie / zapisano; zapisuje cały formularz.
- `SyncStatusBanner` — statusy Booking/Airbnb i ponowienie.
- `ConfirmDeleteDialog` — potwierdzenie usunięcia wpisu.
- `PricingFormatter` — format `1 200 zł`, procenty, liczba nocy.
- Model: `PricingDraft` (sześć pól) i `MonthOverride` (miesiąc, cena nd–czw, cena pt–sob, `minimumOverride` opcjonalny — `null` znaczy „jak w ośrodku").
- `PricingLoadState` — wczytywanie / gotowe / błąd; blokuje zapis do czasu wczytania.
- Repozytorium: interfejs `PricingRepository` z implementacją lokalną na start; zapis zwraca `SaveResult` ze statusem portali. Backend poza zakresem.

## 11. Kryteria akceptacji UX

1. Na jednym ekranie widać sześć pól; na małym telefonie treść się przewija, a „Zapisz zmiany" jest zawsze widoczne i zapisuje cały formularz, łącznie z otwartym wpisem miesiąca.
2. Każde pole pokazuje jednostkę; ceny i procenty przyjmują tylko cyfry, bez groszy.
3. Błędna wartość pokazuje komunikat pod polem, zostaje w polu i blokuje zapis; cena powyżej 99 999 zł jest odrzucana.
4. Po zapisie widać potwierdzenie oraz status Booking i Airbnb; brak potwierdzenia daje komunikat i ponowienie tylko nieudanego portalu.
5. Widok miesięcy pokazuje 12 kafelków; każdy ma nazwę miesiąca, plakietkę „Własna"/„Wspólna", obie ceny, minimum i akcję. Przy dużej czcionce siatka przechodzi na 1 kolumnę.
6. Jeden wpis miesięczny zapisuje się w trzech dotknięciach; usunięcie wymaga potwierdzenia i dwóch dotknięć od otwartego wpisu.
7. Wyjście z niezapisanymi zmianami wymaga potwierdzenia.
8. Wszystkie teksty pochodzą z lokalizacji; przy tekście dłuższym o 40% i skali 200% nic się nie ucina, a siatka przechodzi na 1 kolumnę.
9. Czytnik ekranu odczytuje etykiety pól z jednostkami i komunikaty błędów.
10. Wczytanie cennika blokuje zapis do czasu zakończenia; błąd wczytania pokazuje „Spróbuj ponownie".
11. Minimum nocy można odziedziczyć z ośrodka; kafelek pokazuje „jak w ośrodku".
12. Liczby mnogie (1 noc, 2 noce, 5 nocy) i formaty walut/procentów są poprawne dla locale.
13. Legenda jest domyślnie zwinięta i daje się rozwinąć nagłówkiem; po rozwinięciu pokazuje definicje i kolory.
14. Motyw jasny i ciemny spełnia kontrast 4,5:1 dla tekstu i 3:1 dla elementów UI; fokus jest widoczny.
15. Nawigacja wstecz (gest i przycisk) przechodzi przez `PopScope` i dialog niezapisanych zmian.
16. Testy `androidTapTargetGuideline`, `iOSTapTargetGuideline` i `textContrastGuideline` przechodzą.

## 12. Scenariusze testowe

1. Wpisz 350 / 450 / 16% / 10% / 30% / 1 noc, zapisz — ekran pokazuje 522 zł i 495 zł oraz status portali.
2. Wpisz 0 zł, 120%, 5%, spróbuj zapisać — trzy błędy pod polami, fokus na pierwszym.
3. Dodaj lipiec: 450 / 550 zł, minimum 2 noce, dotknij „Zapisz zmiany" — kafelek ma plakietkę „Własna", obie ceny i minimum.
4. Zmień lipiec na 480 / 600 zł, minimum 3 noce — „Zapisz zmiany" zmienia wpis, nie tworzy drugiego.
5. Usuń wpis dla lipca — potwierdzenie, po „Usuń" ceny wracają do bazowych.
6. Symuluj brak potwierdzenia Airbnb — pasek ostrzeżenia i „Spróbuj teraz".
7. Otwórz ekran na telefonie 360 × 640 — przewijanie działa, „Zapisz zmiany" nie znika.
8. Włącz powiększenie tekstu 200% — siatka przechodzi na 1 kolumnę, etykiety się zawijają, nic nie jest ucięte.
9. Symuluj błąd wczytania cennika — zapis zablokowany, widoczne „Spróbuj ponownie".
10. Dodaj wpis z cenami równymi bazowym — plakietka zostaje „Wspólna", komunikat „To są ceny bazowe".
11. Ustaw minimum wpisu na „jak w ośrodku" — kafelek pokazuje „jak w ośrodku".
12. Włącz pseudo-lokalizację (tekst +40%) — kafelki zawijają, nic nie jest ucięte.
13. Sprawdź liczby mnogie: 1 noc, 2 noce, 5 nocy; w niemieckim 1 Nacht, 2 Nächte, 5 Nächte.
14. Sprawdź kwoty 99 999 zł i nazwy „Październik", „September" — brak przepełnienia.
15. Rozwiń legendę — pokazują się definicje; zwiń — kafelki przesuwają się w górę; po ponownym wejściu legenda jest zwinięta.
16. Włącz tryb ciemny — kolory i kontrast pozostają poprawne.
17. Użyj gestu wstecz z niezapisanymi zmianami — pojawia się dialog „Masz niezapisane zmiany".
18. Uruchom testy dostępności Fluttera — wszystkie przechodzą.

## 13. Poza zakresem

- Backend, API, baza danych i rzeczywista synchronizacja z Booking/Airbnb.
- Rezerwacje, kalendarz, płatności i zaliczka jako proces.
- Logowanie, wiele obiektów, uprawnienia.
- Ceny zależne od liczby osób, święta, opłaty dodatkowe, rabaty.
- Wielomiesięczny wpis jednym zapisem (poza MVP).

## 14. Otwarte decyzje

1. **Treść komunikatu o braku internetu** — propozycja w §7; wymaga akceptacji copy.
2. **Kolejność sekcji** — ceny za noc, portale, rezerwacja; można zamienić portale z rezerwacją, jeśli właściciel częściej zmienia zaliczkę.
3. **Pokaźnik „ostatnio zapisano"** — propozycja; można usunąć, jeśli wydłuża ekran.
4. **Kontrakt backendu** — `SaveResult` i trwałość statusu portali wymagają potwierdzenia przy implementacji backendu; do tego czasu repozytorium lokalne symuluje statusy.

## 15. Standardy i zgodność (Flutter 3.50, Material 3)

Dokument opiera się na oficjalnych wytycznych Fluttera (stan: październik 2026) oraz WCAG 2.2 AA, Material 3, Apple HIG i Android Accessibility.

### 15.1. Motyw i kolory

- Material 3 jest domyślny od Fluttera 3.16; nie ustawiamy `useMaterial3: false`.
- Używamy `ColorScheme.fromSeed` / `colorSchemeSeed`, osobnego schematu dla `Brightness.dark` i `themeMode: ThemeMode.system`.
- Kolory czytamy z `Theme.of(context).colorScheme`; role: `primary`, `onPrimary`, `primaryContainer`, `onPrimaryContainer`, `surface`, `onSurface`, `outline`, `error`.
- Kontrast: tekst 4,5:1 (mały) / 3:1 (duży); elementy UI, obramowania i fokus 3:1. Obramowania `#6b7280`, fokus `#1d5fd0` 3 dp.
- Dark mode to osobny schemat kolorów, nie odwracanie barw.

### 15.2. Dostępność

- Cele dotykowe: 48 × 48 dp Android, 44 × 44 pt iOS; cały kafelek jest jednym przyciskiem.
- Testy: `androidTapTargetGuideline`, `iOSTapTargetGuideline`, `labeledTapTargetGuideline`, `textContrastGuideline`.
- `TextScaler` zamiast `textScaleFactor`; test 200% z nieliniowym skalowaniem Androida 14.
- TalkBack i VoiceOver; `Semantics`/`SemanticsRole`, `liveRegion`, `ExcludeSemantics` dla dzieci kafelka.
- Fokus: 3 dp ring, offset 2 dp; `Scrollable.ensureVisible`, `MediaQuery.viewInsetsOf` i `SafeArea`, żeby sticky bar i klawiatura nie zasłaniały pola.
- Nie polegamy tylko na kolorze; test w skali szarości.

### 15.3. Adaptacyjność

- Używamy `MediaQuery.sizeOf` lub `LayoutBuilder`, nie `OrientationBuilder` ani `MediaQuery.orientation`.
- Breakpointy: compact < 600 dp, medium 600–840 dp, expanded > 840 dp; treść maks. 480 dp szerokości.
- Nie blokujemy orientacji — Android 17 ignoruje `SystemChrome.setPreferredOrientations` na ekranach ≥ 600 dp.
- Kafelki: `GridView` z `SliverGridDelegateWithMaxCrossAxisExtent` lub elastyczny `Wrap`; bez sztywnych wysokości.
- Zachowujemy stan przewijania (`PageStorageKey`) przy zmianie rozmiaru lub obrotu.

### 15.4. Nawigacja i formularze

- `PopScope` z `canPop` i `onPopInvokedWithResult` zamiast `WillPopScope`; w `AndroidManifest.xml` `android:enableOnBackInvokedCallback="true"`.
- Dla Androida 14+ rozważyć `PredictiveBackPageTransitionsBuilder`.
- `TextInputAction.next/done`, `FilteringTextInputFormatter.digitsOnly`, `onTapOutside` do zamykania klawiatury, zaznaczanie wartości przy fokusie.
- Błędy pod polem, fokus na pierwszym błędzie, `liveRegion` z liczbą błędów.

### 15.5. i18n

- `flutter_localizations` + `intl`, pliki ARB i `gen-l10n`, ICU plural dla nocy.
- `DateFormat.MMMM(locale)`, `NumberFormat.currency(locale)`, `NumberFormat.percentPattern(locale)`.
- RTL: `Directionality`, `EdgeInsetsDirectional`, `AlignmentDirectional`; brak ikon kierunkowych.
- Teksty +40%, pseudo-lokalizacja `en_XA` / `ar_XB`.

### 15.6. Ruch i wydajność

- Respektujemy `MediaQuery.disableAnimations` / Reduce Motion; animacje krótkie, bez autoodtwarzania.
- W `build` używamy `MediaQuery.sizeOf`, `textScalerOf`, `viewInsetsOf` zamiast `MediaQuery.of`.
- Nie używamy `FittedBox` do zmniejszania tekstu; zamiast tego zawijamy lub przechodzimy na 1 kolumnę.

### 15.7. Świadomie poza zakresem

- Nie blokujemy orientacji i nie wspieramy desktopu/webu w tym module.
- Nie wymuszamy jednego motywu — respektujemy ustawienie systemu.
- Dynamic color (Material You) jest opcjonalny; bazowy schemat pochodzi z `ColorScheme.fromSeed`.
