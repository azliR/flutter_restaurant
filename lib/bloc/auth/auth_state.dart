part of 'auth_cubit.dart';

enum AuthStatus { authorised, needCompletion, unauthorised }

@immutable
class AuthState extends Equatable {
  const AuthState({
    this.authToken,
    this.userData,
    required this.isLoading,
    this.errorMessage,
    this.infoMessage,
    required this.authStatus,
    required this.isSkipped,
  });

  final AuthToken? authToken;
  final UserData? userData;
  final bool isLoading;
  final String? errorMessage;
  final String? infoMessage;
  final AuthStatus authStatus;
  final bool isSkipped;

  static const _defaultInfoMessage = '';
  static const _defaultErrorMessage = '';

  factory AuthState.initial() => const AuthState(
        isLoading: false,
        isSkipped: false,
        authStatus: AuthStatus.unauthorised,
      );

  Map<String, dynamic> toJson() {
    return {
      'authStatus': authStatus.name,
      'authToken': authToken?.toJson(),
      'userData': userData?.toJson(),
      'isSkipped': isSkipped,
    };
  }

  factory AuthState.fromJson(Map<String, dynamic> map) {
    final authStatus = AuthStatus.values.firstWhere(
      (status) => status.name == map['authStatus'],
      orElse: () => AuthStatus.unauthorised,
    );
    final authTokenMap = map['authToken'] as Map?;
    final userDataMap = map['userData'] as Map?;

    return AuthState.initial().copyWith(
      authStatus: authStatus,
      authToken: optionOf(
        authTokenMap != null ? AuthToken.fromJson(authTokenMap.cast()) : null,
      ),
      userData: optionOf(
        userDataMap != null ? UserData.fromJson(userDataMap.cast()) : null,
      ),
      isSkipped: map['isSkipped'] as bool? ?? false,
    );
  }

  AuthState copyWith({
    Option<AuthToken?>? authToken,
    Option<UserData?>? userData,
    bool? isLoading,
    String? errorMessage = _defaultErrorMessage,
    String? infoMessage = _defaultInfoMessage,
    AuthStatus? authStatus,
    bool? isSkipped,
  }) {
    return AuthState(
      authToken:
          authToken != null ? authToken.getOrElse(() => null) : this.authToken,
      userData:
          userData != null ? userData.getOrElse(() => null) : this.userData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _defaultErrorMessage
          ? this.errorMessage
          : errorMessage,
      infoMessage:
          infoMessage == _defaultInfoMessage ? this.infoMessage : infoMessage,
      authStatus: authStatus ?? this.authStatus,
      isSkipped: isSkipped ?? this.isSkipped,
    );
  }

  @override
  List<Object?> get props {
    return [
      authToken,
      userData,
      isLoading,
      errorMessage,
      infoMessage,
      authStatus,
      isSkipped,
    ];
  }
}
