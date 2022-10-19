part of 'map_cubit.dart';

class MapState extends Equatable {
  const MapState({
    required this.stores,
    required this.isLoading,
    required this.failure,
  });

  final List<NearbyStore> stores;
  final bool isLoading;
  final Failure? failure;

  static const _defaultFailure = Failure(message: '');

  factory MapState.initial() => const MapState(
        stores: [],
        isLoading: false,
        failure: null,
      );

  MapState copyWith({
    List<NearbyStore>? stores,
    bool? isLoading,
    Failure? failure = _defaultFailure,
  }) {
    return MapState(
      stores: stores ?? this.stores,
      isLoading: isLoading ?? this.isLoading,
      failure: failure == _defaultFailure ? this.failure : failure,
    );
  }

  @override
  List<Object?> get props => [stores, isLoading, failure];
}
