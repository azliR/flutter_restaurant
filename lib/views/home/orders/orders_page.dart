import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/auth/auth_cubit.dart';
import 'package:flutter_restaurant/bloc/order/orders/orders_cubit.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/models/order/orders.dart';
import 'package:flutter_restaurant/views/core/widgets/need_completion_widget.dart';
import 'package:flutter_restaurant/views/core/widgets/unauthorised_widget.dart';
import 'package:flutter_restaurant/views/home/orders/orders_body.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class OrdersPage extends StatefulWidget implements AutoRouteWrapper {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersCubit>(),
      child: this,
    );
  }

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _ordersPagingController =
      PagingController<int, Orders>(firstPageKey: 0);

  static const _ordersPageLimit = 10;

  @override
  void initState() {
    _ordersPagingController.addPageRequestListener((pageKey) {
      context.read<OrdersCubit>().getOrders(
            // token: context.read<AuthCubit>().state.authToken!.token,
            token: '1c7b3156-986b-487b-8d6c-2db03806ca30',
            pageKey: pageKey,
            pageLimit: _ordersPageLimit,
            onCompleted: (orders) {
              if (orders.length < _ordersPageLimit) {
                _ordersPagingController.appendLastPage(orders);
              } else {
                final nextPageKey = pageKey + orders.length;
                _ordersPagingController.appendPage(orders, nextPageKey);
              }
            },
            onError: (message) {
              _ordersPagingController.error = message;
            },
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _ordersPagingController.refresh();
            },
          ),
        ],
      ),
      body: BlocSelector<AuthCubit, AuthState, AuthStatus>(
        selector: (state) => state.authStatus,
        builder: (context, authStatus) {
          switch (authStatus) {
            case AuthStatus.authorised:
              return OrdersBody(
                orderPagingController: _ordersPagingController,
              );
            case AuthStatus.unauthorised:
              return const UnauthorisedWidget();
            case AuthStatus.needCompletion:
              return const NeedCompletionWidget();
          }
        },
      ),
    );
  }
}
