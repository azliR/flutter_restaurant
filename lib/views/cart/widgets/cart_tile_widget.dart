import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/cart/cart.dart';
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/misc/utils.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';
import 'package:kt_dart/kt.dart';

class CartTile extends StatelessWidget {
  const CartTile({
    super.key,
    required this.cart,
    required this.onItemRemove,
  });

  final Cart cart;
  final VoidCallback onItemRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<CartCubit>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Column(
        children: [
          InkWell(
            borderRadius:
                const BorderRadius.all(Radius.circular(kBorderRadius)),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 64,
                    child: NullableNetworkImage(
                      aspectRatio: 3.5 / 3,
                      imageUrl: cart.picture,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cart.itemName,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...cart.itemAddon
                            .map(
                              (e) => Text(
                                '+ ${e.name}',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.outline,
                                ),
                              ),
                            )
                            .asList()
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatCurrency(cart.totalAmount),
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              iconSize: 16,
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onPressed: () => cubit.minusQuantity(cart.itemId),
                              icon: const Icon(Icons.remove_rounded),
                            ),
                            const SizedBox(width: 8),
                            BlocSelector<CartCubit, CartState, int?>(
                              selector: (state) => state.carts
                                  .firstOrNull((e) => cart.itemId == e.itemId)
                                  ?.quantity,
                              builder: (context, quantity) {
                                return Text(
                                  quantity.toString(),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onBackground,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              iconSize: 16,
                              onPressed: () => cubit.addQuantity(cart.itemId),
                              icon: const Icon(Icons.add_rounded),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
