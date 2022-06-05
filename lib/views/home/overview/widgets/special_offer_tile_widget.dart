import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/item.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';

class SpecialOfferTile extends StatelessWidget {
  const SpecialOfferTile({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  final Item item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: onTap,
        child: SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NullableNetworkImage(
                imageUrl: item.picture,
                aspectRatio: 4 / 3,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${(100 * (item.specialOffer! - item.price) / item.price).toStringAsFixed(0)}% OFF',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
