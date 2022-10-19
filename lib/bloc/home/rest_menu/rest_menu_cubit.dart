import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/bloc/core/failure.dart';
import 'package:flutter_restaurant/models/item/item_by_store.dart';
import 'package:flutter_restaurant/models/item/item_sub_category.dart';
import 'package:flutter_restaurant/models/store/store.dart';
import 'package:flutter_restaurant/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

part 'rest_menu_state.dart';

@injectable
class RestMenuCubit extends Cubit<RestMenuState> {
  RestMenuCubit(
    this._homeRepository,
  ) : super(RestMenuState.initial());

  final HomeRepository _homeRepository;

  void selectCategory(ItemSubCategory? subCategory) {
    emit(state.copyWith(itemSubCategory: subCategory));
  }

  Future<void> getStoreById({
    required String storeId,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        failure: null,
      ),
    );
    await _homeRepository.getStoreById(
      storeId: storeId,
      onCompleted: (store) {
        emit(
          state.copyWith(
            store: store,
            isLoading: false,
          ),
        );
      },
      onError: (failure) {
        emit(
          state.copyWith(
            failure: failure,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> getItemsByStore({
    required String storeId,
    required int pageKey,
    required int pageLimit,
    required void Function(List<ItemByStore> itemsByStores) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    await _homeRepository.getItemsByStoreId(
      storeId: storeId,
      page: pageKey ~/ pageLimit + 1,
      pageLimit: pageLimit,
      subCategoryId: state.itemSubCategory?.id,
      onCompleted: onCompleted,
      onError: onError,
    );
  }

  Future<void> getSubCategories({
    required String storeId,
    required int pageKey,
    required int pageLimit,
    required String? languageCode,
    required void Function(List<ItemSubCategory> categories) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    await _homeRepository.getSubCategories(
      storeId: storeId,
      page: pageKey ~/ pageLimit + 1,
      pageLimit: pageLimit,
      languageCode: languageCode,
      onCompleted: onCompleted,
      onError: onError,
    );
  }
}
