import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/order/order_detail.dart';

class OrderDetailItemTile extends StatelessWidget {
  const OrderDetailItemTile({
    super.key,
    required this.detailItem,
  });

  final OrderDetail detailItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text('${detailItem.quantity}x ${detailItem.itemName}'),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: detailItem.addons
                  ?.map(
                    (addon) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 16,
                      ),
                      child: Text(
                        '+ ${addon.addonName}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  )
                  .toList() ??
              [],
        ),
        const Divider(),
      ],
    );
  }
}
