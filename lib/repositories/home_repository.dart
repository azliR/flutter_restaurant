import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_restaurant/bloc/core/failure.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/models/item.dart';
import 'package:flutter_restaurant/models/item_category.dart';
import 'package:flutter_restaurant/models/item_sub_category.dart';
import 'package:flutter_restaurant/models/nearby_store.dart';
import 'package:flutter_restaurant/models/store.dart';
import 'package:flutter_restaurant/repositories/core/local_injectable_module.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class HomeRepository {
  final _geolocatorPlatform = GeolocatorPlatform.instance;

  Future<LocationPermission> checkLocationPermission() async {
    return _geolocatorPlatform.checkPermission();
  }

  Future<void> determinePosition({
    required void Function(Position position) onCompleted,
    required void Function(Failure message) onError,
  }) async {
    try {
      var permission = await checkLocationPermission();
      if (permission == LocationPermission.denied) {
        permission = await _geolocatorPlatform.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return onError(
          const Failure(
            message:
                'Location permissions are permanently denied, we cannot request permissions',
          ),
        );
      }
      onCompleted(await _geolocatorPlatform.getCurrentPosition());
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString()));
    }
  }

  Future<void> getCategories({
    required int page,
    required int pageLimit,
    required void Function(List<ItemCategory> categories) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    try {
      final uri = Uri(
        scheme: getIt<LocalInjectableModule>().kSchemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/user/category/all',
        queryParameters: {
          'page': page.toString(),
          'pageLimit': pageLimit.toString(),
        },
      );
      final response = await http.get(uri);
      final body = jsonDecode(response.body) as Map;

      if (response.statusCode != 200) {
        onError(
          Failure(
            message: body['message'].toString(),
            statusCode: response.statusCode,
          ),
        );
      } else {
        final list = (body['data'] as List).cast<Map>();
        final categories =
            list.map((data) => ItemCategory.fromJson(data.cast())).toList();
        onCompleted(categories);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString()));
    }
  }

  Future<void> getSubCategories({
    required String storeId,
    required int page,
    required int pageLimit,
    required String? key,
    required void Function(List<ItemSubCategory> subCategories) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    try {
      final uri = Uri(
        scheme: getIt<LocalInjectableModule>().kSchemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/user/subcategory/all',
        queryParameters: {
          'id': storeId,
          'page': page.toString(),
          'pageLimit': pageLimit.toString(),
          'key': key,
        },
      );
      final response = await http.get(uri);
      final body = jsonDecode(response.body) as Map;

      if (response.statusCode != 200) {
        onError(
          Failure(
            message: body['message'].toString(),
            statusCode: response.statusCode,
          ),
        );
      } else {
        final list = (body['data'] as List).cast<Map>();
        final subCategories =
            list.map((data) => ItemSubCategory.fromJson(data.cast())).toList();
        onCompleted(subCategories);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString()));
    }
  }

  Future<void> getNearbyStores({
    required double latitude,
    required double longitude,
    required int limit,
    required void Function(List<NearbyStore> nearbyStores) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    try {
      final uri = Uri(
        scheme: getIt<LocalInjectableModule>().kSchemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/home/nearby',
        queryParameters: {
          // 'lat': latitude.toString(),
          // 'lng': longitude.toString(),
          'lat': (-6.9311436).toString(),
          'lng': 107.7177563.toString(),
          'page_limit': limit.toString(),
        },
      );
      final response = await http.get(uri);
      final body = jsonDecode(response.body) as Map;

      if (response.statusCode != 200) {
        onError(
          Failure(
            message: body['message'].toString(),
            statusCode: response.statusCode,
          ),
        );
      } else {
        final list = (body['data'] as List).cast<Map>();
        final nearbyStores =
            list.map((data) => NearbyStore.fromJson(data.cast())).toList();
        onCompleted(nearbyStores);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString()));
    }
  }

  // Future<void> getNearbyItems({
  //   required double latitude,
  //   required double longitude,
  //   required String? categoryId,
  //   required String? subCategoryId,
  //   required int limit,
  //   required void Function(List<NearbyItem> nearbyItems) onCompleted,
  //   required void Function(Failure failure) onError,
  // }) async {
  //   try {
  //     final uri = Uri(
  //       scheme: kScheme,
  //       host: getIt<LocalInjectableModule>().hostApi,
  // port: getIt<LocalInjectableModule>().portApi,
  //       path: '/api/v1/user/home/nearby_item',
  //       queryParameters: {
  //         'lat': latitude.toString(),
  //         'lng': longitude.toString(),
  //         'limit': limit.toString(),
  //         'category_id': categoryId,
  //         'subCategory_id': subCategoryId,
  //         // 'lat': '-7.871463',
  //         // 'lng': '112.506801',
  //         // 'limit': limit.toString(),
  //         // 'category_id': categoryId,
  //         // 'subCategory_id': subCategoryId,
  //       },
  //     );
  //     final response = await http.get(uri);
  //     final body = jsonDecode(response.body) as Map;

  //     if (response.statusCode != 200) {
  //       onError(
  //         Failure(
  //           message: body['message'].toString(),
  //           statusCode: response.statusCode,
  //         ),
  //       );
  //     } else {
  //       final list = (body['data'] as List).cast<Map>();
  //       final nearbyItems =
  //           list.map((data) => NearbyItem.fromJson(data.cast())).toList();
  //       onCompleted(nearbyItems);
  //     }
  //   } catch (e, stackTrace) {
  //     log(e.toString(), error: e, stackTrace: stackTrace);
  //     onError(Failure(message: e.toString()));
  //   }
  // }

  Future<void> getSpecialOffers({
    required double latitude,
    required double longitude,
    required int limit,
    required void Function(List<Item> specialOffers) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    try {
      final module = getIt<LocalInjectableModule>();
      final uri = Uri(
        scheme: module.kSchemeApi,
        host: module.hostApi,
        port: module.portApi,
        path: '/api/v1/home/special',
        queryParameters: {
          // 'lat': latitude.toString(),
          // 'lng': longitude.toString(),
          'lat': (-6.9311436).toString(),
          'lng': 107.7177563.toString(),
          'page_limit': limit.toString(),
        },
      );
      final response = await http.get(uri);
      final body = jsonDecode(response.body) as Map;

      if (response.statusCode != 200) {
        onError(
          Failure(
            message: body['message'].toString(),
            statusCode: response.statusCode,
          ),
        );
      } else {
        final list = (body['data'] as List).cast<Map>();
        final specialOffers =
            list.map((data) => Item.fromJson(data.cast())).toList();
        onCompleted(specialOffers);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString(), error: e, stackTrace: stackTrace));
    }
  }

  Future<void> getStoreById({
    required String storeId,
    required void Function(Store store) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    try {
      final uri = Uri(
        scheme: getIt<LocalInjectableModule>().kSchemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/user/store/id/$storeId',
      );
      final response = await http.get(uri);
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
        final store = Store.fromJson(data.cast());
        onCompleted(store);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString()));
    }
  }

  Future<void> getStores({
    required int limit,
    required void Function(List<Store> stores) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    try {
      final uri = Uri(
        scheme: getIt<LocalInjectableModule>().kSchemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/user/store',
        queryParameters: {
          // 'key': null,
          'page': '1',
          'pageLimit': limit.toString(),
        },
      );
      final response = await http.get(uri);
      final body = jsonDecode(response.body) as Map;

      if (response.statusCode != 200) {
        onError(
          Failure(
            message: body['message'].toString(),
            statusCode: response.statusCode,
          ),
        );
      } else {
        final list = (body['data'] as List).cast<Map>();
        final stores = list.map((data) => Store.fromJson(data.cast())).toList();
        onCompleted(stores);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString()));
    }
  }

  Future<void> getItemsByStoreId({
    required int page,
    required int pageLimit,
    required String storeId,
    required String? key,
    required String? categoryId,
    required String? subCategory,
    required void Function(List<Item> itemsByStores) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    try {
      final uri = Uri(
        scheme: getIt<LocalInjectableModule>().kSchemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/user/item/store/$storeId',
        queryParameters: {
          'page': page.toString(),
          'pageLimit': pageLimit.toString(),
          'key': key,
          'category_id': categoryId,
          'sub_category': subCategory,
        },
      );
      final response = await http.get(uri);
      final body = jsonDecode(response.body) as Map;

      if (response.statusCode != 200) {
        onError(
          Failure(
            message: body['message'].toString(),
            statusCode: response.statusCode,
          ),
        );
      } else {
        final list = (body['data'] as List).cast<Map>();
        final items = list.map((data) => Item.fromJson(data.cast())).toList();
        onCompleted(items);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString()));
    }
  }

  Future<void> getItemById({
    required String itemId,
    required void Function(Item store) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    try {
      final uri = Uri(
        scheme: getIt<LocalInjectableModule>().kSchemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/user/item/id/$itemId',
      );
      final response = await http.get(uri);
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
        final item = Item.fromJson(data.cast());
        onCompleted(item);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString()));
    }
  }

  Future<void> updateFcmToken({
    required String token,
    required String storeId,
    required void Function() onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    try {
      final uri = Uri(
        scheme: getIt<LocalInjectableModule>().kSchemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/user/fcm',
      );
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: token,
        },
      );
      final body = jsonDecode(response.body) as Map;

      if (response.statusCode != 200) {
        onError(
          Failure(
            message: body['message'].toString(),
            statusCode: response.statusCode,
          ),
        );
      } else {
        // final data = body['data'] as Map;
        onCompleted();
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(Failure(message: e.toString()));
    }
  }
}
