import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/order/orders.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/widgets/error_text.dart';
import 'package:flutter_restaurant/views/home/orders/widgets/order_tile_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class OrdersBody extends StatefulWidget {
  const OrdersBody({
    super.key,
    required this.orderPagingController,
  });

  final PagingController<int, Orders> orderPagingController;

  @override
  _OrdersBodyState createState() => _OrdersBodyState();
}

class _OrdersBodyState extends State<OrdersBody> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => widget.orderPagingController.refresh(),
      child: PagedListView<int, Orders>.separated(
        pagingController: widget.orderPagingController,
        padding: kListPadding,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        builderDelegate: PagedChildBuilderDelegate(
          firstPageErrorIndicatorBuilder: (context) {
            return ErrorText(
              message: widget.orderPagingController.error.toString(),
              onRetry: () {
                widget.orderPagingController.refresh();
              },
            );
          },
          itemBuilder: (context, order, index) {
            return OrderTile(
              order: order,
              onTap: () {
                context.router.push(OrderDetailRoute(orderId: order.id));
              },
            );
          },
        ),
      ),
    );
  }
}
