import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/preferences/preferences_cubit.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';

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
  const HomePage({Key? key}) : super(key: key);

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

    return AutoTabsRouter(
      duration: const Duration(milliseconds: 1000),
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
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeNavigationRail extends StatelessWidget {
  const _HomeNavigationRail({
    Key? key,
    required this.extended,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  }) : super(key: key);

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
          SizedBox(
            width: double.infinity,
            child: MaterialButton(
              padding: const EdgeInsets.symmetric(vertical: 16),
              onPressed: () {
                context.read<PreferencesCubit>().setThemeMode(
                      ThemeMode.values[(context
                                  .read<PreferencesCubit>()
                                  .state
                                  .themeMode
                                  .index +
                              1) %
                          ThemeMode.values.length],
                    );
              },
              child:
                  BlocSelector<PreferencesCubit, PreferencesState, ThemeMode>(
                selector: (state) => state.themeMode,
                builder: (context, themeMode) {
                  if (extended) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Theme.of(context).brightness == Brightness.dark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                          ),
                          const SizedBox(width: 16),
                          Text(themeMode.name),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Icon(
                          Theme.of(context).brightness == Brightness.dark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                        ),
                        Text(themeMode.name),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
