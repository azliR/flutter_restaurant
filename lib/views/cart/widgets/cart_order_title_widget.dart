import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';

class CartOrderTitle extends StatelessWidget {
  const CartOrderTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          'Your order',
          style:
              textTheme.titleMedium?.copyWith(color: colorScheme.onBackground),
        ),
        const Spacer(),
        BlocSelector<CartCubit, CartState, int>(
          selector: (state) => state.carts.size,
          builder: (context, length) {
            return Text(
              context.l10n.cartItems(length),
              style: textTheme.titleMedium
                  ?.copyWith(color: colorScheme.onBackground),
            );
          },
        ),
      ],
    );
  }
}
