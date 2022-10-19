import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/bloc/cart/cart.dart';
import 'package:flutter_restaurant/bloc/core/failure.dart';
import 'package:flutter_restaurant/models/coupon/coupon.dart';
import 'package:flutter_restaurant/models/coupon/discount.dart';
import 'package:flutter_restaurant/models/enums/enums.dart';
import 'package:flutter_restaurant/models/order/order.dart';
import 'package:flutter_restaurant/repositories/cart_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

part 'cart_state.dart';

@injectable
class CartCubit extends Cubit<CartState> {
  CartCubit(
    this._cartRepository,
  ) : super(CartState.initial());

  final CartRepository _cartRepository;

  double get subtotal => state.carts.sumBy((cart) => cart.totalAmount);

  double get total => subtotal - (state.discount?.discAmount ?? 0);

  void onOrderTypeChanged(OrderType orderType) {
    emit(state.copyWith(orderType: orderType));
  }

  void onPickupTypeChanged(PickupType pickupType) {
    emit(state.copyWith(pickupType: pickupType));
  }

  void onSchedulePickupChanged(PickupType schedulePickup) {
    emit(state.copyWith(pickupType: schedulePickup));
  }

  void onMinutesChanged(int minutes) {
    emit(state.copyWith(scheduleMinutes: minutes));
  }

  void addQuantity(String itemId) {
    emit(
      state.copyWith(
        carts: state.carts.map((cart) {
          if (cart.itemId == itemId) {
            return cart.copyWith(quantity: cart.quantity + 1);
          } else {
            return cart;
          }
        }),
      ),
    );
  }

  void minusQuantity(String itemId) {
    emit(
      state.copyWith(
        carts: state.carts.mapNotNull((cart) {
          if (cart?.itemId == itemId) {
            if (cart?.quantity == 1) {
              return null;
            } else {
              return cart?.copyWith(quantity: cart.quantity - 1);
            }
          } else {
            return cart;
          }
        }),
      ),
    );
  }

  void addToCart({
    required String storeId,
    required Cart cart,
    required void Function() onCompleted,
    required void Function() onError,
  }) {
    if (state.storeId != null && state.storeId != storeId) {
      onError();
    } else {
      final existingCartIndex = state.carts.indexOfFirst(
        (e) => e.itemId == cart.itemId && e.itemAddon == cart.itemAddon,
      );

      if (existingCartIndex == -1) {
        emit(
          state.copyWith(
            carts: state.carts.plusElement(cart),
            storeId: storeId,
          ),
        );
      } else {
        final existingCart = state.carts[existingCartIndex];
        final newList = state.carts.toMutableList()
          ..[existingCartIndex] = existingCart.copyWith(
            quantity: existingCart.quantity + cart.quantity,
          );
        emit(state.copyWith(carts: newList));
      }
      onCompleted();
    }
  }

  void clearCart() {
    emit(
      state.copyWith(
        carts: emptyList(),
        storeId: null,
        coupon: null,
        discount: null,
        couponFailure: null,
      ),
    );
  }

  Future<void> placeOrder({
    String? storeId,
    List<Cart>? items,
    required void Function(Order order) onCompleted,
    required void Function(Failure? failure) onError,
  }) async {
    await _cartRepository.placeOrder(
      storeId: storeId ?? state.storeId!,
      orderType: state.orderType.name,
      pickupType: state.pickupType.name,
      couponCode: state.coupon?.couponCode,
      scheduleAt:
          state.orderType == OrderType.scheduled ? state.scheduleMinutes : null,
      items: items ?? state.carts.asList(),
      onCompleted: onCompleted,
      onError: onError,
    );
  }

  void removeFromCart({
    required Cart cart,
  }) {
    final carts = state.carts.minusElement(cart);
    emit(
      state.copyWith(
        carts: carts,
        storeId: carts.isEmpty() ? null : state.storeId,
      ),
    );
  }
}
