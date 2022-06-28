import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart';
import 'package:flutter_restaurant/bloc/order/order_detail/order_detail_cubit.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/models/order/order.dart';
import 'package:flutter_restaurant/views/core/misc/utils.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';
import 'package:flutter_restaurant/views/home/orders/order_detail/widgets/order_detail_item_tile_widget.dart';
import 'package:intl/intl.dart';

class OrderDetailBody extends StatelessWidget {
  const OrderDetailBody({Key? key}) : super(key: key);

  void _addAllToCart(BuildContext context, Order order) {
    final cartCubit = context.read<CartCubit>();

    // for (final item in order.item) {
    //   var error = false;
    //   cartCubit.addToCart(
    //     storeId: order.storeId,
    //     storeName: order.storeName,
    //     cart: Cart(
    //       itemId: item.itemId,
    //       itemName: item.itemName,
    //       picture: item.picture,
    //       qty: item.qty,
    //       price: item.price,
    //       extras: item.extras.map((extra) {
    //         return AddonDetail(
    //           id: extra.addonId,
    //           name: extra.name,
    //           price: extra.price,
    //         );
    //       }).toImmutableList(),
    //     ),
    //     onCompleted: () {
    //       context.tabsRouter.setActiveIndex(2);
    //       showSnackbar(context, 'Successfully added to cart');
    //     },
    //     onError: () {
    //       showModalBottomSheet(
    //         context: context,
    //         useRootNavigator: true,
    //         shape: const RoundedRectangleBorder(
    //             borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    //         builder: (dialogContext) {
    //           return Padding(
    //             padding: const EdgeInsets.all(16),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const SizedBox(height: 8),
    //                 Text(
    //                   context.l10n.customiseFoodNotSameStoreTitle,
    //                   style: Theme.of(context).textTheme.headline6?.copyWith(
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                 ),
    //                 const SizedBox(height: 8),
    //                 Text(
    //                   context.l10n.customiseFoodNotSameStoreDesc,
    //                   style: Theme.of(context).textTheme.bodyText2,
    //                 ),
    //                 const SizedBox(height: 16),
    //                 SizedBox(
    //                   width: double.infinity,
    //                   child: ElevatedButton(
    //                     onPressed: () {
    //                       context.read<CartCubit>().clearCart();
    //                       Navigator.pop(dialogContext);
    //                       _addAllToCart(context, order);
    //                     },
    //                     child: Text(context.l10n.customiseFoodClearAndAdd),
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   width: double.infinity,
    //                   child: TextButton(
    //                     onPressed: () => Navigator.pop(dialogContext),
    //                     child: Text(context.l10n.cancelButton),
    //                   ),
    //                 ),
    //                 const SizedBox(height: 16),
    //               ],
    //             ),
    //           );
    //         },
    //       );
    //     },
    //   );
    // }
  }

  void _reOrder(BuildContext context, Order order) {
    final cartCubit = context.read<CartCubit>();

    // context.router.push(
    //   ChoosePaymentMethodRoute(
    //     amount: order.netto,
    //     storeId: order.storeId,
    //     storeName: order.storeName,
    //     onPaymentMethodSelected: (paymentMethod, token) async {
    //       cartCubit.placeOrder(
    //         token: context.read<AuthCubit>().state.authToken!.token,
    //         payment: () {
    //           if (paymentMethod is GooglePay) {
    //             return 'google pay';
    //           } else {
    //             return 'card';
    //           }
    //         }(),
    //         vehicleInfo: context.read<PreferencesCubit>().state.vehicleInfo,
    //         items: order.detailItem
    //             .map(
    //               (e) => Cart(
    //                 itemId: e.itemId,
    //                 itemName: e.itemName,
    //                 picture: e.picture,
    //                 qty: e.qty,
    //                 price: e.price,
    //                 extras: e.extras
    //                     .map((e) => AddonDetail(
    //                         id: e.addonId, name: e.name, price: e.price))
    //                     .toImmutableList(),
    //               ),
    //             )
    //             .toList(),
    //         storeId: order.storeId,
    //         onCompleted: (order) {
    //           context.router.push(OrderStatusRoute(
    //             order: order,
    //           ));
    //         },
    //         onError: (failure) {
    //           showErrorSnackbar(
    //               context, failure?.message ?? context.l10n.unexpectedError);
    //         },
    //       );
    //     },
    //   ),
    // );
  }

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
