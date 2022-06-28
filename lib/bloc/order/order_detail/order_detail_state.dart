part of 'order_detail_cubit.dart';

@immutable
class OrderDetailState extends Equatable {
  const OrderDetailState({
    required this.isLoading,
    this.order,
    this.failure,
  });

  final bool isLoading;
  final Order? order;
  final Failure? failure;

  static const _defaultFailure = Failure(message: '');

  factory OrderDetailState.initial() => const OrderDetailState(
        isLoading: false,
      );

  OrderDetailState copyWith({
    bool? isLoading,
    Order? order,
    Failure? failure = _defaultFailure,
  }) {
    return OrderDetailState(
      isLoading: isLoading ?? this.isLoading,
      order: order ?? this.order,
      failure: failure == _defaultFailure ? this.failure : failure,
    );
  }

  @override
  List<Object?> get props => [isLoading, order, failure];
}
