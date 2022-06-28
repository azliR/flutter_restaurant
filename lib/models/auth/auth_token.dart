import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthToken extends Equatable {
  const AuthToken({
    required this.token,
    required this.tokenExpiresIn,
    required this.refreshToken,
    required this.refreshTokenExpiresIn,
  });

  final String token;
  final DateTime tokenExpiresIn;
  final String refreshToken;
  final DateTime refreshTokenExpiresIn;

  factory AuthToken.initial() => AuthToken(
        token: '',
        tokenExpiresIn: DateTime.now(),
        refreshToken: '',
        refreshTokenExpiresIn: DateTime.now(),
      );

  factory AuthToken.fromJson(Map<String, dynamic> json) => AuthToken(
        token: json['token'] as String,
        tokenExpiresIn:
            DateTime.parse(json['token_expires_in'] as String).toLocal(),
        refreshToken: json['refresh_token'] as String,
        refreshTokenExpiresIn:
            DateTime.parse(json['refresh_token_expires_in'] as String)
                .toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'token_expires_in': tokenExpiresIn.toIso8601String(),
        'refresh_token': refreshToken,
        'refresh_token_expires_in': refreshTokenExpiresIn.toIso8601String(),
      };

  @override
  List<Object?> get props {
    return [
      token,
      tokenExpiresIn,
      refreshToken,
      refreshTokenExpiresIn,
    ];
  }
}
