// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const SplashPage());
    },
    HomeRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: WrappedRoute(child: const HomePage()));
    },
    PhoneValidationRoute.name: (routeData) {
      final args = routeData.argsAs<PhoneValidationRouteArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: PhoneValidationPage(
              key: args.key,
              phoneNumber: args.phoneNumber,
              onSuccess: args.onSuccess));
    },
    OverviewWrapperRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    OrdersWrapperRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    AccountWrapperRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    OverviewRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: WrappedRoute(child: const OverviewPage()));
    },
    OrdersRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const OrdersPage());
    },
    AccountRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const AccountPage());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(SplashRoute.name, path: '/'),
        RouteConfig(HomeRoute.name, path: '/home', children: [
          RouteConfig(OverviewWrapperRoute.name,
              path: 'overview',
              parent: HomeRoute.name,
              children: [
                RouteConfig(OverviewRoute.name,
                    path: '', parent: OverviewWrapperRoute.name),
                RouteConfig('*#redirect',
                    path: '*',
                    parent: OverviewWrapperRoute.name,
                    redirectTo: '',
                    fullMatch: true)
              ]),
          RouteConfig(OrdersWrapperRoute.name,
              path: 'orders',
              parent: HomeRoute.name,
              children: [
                RouteConfig(OrdersRoute.name,
                    path: '', parent: OrdersWrapperRoute.name),
                RouteConfig('*#redirect',
                    path: '*',
                    parent: OrdersWrapperRoute.name,
                    redirectTo: '',
                    fullMatch: true)
              ]),
          RouteConfig(AccountWrapperRoute.name,
              path: 'my',
              parent: HomeRoute.name,
              children: [
                RouteConfig(AccountRoute.name,
                    path: '', parent: AccountWrapperRoute.name),
                RouteConfig('*#redirect',
                    path: '*',
                    parent: AccountWrapperRoute.name,
                    redirectTo: '',
                    fullMatch: true)
              ]),
          RouteConfig('*#redirect',
              path: '*',
              parent: HomeRoute.name,
              redirectTo: 'promotion',
              fullMatch: true)
        ]),
        RouteConfig(PhoneValidationRoute.name, path: '/phone-validation'),
        RouteConfig('*#redirect', path: '*', redirectTo: '/', fullMatch: true)
      ];
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute() : super(SplashRoute.name, path: '/');

  static const String name = 'SplashRoute';
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(HomeRoute.name, path: '/home', initialChildren: children);

  static const String name = 'HomeRoute';
}

/// generated route for
/// [PhoneValidationPage]
class PhoneValidationRoute extends PageRouteInfo<PhoneValidationRouteArgs> {
  PhoneValidationRoute(
      {Key? key,
      required String phoneNumber,
      required void Function() onSuccess})
      : super(PhoneValidationRoute.name,
            path: '/phone-validation',
            args: PhoneValidationRouteArgs(
                key: key, phoneNumber: phoneNumber, onSuccess: onSuccess));

  static const String name = 'PhoneValidationRoute';
}

class PhoneValidationRouteArgs {
  const PhoneValidationRouteArgs(
      {this.key, required this.phoneNumber, required this.onSuccess});

  final Key? key;

  final String phoneNumber;

  final void Function() onSuccess;

  @override
  String toString() {
    return 'PhoneValidationRouteArgs{key: $key, phoneNumber: $phoneNumber, onSuccess: $onSuccess}';
  }
}

/// generated route for
/// [EmptyRouterPage]
class OverviewWrapperRoute extends PageRouteInfo<void> {
  const OverviewWrapperRoute({List<PageRouteInfo>? children})
      : super(OverviewWrapperRoute.name,
            path: 'overview', initialChildren: children);

  static const String name = 'OverviewWrapperRoute';
}

/// generated route for
/// [EmptyRouterPage]
class OrdersWrapperRoute extends PageRouteInfo<void> {
  const OrdersWrapperRoute({List<PageRouteInfo>? children})
      : super(OrdersWrapperRoute.name,
            path: 'orders', initialChildren: children);

  static const String name = 'OrdersWrapperRoute';
}

/// generated route for
/// [EmptyRouterPage]
class AccountWrapperRoute extends PageRouteInfo<void> {
  const AccountWrapperRoute({List<PageRouteInfo>? children})
      : super(AccountWrapperRoute.name, path: 'my', initialChildren: children);

  static const String name = 'AccountWrapperRoute';
}

/// generated route for
/// [OverviewPage]
class OverviewRoute extends PageRouteInfo<void> {
  const OverviewRoute() : super(OverviewRoute.name, path: '');

  static const String name = 'OverviewRoute';
}

/// generated route for
/// [OrdersPage]
class OrdersRoute extends PageRouteInfo<void> {
  const OrdersRoute() : super(OrdersRoute.name, path: '');

  static const String name = 'OrdersRoute';
}

/// generated route for
/// [AccountPage]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute() : super(AccountRoute.name, path: '');

  static const String name = 'AccountRoute';
}
