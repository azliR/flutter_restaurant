import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ItemAddon extends Equatable {
  const ItemAddon({
    required this.id,
    required this.addonCategoryId,
    required this.name,
    this.price,
  });

  final String id;
  final String addonCategoryId;
  final String name;
  final double? price;

  factory ItemAddon.fromJson(Map<String, dynamic> json) => ItemAddon(
        id: json['id'] as String,
        addonCategoryId: json['addon_category_id'] as String,
        name: json['name'] as String,
        price: json['price'] as double?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'addon_category_id': addonCategoryId,
        'name': name,
        'price': price,
      };

  Map<String, dynamic> toOrderJson() => {
        'addon_id': id,
      };

  @override
  List<Object?> get props => [id, addonCategoryId, name, price];
}
