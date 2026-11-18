# Proste zasady w AGENTS.md — plan wdrożenia

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Podmienić treść `AGENTS.md` na sześć krótkich reguł z jawną kolejnością priorytetów, zrozumiałą dla agenta UX.

**Architecture:** Jedna zmiana w jednym pliku. Dokument projektowy ustala dokładną treść; test sprawdza obecność każdej linii i brak starych błędów. Nie modyfikujemy plików agentów ani dokumentów wymagań.

**Tech Stack:** Markdown, PowerShell do weryfikacji treści.

**Spec:** `doc/superpowers/specs/2026-11-18-agents-md-design.md`

## Global Constraints

- Dokładna docelowa treść `AGENTS.md` jest w bloku kodu w specu — przepisać 1:1.
- Lista zostaje sześciopunktowa; nie dodajemy siódmej reguły ani pytań kontrolnych.
- Linia priorytetów stoi przed listą: bezpieczeństwo → proste korzystanie → dodatkowe funkcje.
- Zdanie o interfejsie: „Interfejs nie może gubić użytkownika ani go przytłaczać."
- Reguła 4 brzmi „Chroń rezerwację:" — bez powtórzenia „najpierw".
- Akceptowalne jest tylko słowo „allotment", „rate plan" i „channel manager" w regule 2 jako przykłady zakazanego żargonu.
- Język polski, bez nowego żargonu IT.

## Review Focus

- Zniknie linia priorytetów → agenci nie wiedzą, co wygra w konflikcie: test sprawdza dokładne zdanie.
- Zniknie zdanie o niegubieniu i nieprzytłaczaniu → agent UX nie dostanie wytycznej: test sprawdza dokładne zdanie.
- Ktoś doda siódmą regułę albo usunie jedną → test liczy dokładnie 6 punktów.
- Wrócą literówki `wlascicel`, `goscie` albo marker `6. -` → test sprawdza ich brak.
- Ktoś przywróci „Chroń rezerwację najpierw" → test sprawdza brak tego ciągu.

---

### Task 1: Podmiana treści `AGENTS.md`

**Files:**
- Modify: `AGENTS.md`
- Commit: `doc/superpowers/specs/2026-11-18-agents-md-design.md`, `doc/superpowers/plans/2026-11-18-agents-md-simplicity.md`

**Interfaces:**
- Consumes: dokładna treść z bloku kodu w specu.
- Produces: `AGENTS.md` z sześcioma regułami i linią priorytetów; dziedziczą go agenci `requirement-*`.

- [ ] **Step 1: Zdefiniuj test**

Test to poniższy skrypt PowerShell. Nie zapisuj go osobno — użyj go w krokach 2 i 4.

```powershell
$raw = Get-Content 'AGENTS.md' -Raw
$expected = @(
'Priorytety: najpierw bezpieczna rezerwacja, potem proste i zrozumiałe korzystanie, dopiero potem dodatkowe funkcje. Interfejs nie może gubić użytkownika ani go przytłaczać.',
'1. **Stawiaj telefon na pierwszym miejscu:** każda funkcja działa wygodnie na ekranie telefonu.',
'2. **Mów po prostu:** używaj *dostępnych terminów*, *cennika* i *synchronizacji z Booking*. Nie używaj *allotment*, *rate plan*, *channel manager* ani innego żargonu.',
'3. **Trzymaj się MVP:** odrzucaj funkcje korporacyjne i rzadkie wyjątki, jeśli wymagają więcej niż 2–3 kliknięcia.',
'4. **Chroń rezerwację:** nie dopuszczaj do podwójnej rezerwacji; gość zawsze widzi pełną kwotę przed wpłatą.',
'5. **Mniej opcji, więcej automatyzacji:** nie dodawaj zbędnych opcji hotelowych; powtarzalne zadania wykonuj w tle.',
'6. **Zakładaj niskie kompetencje techniczne:** właściciel i gość obsługują wszystko na smartfonie jedną ręką, bez wiedzy technicznej.'
)
$fail = $false
foreach ($line in $expected) { if (-not $raw.Contains($line)) { Write-Output "FAIL brak linii: $line"; $fail = $true } }
foreach ($bad in @('6. -','wlascicel','goscie','Chroń rezerwację najpierw')) { if ($raw.Contains($bad)) { Write-Output "FAIL zbędny ciąg: $bad"; $fail = $true } }
if (([regex]::Matches($raw, '(?m)^\d+\. \*\*')).Count -ne 6) { Write-Output 'FAIL liczba reguł != 6'; $fail = $true }
if ($fail) { exit 1 }
Write-Output 'AGENTS_MD_CHECK_PASS'
```

- [ ] **Step 2: Uruchom test przed zmianą**

Uruchom skrypt z Kroku 1 w katalogu repo.
Expected: FAIL — brak linii priorytetów, brak nowych reguł, obecne `6. -`, `wlascicel`, `goscie`.

- [ ] **Step 3: Podmień `AGENTS.md`**

Zastąp całą treść pliku blokiem kodu z sekcji „Projekt zmiany" w specu. Nie zmieniaj kolejności linii ani interpunkcji.

- [ ] **Step 4: Uruchom test po zmianie**

Uruchom ten sam skrypt.
Expected: `AGENTS_MD_CHECK_PASS`, zero linii `FAIL`.

- [ ] **Step 5: Sprawdź, że agenci nadal przechodzą kontrolę**

Run:
```powershell
powershell.exe -NoProfile -File C:/_lukasz/hotele/.superpowers/sdd/2026-11-18-requirement-agents/verify-agents.ps1
git status --short
```
Expected: `ALL_AGENT_CHECKS_PASS`; w `git status` tylko `AGENTS.md` i dwa dokumenty projektowe.

- [ ] **Step 6: Commit**

```bash
git add AGENTS.md doc/superpowers/specs/2026-11-18-agents-md-design.md doc/superpowers/plans/2026-11-18-agents-md-simplicity.md
git commit -m "docs: simplify AGENTS.md rules"
```
