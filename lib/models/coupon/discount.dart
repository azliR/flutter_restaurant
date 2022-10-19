import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Discount extends Equatable {
  const Discount({
    this.totalAmount,
    this.discPercent,
    this.discAmount,
    this.amountAfterDisc,
  });

  final int? totalAmount;
  final int? discPercent;
  final double? discAmount;
  final double? amountAfterDisc;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        totalAmount: json['total_amount'] as int?,
        discPercent: json['disc_percent'] as int?,
        discAmount: (json['disc_amount'] as num?)?.toDouble(),
        amountAfterDisc: (json['amount_after_disc'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'total_amount': totalAmount,
        'disc_percent': discPercent,
        'disc_amount': discAmount,
        'amount_after_disc': amountAfterDisc,
      };

  @override
  List<Object?> get props {
    return [
      totalAmount,
      discPercent,
      discAmount,
      amountAfterDisc,
    ];
  }
}
