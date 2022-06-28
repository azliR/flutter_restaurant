import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/order/order_detail/order_detail_cubit.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/views/core/widgets/error_text.dart';
import 'package:flutter_restaurant/views/core/widgets/progress_overlay.dart';
import 'package:flutter_restaurant/views/home/orders/order_detail/order_detail_body.dart';

class OrderDetailPage extends StatelessWidget implements AutoRouteWrapper {
  const OrderDetailPage({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  final String orderId;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<OrderDetailCubit>()..getOrderById(token: '', orderId: orderId),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderDetailCubit>();

    return BlocBuilder<OrderDetailCubit, OrderDetailState>(
      buildWhen: (previous, current) =>
          previous.isLoading != current.isLoading ||
          previous.failure != current.failure ||
          previous.order != current.order,
      builder: (context, state) {
        return ProgressOverlay(
          visible: state.isLoading,
          child: () {
            if (state.isLoading || state.failure?.statusCode == 401) {
              return const Center();
            } else if (state.failure != null || state.order == null) {
              return ErrorText(
                message: state.failure?.message ?? context.l10n.unexpectedError,
                onRetry: () {
                  cubit.getOrderById(token: '', orderId: orderId);
                },
              );
            } else {
              return const OrderDetailBody();
            }
          }(),
        );
      },
    );
  }
}
