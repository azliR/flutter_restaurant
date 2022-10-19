import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/home/map/map_cubit.dart';
import 'package:flutter_restaurant/models/home/nearby_store.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/widgets/nullable_network_image.dart';

class MapCard extends StatelessWidget {
  const MapCard({
    super.key,
    required this.selectedIndex,
    required this.pageController,
    required this.onPageChanged,
    required this.onButtonPressed,
  });

  final int selectedIndex;
  final PageController pageController;
  final Function(int index) onPageChanged;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;
    final colorScheme = themeData.colorScheme;

    final isDesktop = themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;

    final cardHeight =
        (MediaQuery.of(context).orientation == Orientation.landscape)
            ? (isDesktop ? 140.0 : 110.0)
            : 130.0;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: cardHeight,
        child: BlocSelector<MapCubit, MapState, List<NearbyStore>>(
          selector: (state) => state.stores,
          builder: (context, stores) {
            return PageView.builder(
              itemCount: stores.length,
              onPageChanged: onPageChanged,
              controller: pageController,
              itemBuilder: (context, index) {
                final store = stores[index];

                return Transform.scale(
                  scale: index == selectedIndex ? 1 : 0.85,
                  child: Card(
                    elevation: 8,
                    shadowColor: colorScheme.shadow,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(kBorderRadius),
                      ),
                      onTap: () {
                        if (selectedIndex != index) {
                          pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    store.name,
                                    style: textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Expanded(
                                    child: Text(
                                      store.streetAddress,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurface,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines:
                                          (index == 2 || index == 6) ? 2 : 4,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: onButtonPressed,
                                    child: const Text('Show'),
                                  ),
                                ],
                              ),
                            ),
                            // Adding Image for card.
                            NullableNetworkImage(
                              imageUrl: store.image ?? '',
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
