import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/cart/cart.dart';
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart';
import 'package:flutter_restaurant/bloc/home/customise_food/customise_food_cubit.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/models/item/item.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/widgets/error_text.dart';
import 'package:flutter_restaurant/views/core/widgets/progress_overlay.dart';
import 'package:flutter_restaurant/views/home/overview/customise_food/customise_food_body.dart';
import 'package:kt_dart/kt.dart';

class CustomiseFoodPage extends StatefulWidget implements AutoRouteWrapper {
  const CustomiseFoodPage({
    super.key,
    required this.itemId,
  });

  final String itemId;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CustomiseFoodCubit>()..getItemById(itemId: itemId),
      child: this,
    );
  }

  @override
  State<CustomiseFoodPage> createState() => _CustomiseFoodPageState();
}

class _CustomiseFoodPageState extends State<CustomiseFoodPage> {
  void _onAddToCart(BuildContext context, Item item) {
    final cubit = context.read<CustomiseFoodCubit>();
    final cartCubit = context.read<CartCubit>();

    cartCubit.addToCart(
      storeId: item.storeId,
      cart: Cart(
        itemId: item.id,
        itemName: item.name,
        quantity: cubit.state.quantity,
        price: item.price,
        picture: item.picture,
        isAvailable: true,
        itemAddon: cubit.state.addonCategories
            .map((entry) => entry.value)
            .asList()
            .expand((element) => element.asList())
            .toImmutableList(),
      ),
      onCompleted: () => Navigator.pop(context),
      onError: () {
        showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (dialogContext) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.customiseFoodNotSameStoreTitle,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.customiseFoodNotSameStoreDesc,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        cartCubit.clearCart();
                        Navigator.pop(dialogContext);
                        _onAddToCart(context, item);
                      },
                      child: Text(context.l10n.customiseFoodClearAndAdd),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(context.l10n.cancelButtonLabel),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<CustomiseFoodCubit>();
    return BlocBuilder<CustomiseFoodCubit, CustomiseFoodState>(
      buildWhen: (previous, current) =>
          previous.isLoading != current.isLoading ||
          previous.failure != current.failure ||
          previous.item != current.item,
      builder: (context, state) {
        return Scaffold(
          body: ProgressOverlay(
            visible: state.isLoading,
            child: () {
              if (state.isLoading) {
                return const Center();
              } else if (state.failure != null || state.item == null) {
                return ErrorText(
                  message:
                      state.failure?.message ?? context.l10n.unexpectedError,
                  onRetry: () {
                    cubit.getItemById(itemId: widget.itemId);
                  },
                );
              } else {
                return CustomiseFoodBody(
                  item: state.item!,
                );
              }
            }(),
          ),
          bottomNavigationBar: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(kBorderRadius),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.customiseOrderQuantity,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: colorScheme.surfaceVariant,
                            minimumSize: MediaQuery.of(context).size.width <
                                    kMobileBreakpoint
                                ? Size.zero
                                : null,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => cubit.minusQuantity(),
                          child: Icon(
                            Icons.remove_rounded,
                            size: MediaQuery.of(context).size.width <
                                    kMobileBreakpoint
                                ? 16
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        BlocSelector<CustomiseFoodCubit, CustomiseFoodState,
                            int>(
                          selector: (state) => state.quantity,
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
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: colorScheme.surfaceVariant,
                            minimumSize: MediaQuery.of(context).size.width <
                                    kMobileBreakpoint
                                ? Size.zero
                                : null,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => cubit.addQuantity(),
                          child: Icon(
                            Icons.add_rounded,
                            size: MediaQuery.of(context).size.width <
                                    kMobileBreakpoint
                                ? 16
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: colorScheme.onPrimary, padding: const EdgeInsets.all(16), backgroundColor: colorScheme.primary,
                      ),
                      onPressed: () {
                        if (state.item != null) {
                          _onAddToCart(context, state.item!);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(context.l10n.customiseFoodAddToCart),
                          const SizedBox(width: 8),
                          const Icon(Icons.add_shopping_cart_rounded),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
