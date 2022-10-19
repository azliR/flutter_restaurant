import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/models/item/item_addon.dart';
import 'package:kt_dart/kt.dart';

@immutable
class Cart extends Equatable {
  const Cart({
    required this.itemId,
    required this.itemName,
    required this.picture,
    required this.quantity,
    required this.price,
    required this.isAvailable,
    required this.itemAddon,
  });

  final String itemId;
  final String itemName;
  final String? picture;
  final int quantity;
  final double price;
  final bool isAvailable;
  final KtList<ItemAddon> itemAddon;

  double get totalAmount {
    return (price * quantity) + itemAddon.sumBy((e) => e.price ?? 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'picture': picture,
      'quantity': quantity,
      'price': price,
      'extras': itemAddon.map((x) => x.toJson()).asList(),
    };
  }

  Map<String, dynamic> toOrderJson() {
    return {
      'item_id': itemId,
      'quantity': quantity,
      'extras': itemAddon.map((x) => x.toOrderJson()).asList(),
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      itemId: map['itemId'] as String,
      itemName: map['itemName'] as String,
      picture: map['picture'] as String?,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
      isAvailable: map['isAvailable'] as bool,
      itemAddon: (map['itemAddon'] as List?)
              ?.map(
                (x) => ItemAddon.fromJson((x as Map).cast()),
              )
              .toImmutableList() ??
          emptyList(),
    );
  }
  Cart copyWith({
    String? itemId,
    String? itemName,
    String? picture,
    int? quantity,
    double? price,
    bool? isAvailable,
    KtList<ItemAddon>? itemAddon,
  }) {
    return Cart(
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      picture: picture ?? this.picture,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      itemAddon: itemAddon ?? this.itemAddon,
    );
  }

  @override
  List<Object?> get props {
    return [
      itemId,
      itemName,
      picture,
      quantity,
      price,
      itemAddon,
      isAvailable,
    ];
  }
}
