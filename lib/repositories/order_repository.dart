import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:drivo/bloc/core/constants.dart';
import 'package:drivo/bloc/core/failure.dart';
import 'package:drivo/bloc/core/local_injectable_module.dart';
import 'package:drivo/injection.dart';
import 'package:drivo/models/order/order.dart';
import 'package:drivo/models/order/orders.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class OrderRepository {
  Future<void> getOrders({
    required String token,
    required int page,
    required int pageLimit,
    String? key,
    String? status,
    required void Function(List<Orders> orders) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    try {
      final uri = Uri(
        scheme: kScheme,
        host: getIt<LocalInjectableModule>().host,
        path: '/api/v1/user/orders',
        queryParameters: {
          'page': page.toString(),
          'pageLimit': pageLimit.toString(),
          'key': key,
          'status': status,
        },
      );
      final response = await http.get(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      final body = jsonDecode(response.body) as Map;
      log(body.toString());
      if (response.statusCode != 200) {
        onError(Failure(
          message: body['message'].toString(),
          statusCode: response.statusCode,
        ));
      } else {
        final list = (body['data'] as List).cast<Map>();
        final orders =
            list.map((data) => Orders.fromJson(data.cast())).toList();
        onCompleted(orders);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString()));
    }
  }

  Future<void> getOrderById({
    required String token,
    required String orderId,
    required void Function(Order order) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    try {
      final uri = Uri(
        scheme: kScheme,
        host: getIt<LocalInjectableModule>().host,
        path: '/api/v1/user/orders/id/$orderId',
      );
      final response = await http.get(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      final body = jsonDecode(response.body) as Map;

      if (response.statusCode != 200) {
        onError(Failure(
          message: body['message'].toString(),
          statusCode: response.statusCode,
        ));
      } else {
        final data = body['data'] as Map;
        final order = Order.fromJson(data.cast());
        onCompleted(order);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString()));
    }
  }
}
