part of 'preferences_cubit.dart';

@immutable
class PreferencesState extends Equatable {
  const PreferencesState({
    required this.locale,
  });

  final Locale locale;

  factory PreferencesState.initial() => PreferencesState(
        locale: Locale(Platform.localeName),
      );

  PreferencesState copyWith({
    Locale? locale,
  }) {
    return PreferencesState(
      locale: locale ?? this.locale,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locale': locale.languageCode,
    };
  }

  factory PreferencesState.fromMap(Map<String, dynamic> map) {
    return PreferencesState(
      locale: Locale(map['locale'] as String),
    );
  }

  @override
  List<Object?> get props => [
        locale,
      ];
}
