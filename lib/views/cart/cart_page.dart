import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart';
import 'package:flutter_restaurant/views/cart/cart_body_large.dart';
import 'package:flutter_restaurant/views/cart/cart_body_small.dart';

class CartPage extends StatelessWidget {
  const CartPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<CartCubit, CartState>(
      listenWhen: (previous, current) => previous.carts != current.carts,
      listener: (context, state) {
        if (state.carts.isEmpty()) {
          context.router.pop();
        }
      },
      child: size.width < 900 ? const CartBodySmall() : const CartBodyLarge(),
    );
  }
}
