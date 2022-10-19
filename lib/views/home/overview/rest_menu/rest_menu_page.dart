import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/cart/cart.dart';
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart';
import 'package:flutter_restaurant/bloc/home/rest_menu/rest_menu_cubit.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';
import 'package:flutter_restaurant/views/core/widgets/error_text.dart';
import 'package:flutter_restaurant/views/core/widgets/progress_overlay.dart';
import 'package:flutter_restaurant/views/home/overview/rest_menu/rest_menu_body.dart';
import 'package:flutter_restaurant/views/home/overview/rest_menu/widgets/cart_button_widget.dart';
import 'package:kt_dart/kt.dart';

class RestMenuPage extends StatefulWidget with AutoRouteWrapper {
  const RestMenuPage({
    super.key,
    required this.storeId,
  });

  final String storeId;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<RestMenuCubit>()..getStoreById(storeId: storeId),
      child: this,
    );
  }

  @override
  _RestMenuPageState createState() => _RestMenuPageState();
}

class _RestMenuPageState extends State<RestMenuPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RestMenuCubit>();

    return Scaffold(
      body: BlocBuilder<RestMenuCubit, RestMenuState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.failure != current.failure ||
            previous.store != current.store,
        builder: (context, state) {
          return ProgressOverlay(
            visible: state.isLoading,
            child: () {
              if (state.isLoading) {
                return const Center();
              } else if (state.failure != null || state.store == null) {
                return ErrorText(
                  message:
                      state.failure?.message ?? context.l10n.unexpectedError,
                  onRetry: () {
                    cubit.getStoreById(storeId: widget.storeId);
                  },
                );
              } else {
                return Column(
                  children: [
                    RestMenuBody(store: state.store!),
                  ],
                );
              }
            }(),
          );
        },
      ),
      bottomNavigationBar: BlocSelector<CartCubit, CartState, KtList<Cart>>(
        selector: (state) => state.carts,
        builder: (context, carts) {
          if (carts.isEmpty()) {
            return const SizedBox();
          } else {
            return CartButton(
              carts: carts,
              onPressed: () => context.router.push(const CartRoute()),
            );
          }
        },
      ),
    );
  }
}
