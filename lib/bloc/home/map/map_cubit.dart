import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_restaurant/bloc/core/failure.dart';
import 'package:flutter_restaurant/models/home/nearby_store.dart';
import 'package:flutter_restaurant/repositories/home_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

part 'map_state.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  MapCubit(this._homeRepository) : super(MapState.initial());

  final HomeRepository _homeRepository;

  Future<void> determinePosition({
    required void Function(Position) onCompleted,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        failure: null,
      ),
    );
    await _homeRepository.determinePosition(
      onCompleted: (position) {
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

  Future<void> getNearbyStores({
    required double lat,
    required double lng,
  }) async {
    emit(state.copyWith(isLoading: true));
    await _homeRepository.getNearbyStores(
      latitude: lat,
      longitude: lng,
      limit: 100,
      onCompleted: (stores) {
        emit(
          state.copyWith(
            isLoading: false,
            stores: stores,
          ),
        );
      },
      onError: (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            failure: failure,
          ),
        );
      },
    );
  }

  Future<void> getNearbyStoresRoute({
    required List<MapLatLng> routes,
  }) async {
    emit(state.copyWith(isLoading: true));
    await _homeRepository.getNearbyStores(
      // routes: routes,
      latitude: routes[0].latitude,
      longitude: routes[0].longitude,
      limit: 100,
      onCompleted: (stores) {
        emit(
          state.copyWith(
            isLoading: false,
            stores: stores,
          ),
        );
      },
      onError: (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            failure: failure,
          ),
        );
      },
    );
  }
}
