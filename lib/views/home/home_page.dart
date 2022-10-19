import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';
import 'package:flutter_restaurant/views/core/widgets/auth_consumer.dart';

enum HomeSection { overview, map, orders, account }

enum NavigationType { bottom, rail, drawer }

class AdaptiveScaffoldDestination {
  const AdaptiveScaffoldDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class HomePage extends StatelessWidget with AutoRouteWrapper {
  const HomePage({super.key});

  List<AdaptiveScaffoldDestination> _getDestinations(BuildContext context) {
    return HomeSection.values.map((section) {
      switch (section) {
        case HomeSection.overview:
          return const AdaptiveScaffoldDestination(
            icon: Icons.home_filled,
            selectedIcon: Icons.home_filled,
            label: 'Home',
          );
        case HomeSection.map:
          return const AdaptiveScaffoldDestination(
            icon: Icons.map_outlined,
            selectedIcon: Icons.map_rounded,
            label: 'Map',
          );
        case HomeSection.orders:
          return const AdaptiveScaffoldDestination(
            icon: Icons.description_outlined,
            selectedIcon: Icons.description_rounded,
            label: 'Orders',
          );
        case HomeSection.account:
          return const AdaptiveScaffoldDestination(
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: 'Profile',
          );
      }
    }).toList();
  }

  void _onNavigationChanged(BuildContext context, int index) {
    final tabsRouter = AutoTabsRouter.of(context);
    if (index != tabsRouter.activeIndex) {
      tabsRouter.setActiveIndex(index);
    } else {
      tabsRouter.stackRouterOfIndex(index)?.popUntilRoot();
    }
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final destinations = _getDestinations(context);

    final NavigationType navigationType;
    if (data.size.width < 600) {
      if (data.orientation == Orientation.portrait) {
        navigationType = NavigationType.bottom;
      } else {
        navigationType = NavigationType.rail;
      }
    } else if (data.size.width < 1024) {
      navigationType = NavigationType.rail;
    } else {
      navigationType = NavigationType.drawer;
    }

    return AuthListener(
      child: AutoTabsRouter(
        duration: const Duration(milliseconds: 300),
        lazyLoad: true,
        curve: Curves.easeIn,
        routes: HomeSection.values.map((section) {
          switch (section) {
            case HomeSection.overview:
              return const OverviewWrapperRoute();
            case HomeSection.orders:
              return const OrdersWrapperRoute();
            case HomeSection.map:
              return const MapWrapperRoute();
            case HomeSection.account:
              return const AccountWrapperRoute();
          }
        }).toList(),
        builder: (context, child, animation) {
          final tabsRouter = AutoTabsRouter.of(context);

          return WillPopScope(
            onWillPop: () async {
              if (tabsRouter.activeIndex != 0) {
                tabsRouter.setActiveIndex(0);
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              bottomNavigationBar: navigationType == NavigationType.bottom
                  ? NavigationBar(
                      selectedIndex: tabsRouter.activeIndex,
                      onDestinationSelected: (index) =>
                          _onNavigationChanged(context, index),
                      destinations: destinations
                          .map(
                            (destination) => NavigationDestination(
                              label: destination.label,
                              icon: Icon(destination.icon),
                              selectedIcon: Icon(destination.selectedIcon),
                            ),
                          )
                          .toList(),
                    )
                  : null,
              body: Row(
                children: [
                  if (navigationType != NavigationType.bottom) ...[
                    _HomeNavigationRail(
                      extended: navigationType == NavigationType.drawer,
                      destinations: destinations,
                      selectedIndex: tabsRouter.activeIndex,
                      onDestinationSelected: (index) =>
                          _onNavigationChanged(context, index),
                    ),
                    const VerticalDivider(width: 1, thickness: 0.2),
                  ],
                  Expanded(
                    child: FadeScaleTransition(
                      animation: animation,
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomeNavigationRail extends StatelessWidget {
  const _HomeNavigationRail({
    required this.extended,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final bool extended;
  final int selectedIndex;
  final void Function(int index) onDestinationSelected;
  final List<AdaptiveScaffoldDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Theme.of(context).navigationRailTheme.backgroundColor,
          ),
          Expanded(
            child: NavigationRail(
              extended: extended,
              selectedIndex: selectedIndex,
              labelType: extended
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              onDestinationSelected: onDestinationSelected,
              destinations: destinations
                  .map(
                    (destination) => NavigationRailDestination(
                      label: Text(destination.label),
                      icon: Icon(destination.icon),
                      selectedIcon: Icon(destination.selectedIcon),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
