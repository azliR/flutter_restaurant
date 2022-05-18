import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum HomeSection { overview, orders, account }

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

class HomePage extends StatelessWidget implements AutoRouteWrapper {
  const HomePage({Key? key}) : super(key: key);

  List<AdaptiveScaffoldDestination> _getDestinations(BuildContext context) {
    return HomeSection.values.map((section) {
      switch (section) {
        case HomeSection.promotion:
          return AdaptiveScaffoldDestination(
            icon: Icons.wallet_giftcard_outlined,
            selectedIcon: Icons.wallet_giftcard_rounded,
            label: context.l10n.homeBottomTabOverview,
          );
        case HomeSection.registration:
          return AdaptiveScaffoldDestination(
            icon: Icons.app_registration_rounded,
            selectedIcon: Icons.app_registration_rounded,
            label: context.l10n.homeBottomTabOrders,
          );
        case HomeSection.report:
          return AdaptiveScaffoldDestination(
            icon: Icons.report_problem_outlined,
            selectedIcon: Icons.report_problem_rounded,
            label: context.l10n.homeBottomTabAccount,
          );
      }
    }).toList();
  }

  void _onNavigationChanged(BuildContext context, int index) {
    AutoTabsRouter.of(context).setActiveIndex(index);
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RegistrationCubit>(),
      child: this,
    );
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
          case HomeSection.promotion:
            return const OverviewWrapperRoute();
          case HomeSection.registration:
            return const OrdersWrapperRoute();
          case HomeSection.report:
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
            // resizeToAvoidBottomInset: false,
            bottomNavigationBar: navigationType == NavigationType.bottom
                ? BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: tabsRouter.activeIndex,
                    onTap: (index) => _onNavigationChanged(context, index),
                    items: destinations
                        .map(
                          (destination) => BottomNavigationBarItem(
                            label: destination.label,
                            backgroundColor: Colors.transparent,
                            icon: _BarItem(
                              icon: destination.icon,
                              selected: false,
                            ),
                            activeIcon: _BarItem(
                              icon: destination.selectedIcon,
                              selected: true,
                            ),
                          ),
                        )
                        .toList(),
                  )
                : null,
            body: Row(
              children: [
                if (navigationType == NavigationType.rail) ...[
                  _HomeNavigationRail(
                    destinations: destinations,
                    selectedIndex: tabsRouter.activeIndex,
                    onSelected: (index) => _onNavigationChanged(context, index),
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
                ],
                if (navigationType == NavigationType.drawer) ...[
                  _HomeNavigationDrawer(
                    destinations: destinations,
                    selectedIndex: tabsRouter.activeIndex,
                    onSelected: (index) => _onNavigationChanged(context, index),
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
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

class _BarItem extends StatelessWidget {
  const _BarItem({
    Key? key,
    required this.icon,
    required this.selected,
  }) : super(key: key);

  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      decoration: BoxDecoration(
        color: selected ? Theme.of(context).colorScheme.secondary : null,
        borderRadius: const BorderRadius.all(Radius.circular(kBorderRadius)),
      ),
      child: Icon(icon),
    );
  }
}

class _HomeNavigationRail extends StatelessWidget {
  const _HomeNavigationRail({
    Key? key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  final List<AdaptiveScaffoldDestination> destinations;
  final int selectedIndex;
  final void Function(int index) onSelected;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Theme.of(context).cardColor,
          ),
          Expanded(
            child: NavigationRail(
              onDestinationSelected: onSelected,
              destinations: destinations
                  .map(
                    (destination) => NavigationRailDestination(
                      label: Text(destination.label),
                      icon: _BarItem(
                        icon: destination.icon,
                        selected: false,
                      ),
                      selectedIcon: _BarItem(
                        icon: destination.selectedIcon,
                        selected: true,
                      ),
                    ),
                  )
                  .toList(),
              selectedIndex: selectedIndex,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeNavigationDrawer extends StatelessWidget {
  const _HomeNavigationDrawer({
    Key? key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  final List<AdaptiveScaffoldDestination> destinations;
  final int selectedIndex;
  final void Function(int index) onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 256,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(right: 16),
        itemCount: destinations.length + 1,
        itemBuilder: (context, listIndex) {
          if (listIndex == 0) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                left: false,
                right: false,
                bottom: false,
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.appName,
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                          Text(
                            'Version ${snapshot.data!.version}',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            );
          }
          final index = listIndex - 1;
          final destination = destinations[index];
          final selected = destinations.indexOf(destination) == selectedIndex;

          return ListTile(
            leading: Icon(
              selected ? destination.selectedIcon : destination.icon,
              color: selected ? null : Theme.of(context).hintColor,
            ),
            title: Text(
              destination.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.button?.copyWith(
                    color: selected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).hintColor,
                  ),
            ),
            selected: selected,
            selectedTileColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(36)),
            ),
            onTap: () => onSelected(index),
          );
        },
      ),
    );
  }
}
