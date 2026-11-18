# Projekt: agenci ds. doprecyzowania wymagań biznesowych

Data: 2026-11-18

## 1. Cel i dlaczego

Surowy pomysł lub niedoprecyzowany opis ląduje w `doc/requirements/`; ma z niego powstać dokładny, przemyślany wymóg biznesowy zgodny z zasadami w `AGENTS.md`. Struktura plików nie jest z góry ustalona — wyłania się wraz z dodawanymi wymaganiami. Pracę wykonuje zestaw czterech małych agentów w układzie *multi-perspective evaluator–optimizer*: trzy perspektywy krytykują, jeden analityk wprowadza poprawki. Wszyscy używają darmowych modeli z OpenCode / OpenRouter i mają sztywne limity, żeby nie marnować tokenów.

## 2. Zakres

Cztery pliki w `.opencode/agents/`:

| Plik | Rola we wzorcu | Perspektywa |
| --- | --- | --- |
| `requirement-lead.md` | optimizer | Główny Analityk Biznesowy — porządkuje notatki, pisze User Stories i kryteria Given/When/Then, pilnuje słownika, nanosi uwagi ewaluatorów |
| `requirement-eval-biz.md` | evaluator | Perspektywa właściciela obiektu i opłacalności rozwiązania |
| `requirement-eval-guest.md` | evaluator | Perspektywa gościa i spójności logiki biznesowej |
| `requirement-eval-scope.md` | evaluator | Perspektywa zakresu MVP i czystości języka wymagań |

Ewaluatorzy dostają tylko obiektyw. Nie mają w sobie listy konkretnych problemów do odszukania, liczb ani przykładów z dokumentów. Wyjście opisuje wyłącznie miejsca, w których materiał nie domyka danej perspektywy: nie streszczają, nie chwalą, nie proponują. Konkretne poprawki należą do leada.

Poza zakresem: skrót `/requirement-review`, osobny agent-orkiestrator, zmiana istniejących wymagań biznesowych bez wyraźnego wniosku, kod aplikacji.

## 3. Podejścia

- **A (wybrane):** cztery subagenty, orkiestracja w sesji głównej. Najmniej plików i tokenów; uruchomienie polega na zdaniu „przeanalizuj <plik>".
- **B:** A + command `/requirement-review`. Jedno polecenie zamiast pamiętania instrukcji, ale dodatkowy plik i nakładka niebędąca agentem. Można dołożyć później.
- **C:** piąty agent `mode: primary` wołający ewaluatorów. Wymaga przełączania sesji i dłuższego promptu orkiestratora — najdroższe przy darmowych modelach.

## 4. Decyzje i konwencje

1. **Prefix `requirement-`** dla wszystkich czterech nazw plików.
2. **Zasady z `AGENTS.md` są nadrzędne** — w tym skala 1–20 jednostek. Nie powtarzamy ich w promptach ewaluatorów; te pozostają ogólne.
3. **Struktura plików nie jest ustalona z góry.** Powstaje wraz z wymaganiami dodawanymi do `doc/requirements/`. Agenci czytają to, co akurat tam jest, i nie zakładają numeracji, nazw ani listy dokumentów.
4. **User Stories z limitem:** maks. 1 historia na funkcję KRYTYCZNĄ/WAŻNĄ, 1–3 kryteria Given/When/Then. Pozostałe reguły zostają w krótkiej formie istniejącej w dokumentach.
5. **Wynik trafia do pliku z rozszerzeniem `.proposed.md` obok materiału źródłowego**, nigdy bezpośrednio do pliku docelowego. Nazwę propozycji lead dobiera do tego, co faktycznie leży w `doc/requirements/`. Główny agent podmia plik dopiero po akceptacji przez właściciela.
6. **Język polski, zero żargonu IT.** Wymagania opisują „co" działa, nie „jak" to zakodować.
7. **Ewaluatorzy bez recept i bez gotowych problemów.** Ich prompty opisują wyłącznie perspektywę — bez sztywnej listy kontrolnej, bez wskazanych z góry przypadków i bez szczegółów z istniejących dokumentów. Nie podają propozycji rozwiązań — to rola leada. Ewentualne powtórzenia obserwacji usuwa główny agent.
8. **Dziedziczenie `AGENTS.md` zostaje.** OpenCode dołącza projektowe instrukcje do każdego agenta — nie wyłączamy tego, żeby ewaluatorzy mieli kontekst projektu. W ich własnych promptach nie powtarzamy jego treści.

## 5. Przepływ

1. Właściciel podaje w sesji głównej ścieżkę do surowego pliku lub wkleja notatki.
2. Główny agent czyta `AGENTS.md`, wskazany plik oraz inne dokumenty aktualnie obecne w `doc/requirements/`, żeby przejąć ich słownik.
3. Główny agent wykrywa w locie komplet plików w `doc/requirements/` i równolegle odpala trzech ewaluatorów. Dostają pełną listę ścieżek i cel, nie wklejoną treść dokumentów — oszczędność tokenów i szansa, że żaden plik nie zostanie pominięty.
4. Główny agent zbiera znaleziska (max 15), usuwa duplikaty i przekazuje leadowi listę razem ze ścieżką do pliku.
5. `requirement-lead` pisze plik `.proposed.md` i zwraca 3–5 linii podsumowania: co zmienił, które uwagi odrzucił i dlaczego.
6. Główny agent pokazuje różnicę i czeka na akceptację. Po akceptacji podmia plik docelowy. Druga runda ewaluacji tylko wtedy, gdy pojawiło się znalezisko KRYTYCZNE.

## 6. Oszczędzanie tokenów

- Darmowe modele: lead `opencode/deepseek-v4.1-flash-free`; ewaluatorzy `opencode/longcat-2.5-free`, `opencode/flint-40b-free`, `opencode/hy4-flash-free`. Fallback przy niedostępności: `openrouter/openrouter/free` lub inny model z listy darmowych.
- `steps`: 6 dla ewaluatorów (muszą sami odnaleźć i przeczytać wskazane pliki), 8 dla leada.
- Ewaluatorzy: `read/glob/grep` bez edycji, shellu i webu. Wyjście — maks. 5 linii w formacie `ID | WAGA | plik:linia | obserwacja`, albo `BRAK_UWAG`. `WAGA`: `KRYTYCZNE` = sprzeczność albo brak możliwości zrozumienia wymogu; `WAŻNE` = brak doprecyzowania; `INFO` = drobiazg. Bez wstępów, bez cytowania dokumentu, bez streszczania, bez pochwał i bez proponowania poprawek.
- Lead: `edit` wyłącznie w `doc/requirements/*.proposed.md`, bez shellu i webu.
- Do promptów przekazujemy ścieżki, nie treść dokumentów. Jedna runda ewaluacji + jedna rewizja.

## 7. Ryzyka

- Darmowe modele mogą być chwilowo niedostępne lub rate-limitowane — przed użyciem trzeba je zweryfikować jednym próbnym wywołaniem każdego.
- Zbyt swobodny lead może rozbudować dokumenty ponad limit z pkt 4 — prompt musi to wyraźnie zakazywać.

## 8. Pozostawione wykonawcy

Dobór ostatecznych modeli po próbnym wywołaniu i dokładna treść promptów systemowych.

## 9. Weryfikacja

Test przyjęcia: jedną celowo wadliwą notatkę (sprzeczność + żargon + brak doprecyzowania) przepuścić przez pełny przebieg z pkt 5. Za poprawne uznać, gdy:

- OpenCode widzi cztery agenty jako subagenty;
- każdy ewaluator zwraca maks. 5 linii w ustalonym formacie albo `BRAK_UWAG`, bez propozycji, streszczenia i pochwał;
- przynajmniej jeden ewaluator wyłapie celową wadę — same `BRAK_UWAG` oznaczają, że trzeba poprawić prompty lub modele;
- lead tworzy plik `.proposed.md` z poprawką, zwraca krótkie podsumowanie i nie rusza pliku docelowego.
