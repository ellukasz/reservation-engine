/// Stan formularza cennika przed zapisem.
class PricingDraft {
  const PricingDraft({
    required this.weekdayPrice,
    required this.weekendPrice,
    required this.bookingMarkup,
    required this.airbnbMarkup,
    required this.depositPercent,
    required this.minNights,
  });

  /// Cennik wyjściowy: 350/450 zł, bez narzutów, zaliczka 30%, minimum 1 noc.
  factory PricingDraft.initial() => const PricingDraft(
    weekdayPrice: 350,
    weekendPrice: 450,
    bookingMarkup: 0,
    airbnbMarkup: 0,
    depositPercent: 30,
    minNights: 1,
  );

  /// Pusty formularz: ceny 0 zł, pozostałe wartości jak w [initial].
  factory PricingDraft.empty() => const PricingDraft(
    weekdayPrice: 0,
    weekendPrice: 0,
    bookingMarkup: 0,
    airbnbMarkup: 0,
    depositPercent: 30,
    minNights: 1,
  );

  final int weekdayPrice;
  final int weekendPrice;
  final int bookingMarkup;
  final int airbnbMarkup;
  final int depositPercent;
  final int minNights;

  PricingDraft copyWith({
    int? weekdayPrice,
    int? weekendPrice,
    int? bookingMarkup,
    int? airbnbMarkup,
    int? depositPercent,
    int? minNights,
  }) {
    return PricingDraft(
      weekdayPrice: weekdayPrice ?? this.weekdayPrice,
      weekendPrice: weekendPrice ?? this.weekendPrice,
      bookingMarkup: bookingMarkup ?? this.bookingMarkup,
      airbnbMarkup: airbnbMarkup ?? this.airbnbMarkup,
      depositPercent: depositPercent ?? this.depositPercent,
      minNights: minNights ?? this.minNights,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PricingDraft &&
          other.weekdayPrice == weekdayPrice &&
          other.weekendPrice == weekendPrice &&
          other.bookingMarkup == bookingMarkup &&
          other.airbnbMarkup == airbnbMarkup &&
          other.depositPercent == depositPercent &&
          other.minNights == minNights;

  @override
  int get hashCode => Object.hash(
    weekdayPrice,
    weekendPrice,
    bookingMarkup,
    airbnbMarkup,
    depositPercent,
    minNights,
  );
}
