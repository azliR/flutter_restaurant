import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/item/item.dart';

class CustomSliverAppBar extends SliverPersistentHeaderDelegate {
  CustomSliverAppBar({
    required this.expandedHeight,
    required this.item,
  });

  final double expandedHeight;
  final Item item;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    const paddingSize = 16.0;

    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: item.picture ?? '',
          fit: BoxFit.cover,
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
                Color(0x88000000),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: paddingSize,
          left: paddingSize,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - (paddingSize * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),
                if (item.description != null)
                  Text(
                    item.description ?? 'No description',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onBackground,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
