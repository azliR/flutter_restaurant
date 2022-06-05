import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_restaurant/bloc/core/failure.dart';
import 'package:flutter_restaurant/models/item.dart';
import 'package:flutter_restaurant/models/item_category.dart';
import 'package:flutter_restaurant/models/nearby_store.dart';
import 'package:flutter_restaurant/repositories/home_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

part 'overview_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._homeRepository,
  ) : super(HomeState.initial());

  final HomeRepository _homeRepository;

  Future<void> initialise({
    required Position? position,
  }) async {
    if (position != null) {
      getNearbyStores(position: position);
      getSpecialOffers(position: position);
    }
  }

  Future<void> determinePosition({
    required void Function(Position position) onCompleted,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        failure: null,
      ),
    );
    await _homeRepository.determinePosition(
      onCompleted: (position) async {
        onCompleted(position);
        emit(state.copyWith(isLoading: false));
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

  void selectCategory(ItemCategory? category) {
    emit(state.copyWith(selectedCategory: category));
  }

  Future<void> getNearbyStores({required Position position}) async {
    emit(
      state.copyWith(
        failureOrNearbyStores: none(),
      ),
    );
    await _homeRepository.getNearbyStores(
      latitude: position.latitude,
      longitude: position.longitude,
      limit: 15,
      onCompleted: (nearbyStores) {
        emit(
          state.copyWith(
            failureOrNearbyStores: optionOf(right(nearbyStores)),
          ),
        );
      },
      onError: (failure) {
        emit(
          state.copyWith(
            failureOrNearbyStores: optionOf(left(failure)),
          ),
        );
      },
    );
  }

  Future<void> getSpecialOffers({required Position position}) async {
    emit(
      state.copyWith(
        failureOrSpecialOffers: none(),
      ),
    );
    await _homeRepository.getSpecialOffers(
      latitude: position.latitude,
      longitude: position.longitude,
      limit: 15,
      onCompleted: (specialOffers) {
        emit(
          state.copyWith(
            failureOrSpecialOffers: optionOf(right(specialOffers)),
          ),
        );
      },
      onError: (failure) {
        emit(
          state.copyWith(
            failureOrSpecialOffers: optionOf(left(failure)),
          ),
        );
      },
    );
  }

  Future<void> getCategories({
    required int pageKey,
    required int pageLimit,
    required void Function(List<ItemCategory> categories) onCompleted,
    required void Function(Failure failure) onError,
  }) async {
    await _homeRepository.getCategories(
      page: pageKey ~/ pageLimit + 1,
      pageLimit: pageLimit,
      onCompleted: onCompleted,
      onError: onError,
    );
  }
}
