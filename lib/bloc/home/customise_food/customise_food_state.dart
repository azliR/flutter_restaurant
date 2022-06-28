part of 'customise_food_cubit.dart';

@immutable
class CustomiseFoodState extends Equatable {
  const CustomiseFoodState({
    required this.item,
    required this.addonCategories,
    required this.quantity,
    required this.isLoading,
    required this.failure,
  });

  final Item? item;
  final KtMap<String, KtList<ItemAddon>> addonCategories;
  final int quantity;
  final bool isLoading;
  final Failure? failure;

  static const _defaultFailure = Failure(message: '');

  factory CustomiseFoodState.initial() => CustomiseFoodState(
        item: null,
        addonCategories: emptyMap(),
        quantity: 1,
        isLoading: false,
        failure: null,
      );

  CustomiseFoodState copyWith({
    Item? item,
    KtMap<String, KtList<ItemAddon>>? addonCategories,
    int? quantity,
    bool? isLoading,
    Failure? failure = _defaultFailure,
  }) {
    return CustomiseFoodState(
      item: item ?? this.item,
      addonCategories: addonCategories ?? this.addonCategories,
      quantity: quantity ?? this.quantity,
      isLoading: isLoading ?? this.isLoading,
      failure: failure == _defaultFailure ? this.failure : failure,
    );
  }

  @override
  List<Object?> get props =>
      [item, addonCategories, quantity, isLoading, failure];
}
