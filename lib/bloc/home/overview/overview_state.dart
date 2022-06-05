part of 'overview_cubit.dart';

@immutable
class HomeState extends Equatable {
  const HomeState({
    required this.selectedCategory,
    this.failureOrNearbyStores,
    this.failureOrSpecialOffers,
    required this.failure,
    required this.isLoading,
  });

  final ItemCategory? selectedCategory;
  final Either<Failure, List<NearbyStore>>? failureOrNearbyStores;
  final Either<Failure, List<Item>>? failureOrSpecialOffers;
  final Failure? failure;
  final bool isLoading;

  static const _defaultFailure = Failure(message: '');

  factory HomeState.initial() => const HomeState(
        selectedCategory: null,
        failure: null,
        isLoading: false,
      );

  HomeState copyWith({
    ItemCategory? selectedCategory = const ItemCategory(id: '', name: ''),
    Option<Either<Failure, List<NearbyStore>>?>? failureOrNearbyStores,
    Option<Either<Failure, List<Item>>?>? failureOrSpecialOffers,
    Failure? failure = _defaultFailure,
    bool? isLoading,
  }) {
    return HomeState(
      selectedCategory: selectedCategory == const ItemCategory(id: '', name: '')
          ? this.selectedCategory
          : selectedCategory,
      failureOrNearbyStores: failureOrNearbyStores != null
          ? failureOrNearbyStores.getOrElse(() => null)
          : this.failureOrNearbyStores,
      failureOrSpecialOffers: failureOrSpecialOffers != null
          ? failureOrSpecialOffers.getOrElse(() => null)
          : this.failureOrSpecialOffers,
      failure: failure ?? this.failure,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        selectedCategory,
        failureOrNearbyStores,
        failureOrSpecialOffers,
        failure,
        isLoading,
      ];
}
