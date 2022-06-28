part of 'orders_cubit.dart';

@immutable
class OrdersState extends Equatable {
  const OrdersState({
    required this.isLoading,
  });

  final bool isLoading;

  factory OrdersState.initial() => const OrdersState(
        isLoading: false,
      );

  OrdersState copyWith({
    bool? isLoading,
  }) {
    return OrdersState(
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [isLoading];
}
