import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/home/special_offer.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/misc/utils.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';

class SpecialOfferTile extends StatelessWidget {
  const SpecialOfferTile({
    Key? key,
    required this.specialOffer,
    required this.onTap,
  }) : super(key: key);

  final SpecialOffer specialOffer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(kBorderRadius)),
        onTap: onTap,
        child: SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NullableNetworkImage(
                imageUrl: specialOffer.picture,
                aspectRatio: 4 / 3,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        specialOffer.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                      const Spacer(),
                      Text(
                        formatCurrency(specialOffer.specialOffer),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${(100 * (specialOffer.price - specialOffer.specialOffer) / specialOffer.price).toStringAsFixed(0)}%',
                              style: textTheme.caption?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatCurrency(specialOffer.price),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
