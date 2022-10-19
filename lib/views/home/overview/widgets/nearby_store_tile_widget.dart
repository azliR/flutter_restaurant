import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/home/nearby_store.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';

class NearbyStoreTile extends StatelessWidget {
  const NearbyStoreTile({
    super.key,
    required this.nearbyStore,
    required this.onTap,
  });

  final NearbyStore nearbyStore;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(kBorderRadius)),
        onTap: onTap,
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NullableNetworkImage(
                imageUrl: nearbyStore.image,
              ),
              const SizedBox(height: 8),
              Text(
                nearbyStore.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 4),
              Text(
                // TODO: translate
                '${nearbyStore.distance.toStringAsFixed(2)} km',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    textTheme.bodySmall?.copyWith(color: colorScheme.outline),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 20,
                    color: colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  // TODO: translate
                  Text(
                    nearbyStore.rating?.toStringAsPrecision(3) ?? 'No rating',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
