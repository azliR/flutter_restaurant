part of 'rest_menu_cubit.dart';

@immutable
class RestMenuState extends Equatable {
  const RestMenuState({
    required this.store,
    required this.itemSubCategory,
    required this.failure,
    required this.isLoading,
  });

  final Store? store;
  final ItemSubCategory? itemSubCategory;
  final bool isLoading;
  final Failure? failure;

  static const _defaultSubCategory = ItemSubCategory(id: '', name: '');
  static const _defaultFailure = Failure(message: '');

  factory RestMenuState.initial() => const RestMenuState(
        store: null,
        itemSubCategory: null,
        failure: null,
        isLoading: false,
      );

  RestMenuState copyWith({
    Store? store,
    ItemSubCategory? itemSubCategory = _defaultSubCategory,
    bool? isLoading,
    Failure? failure = _defaultFailure,
  }) {
    return RestMenuState(
      store: store ?? this.store,
      itemSubCategory: itemSubCategory == _defaultSubCategory
          ? this.itemSubCategory
          : itemSubCategory,
      failure: failure == _defaultFailure ? this.failure : failure,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        store,
        failure,
        isLoading,
        itemSubCategory,
      ];
}
