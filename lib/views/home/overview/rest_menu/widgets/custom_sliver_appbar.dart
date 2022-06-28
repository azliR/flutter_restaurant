import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/store/store.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';

class CustomSliverAppBar extends SliverPersistentHeaderDelegate {
  CustomSliverAppBar({
    required this.expandedHeight,
    required this.store,
    required this.profileRadius,
  });

  final double expandedHeight;
  final Store store;
  final double profileRadius;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    const paddingLeft = 16.0;

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        NullableNetworkImage(
          imageUrl: store.banner,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(kBorderRadius),
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
                Colors.transparent,
                Colors.transparent,
                Colors.black54,
              ],
            ),
          ),
        ),
        Positioned(
          top: expandedHeight - profileRadius - shrinkOffset,
          bottom: 0,
          right: 0,
          left: 0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                padding: EdgeInsets.fromLTRB(
                  (paddingLeft * 2) + (profileRadius * 2),
                  0,
                  8,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        store.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: colorScheme.onSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            store.rating.toString(),
                            style: textTheme.bodyText2?.copyWith(
                              color: colorScheme.onSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          top: expandedHeight - profileRadius - shrinkOffset,
          left: paddingLeft,
          child: Opacity(
            opacity: 1 - shrinkOffset / expandedHeight,
            child: SizedBox(
              height: profileRadius * 2,
              child: NullableNetworkImage(
                imageUrl: store.image,
                borderRadius: BorderRadius.circular(profileRadius),
                placeholderColor: colorScheme.primary,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BackButton(color: colorScheme.secondary),
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
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
