import 'package:flutter/material.dart';
import 'package:flutter_restaurant/bloc/cart/cart.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/misc/utils.dart';
import 'package:kt_dart/kt.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    Key? key,
    required this.carts,
    required this.onPressed,
  }) : super(key: key);

  final KtList<Cart> carts;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kBorderRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  formatCurrency(
                    carts.sumBy((cart) => cart.totalAmount),
                  ),
                  style: textTheme.headline6?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                primary: colorScheme.primary,
                onPrimary: colorScheme.onPrimary,
              ),
              onPressed: onPressed,
              child: Row(
                children: [
                  Text('${carts.size} items'),
                  const SizedBox(width: 8),
                  const Icon(Icons.shopping_basket_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
