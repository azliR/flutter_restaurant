import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/bloc/core/failure.dart';
import 'package:flutter_restaurant/models/item/item.dart';
import 'package:flutter_restaurant/models/item/item_addon.dart';
import 'package:flutter_restaurant/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

part 'customise_food_state.dart';

@injectable
class CustomiseFoodCubit extends Cubit<CustomiseFoodState> {
  CustomiseFoodCubit(
    this._homeRepository,
  ) : super(CustomiseFoodState.initial());

  final HomeRepository _homeRepository;

  void putAddon(String id, ItemAddon addon) {
    final list = state.addonCategories.getOrDefault(id, emptyList());
    emit(
      state.copyWith(
        addonCategories: state.addonCategories.toMutableMap()
          ..put(id, list.plusElement(addon)),
      ),
    );
  }

  void switchAddon(String id, ItemAddon addon) {
    emit(
      state.copyWith(
        addonCategories: state.addonCategories.toMutableMap()
          ..put(id, listOf(addon)),
      ),
    );
  }

  void removeAddon(String id, ItemAddon addon) {
    final list = state.addonCategories.getOrDefault(id, emptyList());
    emit(
      state.copyWith(
        addonCategories: state.addonCategories.toMutableMap()
          ..put(id, list.minusElement(addon)),
      ),
    );
  }

  void addQuantity() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void minusQuantity() {
    emit(state.copyWith(quantity: max(1, state.quantity - 1)));
  }

  Future<void> getItemById({
    required String itemId,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        failure: null,
      ),
    );
    await _homeRepository.getItemById(
      itemId: itemId,
      onCompleted: (item) {
        emit(
          state.copyWith(
            item: item,
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
}
