import 'package:equatable/equatable.dart';
import 'package:flutter_restaurant/models/order/order_detail_addon.dart';
import 'package:meta/meta.dart';

@immutable
class OrderDetail extends Equatable {
  const OrderDetail({
    required this.id,
    required this.orderId,
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.total,
    this.picture,
    this.itemDetail,
    this.rating,
    this.comment,
    required this.addons,
  });

  final String id;
  final String orderId;
  final String itemId;
  final String itemName;
  final int quantity;
  final double price;
  final double total;
  final String? picture;
  final String? itemDetail;
  final double? rating;
  final String? comment;
  final List<OrderDetailAddon>? addons;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json['id'] as String,
        orderId: json['order_id'] as String,
        itemId: json['item_id'] as String,
        itemName: json['item_name'] as String,
        quantity: json['quantity'] as int,
        price: json['price'] as double,
        total: json['total'] as double,
        picture: json['picture'] as String?,
        itemDetail: json['item_detail'] as String?,
        rating: json['rating'] as double?,
        comment: json['comment'] as String?,
        addons: (json['addons'] as List<dynamic>?)
            ?.map((e) => OrderDetailAddon.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'item_id': itemId,
        'item_name': itemName,
        'quantity': quantity,
        'price': price,
        'total': total,
        'picture': picture,
        'item_detail': itemDetail,
        'rating': rating,
        'comment': comment,
        'addons': addons?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props {
    return [
      id,
      orderId,
      itemId,
      itemName,
      quantity,
      price,
      total,
      picture,
      itemDetail,
      rating,
      comment,
      addons,
    ];
  }
}
