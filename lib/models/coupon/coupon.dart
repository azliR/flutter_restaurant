import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Coupon extends Equatable {
  const Coupon({
    this.id,
    this.name,
    this.description,
    this.couponCode,
    this.discountType,
    this.discount,
    this.maxDiscount,
    this.expiryDate,
    this.allStore,
    this.maxNumberUseTotal,
    this.minimalTotal,
    this.couponUserType,
    this.maxNumberUseUser,
    this.valid,
    this.createdAt,
    this.insertedBy,
    this.status,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? couponCode;
  final int? discountType;
  final int? discount;
  final int? maxDiscount;
  final String? expiryDate;
  final bool? allStore;
  final int? maxNumberUseTotal;
  final int? minimalTotal;
  final int? couponUserType;
  final int? maxNumberUseUser;
  final bool? valid;
  final String? createdAt;
  final String? insertedBy;
  final bool? status;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json['id'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        couponCode: json['coupon_code'] as String?,
        discountType: json['discount_type'] as int?,
        discount: json['discount'] as int?,
        maxDiscount: json['max_discount'] as int?,
        expiryDate: json['expiry_date'] as String?,
        allStore: json['all_store'] as bool?,
        maxNumberUseTotal: json['max_number_use_total'] as int?,
        minimalTotal: json['minimal_total'] as int?,
        couponUserType: json['coupon_user_type'] as int?,
        maxNumberUseUser: json['max_number_use_user'] as int?,
        valid: json['valid'] as bool?,
        createdAt: json['created_at'] as String?,
        insertedBy: json['inserted_by'] as String?,
        status: json['status'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'coupon_code': couponCode,
        'discount_type': discountType,
        'discount': discount,
        'max_discount': maxDiscount,
        'expiry_date': expiryDate,
        'all_store': allStore,
        'max_number_use_total': maxNumberUseTotal,
        'minimal_total': minimalTotal,
        'coupon_user_type': couponUserType,
        'max_number_use_user': maxNumberUseUser,
        'valid': valid,
        'created_at': createdAt,
        'inserted_by': insertedBy,
        'status': status,
      };

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      couponCode,
      discountType,
      discount,
      maxDiscount,
      expiryDate,
      allStore,
      maxNumberUseTotal,
      minimalTotal,
      couponUserType,
      maxNumberUseUser,
      valid,
      createdAt,
      insertedBy,
      status,
    ];
  }
}
