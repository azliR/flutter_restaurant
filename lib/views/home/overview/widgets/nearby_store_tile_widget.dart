import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/nearby_store.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';

class NearbyStoreTile extends StatelessWidget {
  const NearbyStoreTile({
    Key? key,
    required this.nearbyStore,
    required this.onTap,
  }) : super(key: key);

  final NearbyStore nearbyStore;
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
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NullableNetworkImage(
                imageUrl: nearbyStore.banner,
                aspectRatio: 1 / 1,
              ),
              const SizedBox(height: 8),
              Text(
                nearbyStore.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 4),
              Text(
                // TODO: translate
                nearbyStore.description ?? 'No description',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  // TODO: translate
                  Text(nearbyStore.rating?.toStringAsPrecision(3) ??
                      'No rating'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
