import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/cart/cart.dart';
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart';
import 'package:flutter_restaurant/views/cart/widgets/cart_order_title_widget.dart';
import 'package:flutter_restaurant/views/cart/widgets/cart_order_type_tile_widget.dart';
import 'package:flutter_restaurant/views/cart/widgets/cart_pickup_type_tile_widget.dart';
import 'package:flutter_restaurant/views/cart/widgets/cart_place_order_button_widget.dart';
import 'package:flutter_restaurant/views/cart/widgets/cart_summary_widget.dart';
import 'package:flutter_restaurant/views/cart/widgets/cart_tile_widget.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:kt_dart/kt.dart';

class CartBodyLarge extends StatelessWidget {
  const CartBodyLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Row(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverPadding(
                  padding: EdgeInsets.all(kTopListPadding / 2),
                ),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: CartOrderTitle(),
                  ),
                ),
                BlocSelector<CartCubit, CartState, KtList<Cart>>(
                  selector: (state) => state.carts,
                  builder: (context, carts) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: carts.size,
                        (context, index) {
                          final cart = carts[index];
                          return CartTile(
                            cart: cart,
                            onItemRemove: () => context
                                .read<CartCubit>()
                                .removeFromCart(cart: cart),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: kListPadding,
              children: const [
                CartOrderTypeTile(),
                SizedBox(height: 8),
                CartPickupTypeTile(),
                SizedBox(height: 16),
                CartSummary(),
                SizedBox(height: 16),
                CartPlaceOrderButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
