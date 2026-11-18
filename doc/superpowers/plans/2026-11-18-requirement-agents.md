# Agenci ds. doprecyzowania wymagań biznesowych — plan wdrożenia

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Dodać cztery darmowe subagentury OpenCode, które z surowych notatek w `doc/requirements/` tworzą dopracowane wymagania biznesowe w układzie evaluator–optimizer.

**Architecture:** Trzech ewaluatorów read-only, każdy z jedną perspektywą i sztywnym formatem krótkich obserwacji, działa równolegle przed rewizją. `requirement-lead` jako jedyny ma prawo zapisu i tworzy plik `.proposed.md` obok materiału źródłowego; plik docelowy jest podmieniany dopiero po akceptacji. Główna sesja orkiestruje przebieg — nie ma piątego agenta ani pliku konfiguracyjnego.

**Tech Stack:** definicje agentów OpenCode (Markdown + YAML frontmatter), weryfikacja w PowerShell, narzędzie `subagent`.

**Spec:** `doc/superpowers/specs/2026-11-18-requirement-agents-design.md`

## Global Constraints

- Prefix nazw: `requirement-`. Lokalizacja: `.opencode/agents/`.
- `mode: subagent` dla wszystkich czterech agentów.
- Modele: lead `opencode/deepseek-v4.1-flash-free`; ewaluatorzy `opencode/longcat-2.5-free`, `opencode/flint-40b-free`, `opencode/hy4-flash-free`.
- `steps`: ewaluatorzy 6, lead 8.
- Ewaluator: wyłącznie perspektywa — bez gotowych problemów, liczb i przykładów z dokumentów; bez propozycji, streszczeń i pochwał.
- Wyjście ewaluatora: `ID | WAGA | plik:linia | obserwacja`, maks. 5 linii albo `BRAK_UWAG`. Identyfikatory: `B1`, `G1`, `S1`.
- `WAGA`: `KRYTYCZNE` = sprzeczność albo brak możliwości zrozumienia wymogu; `WAŻNE` = brak doprecyzowania; `INFO` = drobiazg.
- Ewaluatorzy: `read/glob/grep` dozwolone; `edit`, `shell`, `webfetch`, `websearch`, `subagent` zabronione.
- Lead: `edit` wyłącznie w `doc/requirements/*.proposed.md`; `shell`, `webfetch`, `websearch`, `subagent` zabronione.
- Lead: maks. 1 User Story na funkcję KRYTYCZNĄ/WAŻNĄ, 1–3 kryteria Given/When/Then.
- `AGENTS.md` jest dziedziczony przez agentów — nie wyłączać instrukcji projektowych.
- Język polski, zero żargonu IT, wymagania opisują „co", nie „jak".
- Struktura `doc/requirements/` nie jest znana z góry — agenci nie zakładają numeracji ani listy plików.
- Zwięzłość: treść każdego pliku agenta ≤ 20 linii; obserwacje ewaluatora ≤ 5 linii; podsumowanie leada 3–5 linii; bez wstępów i rozbudowanych wyjaśnień.

## Review Focus

- Ewaluator zamiast obserwacji podaje gotowe rozwiązanie → Task 5: wynik nie zawiera `proponuję|należy|można dodać|zamiast`.
- Ewaluator milczy na celowo wadliwym materiale → Task 5: co najmniej jedna obserwacja wskazuje wsianą wadę.
- Lead nadpisuje plik źródłowy zamiast tworzyć `.proposed.md` → Task 5: hash pliku testowego przed i po jest identyczny.
- Ewaluator dostaje niepełną listę ścieżek i czyta tylko jeden plik → Task 5: główna sesja przekazuje komplet ścieżek; obserwacje zawierają `plik:linia` wskazujący plik testowy.
- Darmowy model nie odpowiada → Tasks 1–4: każdy agent odpowiada jednym wywołaniem; fallback wg specu to `openrouter/openrouter/free`.

---

### Task 1: Ewaluator biznesowy

**Files:**
- Create: `.opencode/agents/requirement-eval-biz.md`

**Interfaces:**
- Consumes: lista ścieżek do plików i cel analizy przekazane przez sesję główną.
- Produces: agent ID `requirement-eval-biz`; obserwacje `B1`–`B5` w formacie z Global Constraints.

- [ ] **Step 1: Napisz plik agenta**

Frontmatter: `description` po polsku z perspektywą właściciela i opłacalności, `mode: subagent`, `model: opencode/longcat-2.5-free`, `steps: 6`, pięć reguł `deny` dla `edit`, `shell`, `webfetch`, `websearch`, `subagent` (`resource: "*"`). Treść musi zawierać: perspektywę właściciela małego obiektu i opłacalności; wejście jako listę ścieżek i cel; zdanie „zwracaj tylko miejsca, w których materiał nie domyka tej perspektywy"; zakaz streszczania, chwalenia, proponowania i podawania gotowych problemów; format z `WAGA`, `ID` od `B1`, limitem 5 i `BRAK_UWAG`; polecenie pisania po polsku bez wstępu i podsumowania.

- [ ] **Step 2: Sprawdź strukturę pliku**

Run:
```powershell
$f='.opencode/agents/requirement-eval-biz.md'
@('mode: subagent','model: opencode/longcat-2.5-free','steps: 6','B1','ID | WAGA | plik:linia | obserwacja','BRAK_UWAG','KRYTYCZNE','WAŻNE','INFO') | ForEach-Object { "$_ = " + [bool](Select-String -Path $f -Pattern ([regex]::Escape($_)) -Quiet) }
```
Expected: wszystkie wartości `True`.

- [ ] **Step 3: Sprawdź wywołanie agenta**

Wywołaj `subagent` z `agent: "requirement-eval-biz"`, przekazując listę aktualnych ścieżek `doc/requirements/*.md` i cel „sprawdź materiał z swojej perspektywy". Expected: maks. 5 linii w ustalonym formacie albo `BRAK_UWAG`, bez propozycji i streszczenia. Jeśli agent nie jest widoczny w bieżącej sesji, wywołaj go w świeżej sesji po przeładowaniu konfiguracji.

- [ ] **Step 4: Commit**

```bash
git add .opencode/agents/requirement-eval-biz.md
git commit -m "feat: add requirement business evaluator"
```

### Task 2: Ewaluator ścieżki gościa

**Files:**
- Create: `.opencode/agents/requirement-eval-guest.md`

**Interfaces:**
- Consumes: jak Task 1.
- Produces: agent ID `requirement-eval-guest`; obserwacje `G1`–`G5`.

- [ ] **Step 1: Napisz plik agenta**

Jak w Task 1, z trzema różnicami: `model: opencode/flint-40b-free`; perspektywa gościa rezerwującego nocleg oraz spójności logiki biznesowej opisanego przebiegu; identyfikatory od `G1`. Pozostałe reguły i zakazy bez zmian.

- [ ] **Step 2: Sprawdź strukturę pliku**

Run:
```powershell
$f='.opencode/agents/requirement-eval-guest.md'
@('mode: subagent','model: opencode/flint-40b-free','steps: 6','G1','ID | WAGA | plik:linia | obserwacja','BRAK_UWAG','KRYTYCZNE','WAŻNE','INFO') | ForEach-Object { "$_ = " + [bool](Select-String -Path $f -Pattern ([regex]::Escape($_)) -Quiet) }
```
Expected: wszystkie wartości `True`.

- [ ] **Step 3: Sprawdź wywołanie agenta**

Jak w Task 1, z `agent: "requirement-eval-guest"`. Expected bez zmian.

- [ ] **Step 4: Commit**

```bash
git add .opencode/agents/requirement-eval-guest.md
git commit -m "feat: add requirement guest-path evaluator"
```

### Task 3: Ewaluator zakresu i języka

**Files:**
- Create: `.opencode/agents/requirement-eval-scope.md`

**Interfaces:**
- Consumes: jak Task 1.
- Produces: agent ID `requirement-eval-scope`; obserwacje `S1`–`S5`.

- [ ] **Step 1: Napisz plik agenta**

Jak w Task 1, z trzema różnicami: `model: opencode/hy4-flash-free`; perspektywa zakresu minimalnego produktu oraz czystości języka wymagań (co ma działać, nie jak to zbudować); identyfikatory od `S1`. Pozostałe reguły i zakazy bez zmian.

- [ ] **Step 2: Sprawdź strukturę pliku**

Run:
```powershell
$f='.opencode/agents/requirement-eval-scope.md'
@('mode: subagent','model: opencode/hy4-flash-free','steps: 6','S1','ID | WAGA | plik:linia | obserwacja','BRAK_UWAG','KRYTYCZNE','WAŻNE','INFO') | ForEach-Object { "$_ = " + [bool](Select-String -Path $f -Pattern ([regex]::Escape($_)) -Quiet) }
```
Expected: wszystkie wartości `True`.

- [ ] **Step 3: Sprawdź wywołanie agenta**

Jak w Task 1, z `agent: "requirement-eval-scope"`. Expected bez zmian.

- [ ] **Step 4: Commit**

```bash
git add .opencode/agents/requirement-eval-scope.md
git commit -m "feat: add requirement scope evaluator"
```

### Task 4: Analityk prowadzący (optimizer)

**Files:**
- Create: `.opencode/agents/requirement-lead.md`

**Interfaces:**
- Consumes: obserwacje `B<n>`, `G<n>`, `S<n>` z Tasks 1–3 oraz ścieżka do materiału źródłowego.
- Produces: plik `doc/requirements/*.proposed.md` oraz 3–5 linii podsumowania ze ścieżką do tego pliku.

- [ ] **Step 1: Napisz plik agenta**

Frontmatter: `description` po polsku z rolą Głównego Analityka Biznesowego, `mode: subagent`, `model: opencode/deepseek-v4.1-flash-free`, `steps: 8`. Reguły uprawnień: `edit` jako `deny` dla `"*"`, a następnie `edit` jako `allow` dla `doc/requirements/*.proposed.md` (kolejność ważna — ostatnia pasująca reguła wygrywa); `shell`, `webfetch`, `websearch`, `subagent` jako `deny` dla `"*"`. Treść musi zawierać: wejście = materiał źródłowy + lista obserwacji; przeczytanie plików aktualnie w `doc/requirements/` w celu przejęcia słownika; zamianę notatek na cel, reguły, kryteria akceptacji i przypadki brzegowe; limit z Global Constraints dla User Stories i Given/When/Then; rozpatrzenie każdej obserwacji (uwzględnij albo odrzuć jednym zdaniem); zapis wyłącznie do pliku z rozszerzeniem `.proposed.md` obok materiału źródłowego, z nazwą dobraną w locie; zakaz nadpisywania pliku źródłowego i zakładania numeracji; polski język, zero żargonu, „co" nie „jak"; wyjście 3–5 linii podsumowania.

- [ ] **Step 2: Sprawdź strukturę pliku**

Run:
```powershell
$f='.opencode/agents/requirement-lead.md'
@('mode: subagent','model: opencode/deepseek-v4.1-flash-free','steps: 8','doc/requirements/*.proposed.md','Given/When/Then','BRAK_UWAG') | ForEach-Object { "$_ = " + [bool](Select-String -Path $f -Pattern ([regex]::Escape($_)) -Quiet) }
```
Expected: wszystkie wartości `True` (ostatni token sprawdza, że lead zna kontrakt ewaluatorów).

- [ ] **Step 3: Sprawdź zakres zapisu agenta**

Run:
```powershell
Select-String -Path .opencode/agents/requirement-lead.md -Pattern 'effect: allow' -Context 1,0
```
Expected: dokładnie jedno wystąpienie, poprzedzone linią `resource: "doc/requirements/*.proposed.md"`.

- [ ] **Step 4: Commit**

```bash
git add .opencode/agents/requirement-lead.md
git commit -m "feat: add requirement lead analyst"
```

### Task 5: Test przyjęcia całego przebiegu

**Files:**
- Create: `.opencode/tmp/smoke-zle.md` (materiał testowy, usuwany po teście)
- Create tymczasowo: plik `.proposed.md` w `.opencode/tmp/`

**Interfaces:**
- Consumes: cztery agenty z Tasks 1–4.
- Produces: potwierdzenie kryteriów z sekcji 9 specu albo lista rzeczy do poprawy w promptach/modelach.

- [ ] **Step 1: Przygotuj wadliwy materiał testowy**

Zapisz w `.opencode/tmp/smoke-zle.md` krótką notatkę zawierającą: sprzeczność (np. „zaliczka 30%" i „zaliczka 50%"), żargon IT (np. „allotment", „rate plan") oraz brak doprecyzowania (np. „cena ustalana później").

- [ ] **Step 2: Zapisz hash pliku testowego**

Run:
```powershell
(Get-FileHash .opencode/tmp/smoke-zle.md -Algorithm SHA256).Hash
```
Expected: wartość zapisana do porównania w Kroku 5.

- [ ] **Step 3: Uruchom pełny przebieg z pkt 5 specu**

Sesja główna czyta `AGENTS.md`, plik testowy i pliki aktualnie w `doc/requirements/`; wykrywa komplet ścieżek; równolegle wywołuje trzech ewaluatorów z pełną listą ścieżek; usuwa powtórzenia; przekazuje obserwacje i ścieżkę do leada; lead zapisuje `.proposed.md` i zwraca podsumowanie.

- [ ] **Step 4: Sprawdź wyjście ewaluatorów**

Dla każdego z trzech wyników: maks. 5 linii w formacie `ID | WAGA | plik:linia | obserwacja` albo `BRAK_UWAG`; brak frazy `proponuję|należy|można dodać|zamiast`; co najmniej jedna obserwacja wskazuje `smoke-zle.md` i jedną z wsianych wad. Jeśli wszystkie zwróciły `BRAK_UWAG` — test NIE przeszedł; popraw prompty lub modele ewaluatorów i powtórz krok 3.

- [ ] **Step 5: Sprawdź wyjście leada i nienaruszenie źródła**

Run:
```powershell
(Get-FileHash .opencode/tmp/smoke-zle.md -Algorithm SHA256).Hash
git status --short
```
Expected: hash identyczny z Krokiem 2; w `git status` tylko pliki agentów i nowy plik `.proposed.md`; brak modyfikacji istniejących dokumentów. Podsumowanie leada ma 3–5 linii i zawiera ścieżkę do `.proposed.md`.

- [ ] **Step 6: Posprzątaj artefakty testowe**

Usuń `.opencode/tmp/smoke-zle.md` oraz wygenerowany plik `.proposed.md`. Expected: `git status --short` pokazuje wyłącznie cztery pliki agentów i dokumenty projektowe.

- [ ] **Step 7: Zapisz wynik weryfikacji**

Dopisz do sekcji 9 specu jedną linię z datą i wynikiem testu (PASS albo konkretna przyczyna FAIL). Expected: spec zawiera ślad wykonania testu.
