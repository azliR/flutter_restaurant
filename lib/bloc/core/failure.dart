import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Failure extends Equatable {
  const Failure({
    required this.message,
    this.error,
    this.stackTrace,
    this.statusCode,
  });

  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final int? statusCode;

  @override
  List<Object?> get props => [
        message,
        error,
        stackTrace,
        statusCode,
      ];
}
