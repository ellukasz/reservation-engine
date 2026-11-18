[Console]::OutputEncoding = [Text.Encoding]::UTF8
$root = Split-Path $PSScriptRoot -Parent
$raw = [IO.File]::ReadAllText((Join-Path $root 'AGENTS.md'), [Text.Encoding]::UTF8)
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
