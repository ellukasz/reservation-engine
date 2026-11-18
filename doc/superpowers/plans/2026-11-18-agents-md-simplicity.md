# Proste zasady w AGENTS.md — plan wdrożenia

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Podmienić treść `AGENTS.md` na sześć krótkich reguł z jawną kolejnością priorytetów, zrozumiałą dla agenta UX.

**Architecture:** Jedna zmiana w jednym pliku. Dokument projektowy ustala dokładną treść; test sprawdza obecność każdej linii i brak starych błędów. Nie modyfikujemy plików agentów ani dokumentów wymagań.

**Tech Stack:** Markdown, PowerShell do weryfikacji treści.

**Spec:** `doc/superpowers/specs/2026-11-18-agents-md-design.md`

**Status:** Zrealizowane. Task 1 w commitcie `5aa3d68`; poprawki z końcowego review w kolejnym commitcie. Szczegóły decyzji w ledgerze `.superpowers/sdd/2026-11-18-agents-md-simplicity/progress.md`.

## Global Constraints

- Dokładna docelowa treść `AGENTS.md` jest w bloku kodu w specu — przepisać 1:1.
- Lista zostaje sześciopunktowa; nie dodajemy siódmej reguły ani pytań kontrolnych.
- Linia priorytetów stoi przed listą: bezpieczeństwo → proste korzystanie → dodatkowe funkcje.
- Zdanie o interfejsie: „Interfejs nie może gubić użytkownika ani go przytłaczać."
- Reguła 4 brzmi „Chroń rezerwację:" — bez powtórzenia „najpierw".
- Akceptowalne są wyłącznie terminy *allotment*, *rate plan* i *channel manager* w regule 2 jako przykłady zakazanego żargonu.
- Język polski, bez nowego żargonu IT.
- Skrypt weryfikujący jest częścią repozytorium (`scripts/verify-agents-md.ps1`), z jawnym odczytem UTF-8 i BOM — działa w czystym klonie i na PowerShell 5.

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

- [x] **Step 1: Zdefiniuj test**

Testem jest skrypt w repozytorium: `scripts/verify-agents-md.ps1`. Sprawdza dokładne brzmienie siedmiu linii, brak starych błędów i liczbę reguł. Plik ma BOM i czyta `AGENTS.md` jawnie jako UTF-8.

Run:
```powershell
powershell.exe -NoProfile -File C:/_lukasz/hotele/scripts/verify-agents-md.ps1
```

- [x] **Step 2: Uruchom test przed zmianą**

Expected: `FAIL brak linii`, `FAIL zbędny ciąg: 6. -`, `FAIL liczba reguł != 6`.

- [x] **Step 3: Podmień `AGENTS.md`**

Zastąp całą treść pliku blokiem kodu z sekcji „Projekt zmiany" w specu. Nie zmieniaj kolejności linii ani interpunkcji.

- [x] **Step 4: Uruchom test po zmianie**

Expected: `AGENTS_MD_CHECK_PASS`, zero linii `FAIL`.

- [x] **Step 5: Sprawdź, że agenci nadal przechodzą kontrolę**

Run:
```powershell
powershell.exe -NoProfile -File C:/_lukasz/hotele/.superpowers/sdd/2026-11-18-requirement-agents/verify-agents.ps1
git status --short
```
Expected: `ALL_AGENT_CHECKS_PASS`; w `git status` tylko `AGENTS.md` i dwa dokumenty projektowe.

- [x] **Step 6: Commit**

```bash
git add AGENTS.md doc/superpowers/specs/2026-11-18-agents-md-design.md doc/superpowers/plans/2026-11-18-agents-md-simplicity.md
git commit -m "docs: simplify AGENTS.md rules"
```

---

### Task 2: Poprawki z końcowego review

**Files:**
- Add: `scripts/verify-agents-md.ps1`
- Modify: ten plan, dokument projektowy

**Interfaces:**
- Consumes: uwagi reviewera z `.superpowers/sdd/2026-11-18-agents-md-simplicity/review-343b4c8..5aa3d68.diff`.
- Produces: test w repozytorium i spójna dokumentacja planu/specu.

- [x] **Step 1: przenieś test do repozytorium**

Skrypt z lokalnego workspace zapisany jako `scripts/verify-agents-md.ps1` z BOM i jawnym UTF-8.

- [x] **Step 2: udowodnij, że test wykrywa regresję**

Na kopii plików w katalogu tymczasowym zmieniono zdanie o interfejsie. Expected: `FAIL brak linii` i brak `AGENTS_MD_CHECK_PASS`. Uzyskano `REGRESSION_CHECK_PASS`.

- [x] **Step 3: usuń niespójności dokumentów**

Spec: dopuszczono hasło w regule 5. Plan: poprawiono brzmienie ograniczenia żargonu, status zadań i lokalizację testu.

- [x] **Step 4: Commit**

```bash
git add scripts/verify-agents-md.ps1 doc/superpowers/plans/2026-11-18-agents-md-simplicity.md doc/superpowers/specs/2026-11-18-agents-md-design.md
git commit -m "test: keep AGENTS.md checks in repo"
```
