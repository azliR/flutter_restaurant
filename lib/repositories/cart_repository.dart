import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_restaurant/bloc/cart/cart.dart';
import 'package:flutter_restaurant/bloc/core/failure.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/models/order/order.dart';
import 'package:flutter_restaurant/repositories/core/local_injectable_module.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class CartRepository {
  // Future<void> verifyCoupon({
  //   required String token,
  //   required String couponCode,
  //   required int totalAmount,
  //   required String storeId,
  //   required void Function(Discount discount, Coupon coupon) onCompleted,
  //   required void Function(Failure? failure) onError,
  // }) async {
  //   try {
  //     final uri = Uri(
  //       scheme: getIt<LocalInjectableModule>().schemeApi,
  //       host: getIt<LocalInjectableModule>().hostApi,
  //       port: getIt<LocalInjectableModule>().portApi,
  //       path: '/api/v1/user/coupons/verify',
  //     );
  //     final response = await http.post(
  //       uri,
  //       headers: {
  //         HttpHeaders.contentTypeHeader: 'application/json',
  //         HttpHeaders.authorizationHeader: 'Bearer $token',
  //       },
  //       body: jsonEncode({
  //         'coupon_code': couponCode,
  //         'total_amount': totalAmount,
  //         'store_id': storeId,
  //       }),
  //     );
  //     log(response.body);
  //     final body = jsonDecode(response.body) as Map;

  //     if (response.statusCode != 200) {
  //       onError(Failure(
  //         message: body['message'].toString(),
  //         statusCode: response.statusCode,
  //       ));
  //     } else {
  //       final discountData = body['data']['discount'] as Map;
  //       final discount = Discount.fromJson(discountData.cast());
  //       final couponData = body['data']['coupon'] as Map;
  //       final coupon = Coupon.fromJson(couponData.cast());
  //       onCompleted(discount, coupon);
  //     }
  //   } catch (e, stackTrace) {
  //     log(e.toString(), error: e, stackTrace: stackTrace);
  //     onError(Failure(message: e.toString(), error: e, stackTrace: stackTrace));
  //   }
  // }

  Future<void> updateStatusOrder({
    required String token,
    required String orderId,
    required String? status,
    required double lat,
    required double lng,
    required void Function(Order order) onCompleted,
    required void Function(Failure? failure) onError,
  }) async {
    try {
      final uri = Uri(
        scheme: getIt<LocalInjectableModule>().schemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/user/orders/id/$orderId',
      );
      final response = await http.put(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        },
        body: jsonEncode({
          "status": status,
          "lat": lat,
          "lng": lng,
        }),
      );
      log(response.body);
      final body = jsonDecode(response.body) as Map;

      if (response.statusCode != 200) {
        onError(
          Failure(
            message: body['message'].toString(),
            statusCode: response.statusCode,
          ),
        );
      } else {
        final data = body['data'] as Map;
        final order = Order.fromJson(data.cast());
        onCompleted(order);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString(), error: e, stackTrace: stackTrace));
    }
  }

  Future<void> placeOrder({
    required String token,
    required String storeId,
    required String orderType,
    required String pickupType,
    required String? couponCode,
    required int? scheduleAt,
    required List<Cart> items,
    required void Function(Order order) onCompleted,
    required void Function(Failure? failure) onError,
  }) async {
    try {
      final uri = Uri(
        scheme: getIt<LocalInjectableModule>().schemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/user/order',
      );
      final response = await http.post(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({
          'store_id': storeId,
          'order_type': orderType,
          'pickup_type': pickupType,
          'coupon': couponCode,
          'schedule_at': scheduleAt,
          'items': items.map((item) => item.toOrderJson()).toList(),
        }),
      );
      final body = jsonDecode(response.body) as Map;

      if (response.statusCode != 200) {
        final message = body['message'].toString();
        log(message);
        onError(
          Failure(
            message: message,
            statusCode: response.statusCode,
          ),
        );
      } else {
        final data = body['data'] as Map;
        final order = Order.fromJson(data.cast());
        onCompleted(order);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString(), error: e, stackTrace: stackTrace));
    }
  }
}
