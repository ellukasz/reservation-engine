---
description: Dopracuj wymaganie biznesowe przez ewaluatorów i leada
---

Dopracuj wymaganie $ARGUMENTS.

1. Przeczytaj `AGENTS.md`, plik $ARGUMENTS i pozostałe pliki z `doc/requirements/` z wyłączeniem `*.proposed.md`. Ewaluatorom przekazuj ścieżki, nie treść dokumentów.
2. Uruchom przez narzędzie `subagent` równolegle `requirement-eval-biz`, `requirement-eval-guest` i `requirement-eval-scope`. Każdy dostaje tylko listę ścieżek i własną perspektywę — nie podawaj im konkretnych problemów ani rozwiązań.
3. Pomień `BRAK_UWAG`, usuń powtórzenia i przekaż leadowi maks. 15 obserwacji w formacie `ID | WAGA | plik:linia | obserwacja`.
4. Uruchom `requirement-lead` z plikiem źródłowym i obserwacjami. Zapisz wynik wyłącznie do pliku o tej samej nazwie z dopiskiem `.proposed.md` przed rozszerzeniem (np. `01-pricing.md` → `01-pricing.proposed.md`). Nie zmieniaj pliku źródłowego.
5. Zwróć 3–5 linii podsumowania: co zmieniłeś, co odrzuciłeś i dlaczego, ścieżka do pliku. Pokaż różnicę właścicielowi do akceptacji. Jeśli wystąpiło `KRYTYCZNE`, przed akceptacją uruchom drugą rundę: `requirement-eval-biz` i `requirement-eval-scope` na świeżym pliku proponowanym.
