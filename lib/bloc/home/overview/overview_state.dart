part of 'overview_cubit.dart';

@immutable
class OverviewState extends Equatable {
  const OverviewState({
    required this.selectedCategory,
    this.failureOrNearbyStores,
    this.failureOrSpecialOffers,
    required this.failure,
    required this.isLoading,
  });

  final ItemCategory? selectedCategory;
  final Either<Failure, List<NearbyStore>>? failureOrNearbyStores;
  final Either<Failure, List<SpecialOffer>>? failureOrSpecialOffers;
  final Failure? failure;
  final bool isLoading;

  static const _defaultFailure = Failure(message: '');

  factory OverviewState.initial() => const OverviewState(
        selectedCategory: null,
        failure: null,
        isLoading: false,
      );

  OverviewState copyWith({
    ItemCategory? selectedCategory = const ItemCategory(id: '', name: ''),
    Option<Either<Failure, List<NearbyStore>>?>? failureOrNearbyStores,
    Option<Either<Failure, List<SpecialOffer>>?>? failureOrSpecialOffers,
    Failure? failure = _defaultFailure,
    bool? isLoading,
  }) {
    return OverviewState(
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
