part of 'preferences_cubit.dart';

@immutable
class PreferencesState extends Equatable {
  const PreferencesState({
    required this.isFirstLaunch,
    this.locale,
    this.position,
  });

  final bool isFirstLaunch;
  final Locale? locale;
  final Position? position;

  static const _defaultString = '';

  factory PreferencesState.initial() => const PreferencesState(isFirstLaunch: true);

  PreferencesState copyWith({
    bool? isFirstLaunch,
    Locale? locale,
    Position? position,
    String? errorMessage = _defaultString,
  }) {
    return PreferencesState(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      locale: locale ?? this.locale,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isFirstLaunch': isFirstLaunch,
      'locale': locale?.languageCode,
      'position': position?.toJson(),
    };
  }

  factory PreferencesState.fromMap(Map<String, dynamic> map) {
    return PreferencesState(
      isFirstLaunch: (map['isFirstLaunch'] as bool?) ?? true,
      locale: map['locale'] == null ? null : Locale(map['locale'] as String),
      position:
          map['position'] != null ? Position.fromMap(map['position']) : null,
    );
  }

  @override
  List<Object?> get props => [
        isFirstLaunch,
        locale,
        position,
      ];
}
