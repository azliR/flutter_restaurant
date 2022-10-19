import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class UserData extends Equatable {
  const UserData({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.languageCode,
    required this.createdAt,
  });

  final String id;
  final String fullName;
  final String phone;
  final String languageCode;
  final DateTime createdAt;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'] as String,
        fullName: json['full_name'] as String,
        phone: json['phone'] as String,
        languageCode: json['language_code'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  UserData copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? languageCode,
    DateTime? createdAt,
  }) {
    return UserData(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      languageCode: languageCode ?? this.languageCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'phone': phone,
        'language_code': languageCode,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props {
    return [
      id,
      fullName,
      phone,
      languageCode,
      createdAt,
    ];
  }
}
