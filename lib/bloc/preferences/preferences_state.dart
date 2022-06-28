part of 'preferences_cubit.dart';

@immutable
class PreferencesState extends Equatable {
  const PreferencesState({
    required this.isFirstLaunch,
    required this.themeMode,
    this.locale,
    this.position,
  });

  final bool isFirstLaunch;
  final ThemeMode themeMode;
  final Locale? locale;
  final Position? position;

  static const _defaultString = '';

  factory PreferencesState.initial() => const PreferencesState(
        isFirstLaunch: true,
        themeMode: ThemeMode.system,
      );

  PreferencesState copyWith({
    bool? isFirstLaunch,
    ThemeMode? themeMode,
    Locale? locale,
    Position? position,
    String? errorMessage = _defaultString,
  }) {
    return PreferencesState(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isFirstLaunch': isFirstLaunch,
      'themeMode': themeMode.index,
      'locale': locale?.languageCode,
      'position': position?.toJson(),
    };
  }

  factory PreferencesState.fromMap(Map<String, dynamic> map) {
    return PreferencesState(
      isFirstLaunch: (map['isFirstLaunch'] as bool?) ?? true,
      themeMode: ThemeMode.values[(map['themeMode'] as int?) ?? 0],
      locale: map['locale'] == null ? null : Locale(map['locale'] as String),
      position:
          map['position'] != null ? Position.fromMap(map['position']) : null,
    );
  }

  @override
  List<Object?> get props => [
        isFirstLaunch,
        themeMode,
        locale,
        position,
      ];
}
