import 'package:flutter/foundation.dart';

import 'model/month_override.dart';
import 'model/portal.dart';
import 'model/pricing_draft.dart';
import 'model/pricing_error.dart';
import 'model/pricing_field.dart';
import 'model/pricing_repository.dart';
import 'model/save_result.dart';
import 'pricing_validator.dart';

/// Stan wczytywania cennika.
enum PricingLoadState {
  /// Cennik jest w trakcie wczytywania; zapis jest zablokowany.
  loading,

  /// Cennik został wczytany i można go edytować oraz zapisać.
  ready,

  /// Wczytanie nie udało się; zapis jest zablokowany.
  error,
}

/// Stan formularza cennika, jego walidacji i zapisu.
class PricingController extends ChangeNotifier {
  /// Tworzy kontroler korzystający z podanego [PricingRepository].
  PricingController(this._repository)
    : _draft = PricingDraft.initial(),
      _savedDraft = PricingDraft.initial(),
      _overrides = const [],
      _savedOverrides = const [];

  final PricingRepository _repository;

  static const int _minOverrideNights = 1;
  static const int _maxOverrideNights = 14;

  PricingLoadState _loadState = PricingLoadState.loading;
  PricingDraft _draft;
  PricingDraft _savedDraft;
  List<MonthOverride> _overrides;
  List<MonthOverride> _savedOverrides;
  MonthOverride? _editingOverride;
  bool _isDirty = false;
  bool _isSaving = false;
  SaveResult? _lastSaveResult;
  Object? _loadError;
  Object? _saveError;
  Map<PricingField, PricingError> _errors = {};

  /// Stan wczytywania cennika.
  PricingLoadState get loadState => _loadState;

  /// Aktualne wartości formularza, także niezapisane.
  PricingDraft get draft => _draft;

  /// Zapisane wpisy miesięcy, które kafelki pokazują po zapisie.
  List<MonthOverride> get overrides => List.unmodifiable(_overrides);

  /// Wpis miesiąca otwarty w edytorze lub `null`, gdy edytor jest zamknięty.
  MonthOverride? get editingOverride => _editingOverride;

  /// Czy formularz ma niezapisane zmiany.
  bool get isDirty => _isDirty;

  /// Czy zapis jest w toku.
  bool get isSaving => _isSaving;

  /// Wynik ostatniego zapisu wraz ze statusem portali.
  SaveResult? get lastSaveResult => _lastSaveResult;

  /// Błąd wczytania cennika lub `null`.
  Object? get loadError => _loadError;

  /// Błąd zapisu cennika lub `null` po udanym zapisie.
  Object? get saveError => _saveError;

  /// Błędy walidacji kluczowane polem formularza.
  Map<PricingField, PricingError> get errors => Map.unmodifiable(_errors);

  /// Czy otwarty wpis ma same wartości bazowe i dziedziczone minimum.
  ///
  /// Taki wpis nie zostaje zapisany jako własna cena miesiąca.
  bool get editingOverrideEqualsBase {
    final editing = _editingOverride;
    if (editing == null) return false;
    return editing.weekdayPrice == _draft.weekdayPrice &&
        editing.weekendPrice == _draft.weekendPrice &&
        editing.minimumNights == null;
  }

  /// Wczytuje cennik z repozytorium i czyści niezapisane zmiany.
  Future<void> load() async {
    _loadState = PricingLoadState.loading;
    _loadError = null;
    notifyListeners();

    try {
      final snapshot = await _repository.load();
      _savedDraft = snapshot.draft;
      _savedOverrides = List<MonthOverride>.from(snapshot.overrides);
      _draft = snapshot.draft;
      _overrides = List<MonthOverride>.from(snapshot.overrides);
      _editingOverride = null;
      _isDirty = false;
      _errors = {};
      _saveError = null;
      _loadState = PricingLoadState.ready;
    } catch (error) {
      _loadState = PricingLoadState.error;
      _loadError = error;
    }

    notifyListeners();
  }

  /// Zmienia cenę nocy w tygodniu.
  void updateWeekdayPrice(int value) {
    _draft = _draft.copyWith(weekdayPrice: value);
    _markDraftChanged(PricingField.weekdayPrice);
  }

  /// Zmienia cenę nocy w weekendzie.
  void updateWeekendPrice(int value) {
    _draft = _draft.copyWith(weekendPrice: value);
    _markDraftChanged(PricingField.weekendPrice);
  }

  /// Zmienia narzut Booking.
  void updateBookingMarkup(int value) {
    _draft = _draft.copyWith(bookingMarkup: value);
    _markDraftChanged(PricingField.bookingMarkup);
  }

  /// Zmienia narzut Airbnb.
  void updateAirbnbMarkup(int value) {
    _draft = _draft.copyWith(airbnbMarkup: value);
    _markDraftChanged(PricingField.airbnbMarkup);
  }

  /// Zmienia zaliczkę.
  void updateDepositPercent(int value) {
    _draft = _draft.copyWith(depositPercent: value);
    _markDraftChanged(PricingField.depositPercent);
  }

  /// Zmienia minimalny pobyt całego ośrodka.
  void updateMinNights(int value) {
    _draft = _draft.copyWith(minNights: value);
    _markDraftChanged(PricingField.minNights);
  }

  /// Otwiera edytor wpisu dla [month], używając istniejącego wpisu.
  void openMonth(int month) {
    final existing = _overrides.where((entry) => entry.month == month);
    _editingOverride = existing.isEmpty
        ? MonthOverride(
            month: month,
            weekdayPrice: _draft.weekdayPrice,
            weekendPrice: _draft.weekendPrice,
          )
        : existing.first;
    notifyListeners();
  }

  /// Zamyka edytor wpisu, odrzucając jego niezapisane zmiany.
  void closeMonth() {
    _editingOverride = null;
    notifyListeners();
  }

  /// Zmienia obie ceny otwartego wpisu.
  void updateOverridePrice({required int weekday, required int weekend}) {
    final editing = _editingOverride;
    if (editing == null) return;

    _editingOverride = editing.copyWith(
      weekdayPrice: weekday,
      weekendPrice: weekend,
    );
    _markOverrideChanged(const {
      PricingField.weekdayPrice,
      PricingField.weekendPrice,
    });
  }

  /// Włącza lub wyłącza dziedziczenie minimum ośrodka w otwartym wpisie.
  void setOverrideMinimumInherited(bool inherited) {
    final editing = _editingOverride;
    if (editing == null) return;

    _editingOverride = inherited
        ? editing.copyWith(clearMinimumNights: true)
        : editing.copyWith(
            minimumNights: editing.minimumNights ?? _draft.minNights,
          );
    _markOverrideChanged(const {PricingField.minNights});
  }

  /// Usuwa wpis miesiąca i zamyka edytor, jeśli dotyczył tego miesiąca.
  void deleteMonthOverride(int month) {
    _overrides.removeWhere((entry) => entry.month == month);
    if (_editingOverride?.month == month) {
      _editingOverride = null;
    }
    _isDirty = true;
    notifyListeners();
  }

  /// Ustawia własne minimum otwartego wpisu.
  void updateOverrideMinimum(int value) {
    final editing = _editingOverride;
    if (editing == null) return;

    _editingOverride = editing.copyWith(minimumNights: value);
    _markOverrideChanged(const {PricingField.minNights});
  }

  /// Zapisuje formularz razem z otwartym wpisem.
  ///
  /// Zwraca `false`, gdy cennik nie jest gotowy, zapis już trwa, walidacja
  /// nie przeszła albo repozytorium zgłosiło błąd. Po udanym zapisie edytor
  /// wpisu pozostaje otwarty; zamyka się tylko wtedy, gdy wpis miał wartości
  /// bazowe i nie został utworzony.
  Future<bool> save() async {
    if (_loadState != PricingLoadState.ready || _isSaving) return false;

    _isSaving = true;
    _saveError = null;
    notifyListeners();

    try {
      final errors = PricingValidator.validateDraft(_draft);
      final editing = _editingOverride;
      if (editing != null) {
        errors.addAll(PricingValidator.validateOverride(editing));
        final minimum = editing.minimumNights;
        if (minimum != null &&
            (minimum < _minOverrideNights || minimum > _maxOverrideNights)) {
          errors[PricingField.minNights] = PricingError.minNightsRange;
        }
      }
      _errors = errors;
      if (errors.isNotEmpty) return false;

      final nextOverrides = List<MonthOverride>.from(_overrides);
      if (editing != null) {
        if (editingOverrideEqualsBase) {
          nextOverrides.removeWhere((entry) => entry.month == editing.month);
          _editingOverride = null;
        } else {
          final index = nextOverrides.indexWhere(
            (entry) => entry.month == editing.month,
          );
          if (index == -1) {
            nextOverrides.add(editing);
          } else {
            nextOverrides[index] = editing;
          }
        }
      }

      final result = await _repository.save(_draft, nextOverrides);
      _savedDraft = _draft;
      _savedOverrides = List<MonthOverride>.from(nextOverrides);
      _overrides = List<MonthOverride>.from(nextOverrides);
      _lastSaveResult = result;
      _isDirty = false;
      return true;
    } catch (error) {
      _saveError = error;
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Ponawia wysyłkę do portali, które nie potwierdziły cen.
  Future<void> retrySave() async {
    final last = _lastSaveResult;
    if (last == null || _isSaving) return;

    final failedPortals = last.statuses.entries
        .where((entry) => entry.value == PortalSyncStatus.failed)
        .map((entry) => entry.key)
        .toList();
    if (failedPortals.isEmpty) return;

    var statuses = Map<Portal, PortalSyncStatus>.from(last.statuses);
    for (final portal in failedPortals) {
      final result = await _repository.retryPortal(portal);
      statuses = {...statuses, ...result.statuses};
    }

    _lastSaveResult = SaveResult(savedAt: last.savedAt, statuses: statuses);
    notifyListeners();
  }

  /// Przywraca ostatnio zapisany cennik i zamyka edytor wpisu.
  void discardChanges() {
    _draft = _savedDraft;
    _overrides = List<MonthOverride>.from(_savedOverrides);
    _editingOverride = null;
    _isDirty = false;
    _errors = {};
    _saveError = null;
    notifyListeners();
  }

  void _markDraftChanged(PricingField field) {
    _isDirty = true;
    _errors.remove(field);
    notifyListeners();
  }

  void _markOverrideChanged(Set<PricingField> fields) {
    _isDirty = true;
    _errors.removeWhere((field, _) => fields.contains(field));
    notifyListeners();
  }
}
