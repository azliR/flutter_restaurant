part of 'cart_cubit.dart';

@immutable
class CartState extends Equatable {
  const CartState({
    required this.orderType,
    required this.pickupType,
    required this.scheduleMinutes,
    this.storeId,
    required this.carts,
    this.discount,
    this.coupon,
    this.couponFailure,
    required this.isCouponLoading,
  });

  final OrderType orderType;
  final PickupType pickupType;
  final int scheduleMinutes;
  final String? storeId;
  final KtList<Cart> carts;
  final Discount? discount;
  final Coupon? coupon;
  final Failure? couponFailure;
  final bool isCouponLoading;

  static const _defaultString = '';
  static const _defaultDiscount = Discount();
  static const _defaultCoupon = Coupon();
  static const _defaultFailure = Failure(message: '');

  factory CartState.initial() => CartState(
        orderType: OrderType.now,
        pickupType: PickupType.pickup,
        scheduleMinutes: 15,
        carts: emptyList(),
        isCouponLoading: false,
      );

  CartState copyWith({
    OrderType? orderType,
    PickupType? pickupType,
    int? scheduleMinutes,
    KtList<Cart>? carts,
    Discount? discount = _defaultDiscount,
    Coupon? coupon = _defaultCoupon,
    Failure? couponFailure = _defaultFailure,
    String? storeId = _defaultString,
    String? storeName = _defaultString,
    bool? isCouponLoading,
  }) {
    return CartState(
      orderType: orderType ?? this.orderType,
      pickupType: pickupType ?? this.pickupType,
      scheduleMinutes: scheduleMinutes ?? this.scheduleMinutes,
      carts: carts ?? this.carts,
      discount: discount == _defaultDiscount ? this.discount : discount,
      couponFailure:
          couponFailure == _defaultFailure ? this.couponFailure : couponFailure,
      coupon: coupon == _defaultCoupon ? this.coupon : coupon,
      storeId: storeId == _defaultString ? this.storeId : storeId,
      isCouponLoading: isCouponLoading ?? this.isCouponLoading,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderType': orderType.index,
      'pickupType': pickupType.index,
      'scheduleMinutes': scheduleMinutes,
      'carts': carts.map((e) => e.toMap()).asList(),
      'storeId': storeId,
    };
  }

  factory CartState.fromMap(Map<String, dynamic> map) {
    return CartState.initial().copyWith(
      orderType: OrderType.values[(map['orderType'] as int?) ?? 0],
      pickupType: PickupType.values[(map['pickupType'] as int?) ?? 0],
      scheduleMinutes: (map['scheduleMinutes'] as int?) ?? 0,
      carts: ((map['carts'] as List?) ?? [])
          .map((e) => Cart.fromMap((e as Map).cast()))
          .toImmutableList(),
      storeId: map['storeId'] as String?,
      storeName: map['storeName'] as String?,
    );
  }

  @override
  List<Object?> get props {
    return [
      orderType,
      pickupType,
      scheduleMinutes,
      storeId,
      carts,
      discount,
      coupon,
      couponFailure,
      isCouponLoading,
    ];
  }
}
