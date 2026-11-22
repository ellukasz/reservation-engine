---
description: Dopracuj wymaganie biznesowe przez ewaluatorów i leada
---

Dopracuj wymaganie $ARGUMENTS.

1. Przeczytaj `AGENTS.md`, plik $ARGUMENTS i pozostałe pliki z `doc/requirements/` z wyłączeniem `*.proposed.md`. Ustal jedno zdanie celu na podstawie `$ARGUMENTS` i sekcji „Cel" pliku źródłowego. Ewaluatorom przekazuj ścieżki i to zdanie, nie treść dokumentów.
2. Uruchom przez narzędzie `subagent` równolegle `requirement-eval-biz`, `requirement-eval-guest` i `requirement-eval-scope`. Każdy dostaje listę ścieżek, cel i własną perspektywę — nie podawaj im konkretnych problemów ani rozwiązań.
3. Pomień `BRAK_UWAG`. Odrzuć obserwacje, których `plik:linia` nie wskazuje na wiersz w przekazanym pliku. Usuń powtórzenia treści, nie numerów ID. Uporządkuj: wszystkie `KRYTYCZNE`, potem `WAŻNE`, potem `INFO`; przekaż leadowi maks. 15 pozycji w formacie `ID | WAGA | plik:linia | obserwacja`.
4. Uruchom `requirement-lead` z plikiem źródłowym, celem i obserwacjami. Niech zapisze wynik wyłącznie do pliku o tej samej nazwie z dopiskiem `.proposed.md` przed rozszerzeniem (np. `01-pricing.md` → `01-pricing.proposed.md`). Nie zmieniaj pliku źródłowego.
5. Porównaj źródło z proponowanym. Jeśli lead zwrócił `BRAK_ZMIAN` albo pliki są identyczne, napisz to wprost z powodem — nie nazywaj tego poprawą. Pokaż różnicę właścicielowi do akceptacji w 3–5 liniach: co zmieniłeś, co odrzuciłeś i dlaczego, ścieżka do pliku.
6. Jeśli w obserwacjach wystąpiło `KRYTYCZNE`, przed akceptacją uruchom drugą rundę: wszystkich trzech ewaluatorów (`biz`, `guest`, `scope`) na świeżym pliku proponowanym z tym samym celem. Przekaż ich uwagi leadowi, niech nanie je do tego samego pliku `.proposed.md`, i dopiero wtedy pokaż różnicę właścicielowi.
