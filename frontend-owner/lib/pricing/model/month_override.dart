/// Własna cena dla jednego miesiąca, obowiązująca każdego roku.
class MonthOverride {
  const MonthOverride({
    required this.month,
    required this.weekdayPrice,
    required this.weekendPrice,
    this.minimumNights,
  });

  /// Numer miesiąca od 1 (styczeń) do 12 (grudzień).
  final int month;
  final int weekdayPrice;
  final int weekendPrice;

  /// `null` oznacza minimum obowiązujące w całym ośrodku.
  final int? minimumNights;

  MonthOverride copyWith({
    int? month,
    int? weekdayPrice,
    int? weekendPrice,
    int? minimumNights,
    bool clearMinimumNights = false,
  }) {
    return MonthOverride(
      month: month ?? this.month,
      weekdayPrice: weekdayPrice ?? this.weekdayPrice,
      weekendPrice: weekendPrice ?? this.weekendPrice,
      minimumNights: clearMinimumNights
          ? null
          : (minimumNights ?? this.minimumNights),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthOverride &&
          other.month == month &&
          other.weekdayPrice == weekdayPrice &&
          other.weekendPrice == weekendPrice &&
          other.minimumNights == minimumNights;

  @override
  int get hashCode =>
      Object.hash(month, weekdayPrice, weekendPrice, minimumNights);
}
