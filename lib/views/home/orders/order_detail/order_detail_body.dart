import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/order/order_detail/order_detail_cubit.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/models/order/order.dart';
import 'package:flutter_restaurant/views/core/misc/utils.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';
import 'package:flutter_restaurant/views/home/orders/order_detail/widgets/order_detail_item_tile_widget.dart';
import 'package:intl/intl.dart';

class OrderDetailBody extends StatelessWidget {
  const OrderDetailBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
      ),
      body: BlocSelector<OrderDetailCubit, OrderDetailState, Order>(
        selector: (state) => state.order!,
        builder: (context, order) {
          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 200,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: NullableNetworkImage(
                                  imageUrl: order.storeImage,
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0x00000000),
                                      Color(0x00000000),
                                      Color(0x66000000),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: Text(order.storeName)),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 12,
                                  color: colorScheme.background,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('MMM dd').format(order.createdAt),
                                  style: textTheme.caption?.copyWith(
                                    color: colorScheme.background,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        titlePadding:
                            const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          context.l10n.orderDetailYourOrder,
                          style: textTheme.subtitle2,
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final detailItem = order.orderDetails[index];
                          return OrderDetailItemTile(detailItem: detailItem);
                        },
                        childCount: order.orderDetails.length,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.l10n.orderDetailTotal,
                              style: textTheme.subtitle1
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formatCurrency(order.netto),
                              style: textTheme.subtitle1?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
