import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Store extends Equatable {
  const Store({
    required this.id,
    required this.storeAdminId,
    required this.name,
    this.description,
    this.image,
    this.banner,
    required this.phone,
    required this.streetAddress,
    required this.postcode,
    required this.latitude,
    required this.longitude,
    this.rating,
    required this.isActive,
    required this.city,
    required this.state,
    required this.country,
  });

  final String id;
  final String storeAdminId;
  final String name;
  final String? description;
  final String? image;
  final String? banner;
  final String phone;
  final String streetAddress;
  final String postcode;
  final double latitude;
  final double longitude;
  final double? rating;
  final bool isActive;
  final String city;
  final String state;
  final String country;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json['id'] as String,
        storeAdminId: json['store_admin_id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        image: json['image'] as String?,
        banner: json['banner'] as String?,
        phone: json['phone'] as String,
        streetAddress: json['street_address'] as String,
        postcode: json['postcode'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        rating: json['rating'] as double?,
        isActive: json['is_active'] as bool,
        city: json['city'] as String,
        state: json['state'] as String,
        country: json['country'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'store_admin_id': storeAdminId,
        'name': name,
        'description': description,
        'image': image,
        'banner': banner,
        'phone': phone,
        'street_address': streetAddress,
        'postcode': postcode,
        'latitude': latitude,
        'longitude': longitude,
        'rating': rating,
        'is_active': isActive,
        'city': city,
        'state': state,
        'country': country,
      };

  @override
  List<Object?> get props {
    return [
      id,
      storeAdminId,
      name,
      description,
      image,
      banner,
      phone,
      streetAddress,
      postcode,
      latitude,
      longitude,
      rating,
      isActive,
      city,
      state,
      country,
    ];
  }
}
