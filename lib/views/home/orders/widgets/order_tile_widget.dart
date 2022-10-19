import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/models/enums/enums.dart';
import 'package:flutter_restaurant/models/order/orders.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/misc/utils.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.order,
    required this.onTap,
  });

  final Orders order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(kBorderRadius),
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 64,
                    child: NullableNetworkImage(
                      imageUrl: order.storeImage,
                      aspectRatio: 7 / 6,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.storeName,
                          style: textTheme.subtitle2?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.ordersItem(order.totalItem),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateTime.now()
                                    .subtract(const Duration(days: 1))
                                    .isBefore(order.createdAt)
                                ? timeago.format(order.createdAt)
                                : DateFormat('dd MMM yyyy')
                                    .format(order.createdAt),
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        backgroundColor: colorScheme.tertiaryContainer,
                        padding: EdgeInsets.zero,
                        side: BorderSide.none,
                        labelStyle: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onTertiaryContainer,
                        ),
                        label: Text(
                          order.status.toReadableString(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total order',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                        Text(
                          formatCurrency(order.netto),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (order.status != OrderStatus.complete)
                        OutlinedButton(
                          onPressed: () {
                            context.router
                                .push(OrderStatusRoute(orderId: order.id));
                          },
                          child: Text(context.l10n.ordersTrack),
                        ),
                      // const SizedBox(width: 8),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     elevation: 0,
                      //     padding: const EdgeInsets.symmetric(horizontal: 12),
                      //     primary: colorScheme.primary,
                      //     onPrimary: colorScheme.onPrimary,
                      //   ),
                      //   onPressed: () {},
                      //   child: const Text('Buy again'),
                      // ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
