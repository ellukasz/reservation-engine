/// Rodzaje błędów walidacji cennika.
///
/// Komunikaty dla użytkownika są przypisane w warstwie interfejsu (Task 8).
enum PricingError {
  /// Pole nie może być puste; zarezerwowane dla pola tekstowego.
  required,

  /// Cena musi być większa od zera.
  positive,

  /// Cena nie może mieć groszy; zarezerwowane dla przyszłego pola dziesiętnego.
  wholeZloty,

  /// Narzut portalu musi mieścić się w zakresie 0–100%.
  percentRange,

  /// Zaliczka musi mieścić się w zakresie 10–100%.
  depositRange,

  /// Minimalny pobyt musi mieścić się w zakresie 1–14 nocy.
  minNightsRange,

  /// Cena nie może przekroczyć 99 999 zł.
  maxPrice,
}
