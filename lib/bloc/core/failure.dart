import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Failure extends Equatable {
  const Failure({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}
