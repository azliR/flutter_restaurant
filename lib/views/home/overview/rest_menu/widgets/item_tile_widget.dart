import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/item/item_by_store.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/misc/utils.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    Key? key,
    required this.itemByStore,
    required this.storeName,
  }) : super(key: key);

  final ItemByStore itemByStore;
  final String storeName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(kBorderRadius)),
        onTap: () {
          context.router.push(
            CustomiseFoodRoute(itemId: itemByStore.id),
          );
        },
        child: Container(
          height: 128,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemByStore.name,
                      maxLines: 1,
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        itemByStore.description ?? 'No description',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          formatCurrency(
                            itemByStore.specialOffer ?? itemByStore.price,
                          ),
                          style: textTheme.titleSmall?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                        if (itemByStore.specialOffer != null) ...[
                          Text(
                            formatCurrency(itemByStore.price),
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.outline,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                        Chip(
                          padding: EdgeInsets.zero,
                          side: BorderSide.none,
                          backgroundColor: colorScheme.tertiaryContainer,
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          labelStyle: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                itemByStore.rating?.toString() ?? 'No rating',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              NullableNetworkImage(
                imageUrl: itemByStore.picture,
                aspectRatio: 3.5 / 3,
              )
            ],
          ),
        ),
      ),
    );
  }
}
