import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/auth/auth_cubit.dart';
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';
import 'package:flutter_restaurant/views/core/misc/dialogs.dart';

class CartPlaceOrderButton extends StatelessWidget {
  const CartPlaceOrderButton({Key? key}) : super(key: key);

  Future<void> _placeOrder({
    required BuildContext context,
  }) async {
    final cubit = context.read<CartCubit>();
    // final token = context.read<AuthCubit>().state.authToken!.token;

    await cubit.placeOrder(
      token: '1c7b3156-986b-487b-8d6c-2db03806ca30',
      onCompleted: (order) async {
        context.read<CartCubit>().clearCart();

        context.router.push(OrderStatusRoute(orderId: order.id));
      },
      onError: (failure) {
        showErrorSnackbar(
          context,
          failure?.message ?? context.l10n.unexpectedError,
        );
      },
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final authStatus = context.read<AuthCubit>().state.authStatus;

    switch (authStatus) {
      case AuthStatus.authorised:
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirm order?'),
              titleTextStyle: textTheme.headline6?.copyWith(
                color: colorScheme.onSurface,
              ),
              content: const Text('Are you sure you want to place this order?'),
              contentTextStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _placeOrder(context: context);
                    Navigator.pop(context);
                  },
                  child: const Text('Place order'),
                ),
              ],
            );
          },
        );
      case AuthStatus.unauthorised:
        context.router.push(
          SignInRoute(
            onCompleted: () {
              context.router.push(
                ProfileCompletionRoute(
                  onComplete: () {
                    _showDialog(context);
                  },
                ),
              );
            },
          ),
        );
        break;
      case AuthStatus.needCompletion:
        // context.router.push(
        //   ProfileRoute(
        //     onCompleted: () => _showDialog(context),
        //   ),
        // );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(18),
        primary: colorScheme.primary,
        onPrimary: colorScheme.onPrimary,
      ),
      onPressed: () async {
        _showDialog(context);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.cartPlaceOrder,
          ),
          const SizedBox(width: 8),
          const Icon(Icons.lock),
        ],
      ),
    );
  }
}
