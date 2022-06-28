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
    SignInRoute.name: (routeData) {
      final args = routeData.argsAs<SignInRouteArgs>(
          orElse: () => const SignInRouteArgs());
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: SignInPage(key: args.key, onCompleted: args.onCompleted));
    },
    OtpRoute.name: (routeData) {
      final args = routeData.argsAs<OtpRouteArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: OtpPage(
              key: args.key,
              onCompleted: args.onCompleted,
              phoneNumber: args.phoneNumber));
    },
    CartRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const CartPage());
    },
    ProfileCompletionRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileCompletionRouteArgs>(
          orElse: () => const ProfileCompletionRouteArgs());
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: ProfileCompletionPage(
              key: args.key, onComplete: args.onComplete));
    },
    OrderStatusRoute.name: (routeData) {
      final args = routeData.argsAs<OrderStatusRouteArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: OrderStatusPage(key: args.key, orderId: args.orderId));
    },
    OverviewWrapperRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    MapWrapperRoute.name: (routeData) {
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
    RestMenuRoute.name: (routeData) {
      final args = routeData.argsAs<RestMenuRouteArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: WrappedRoute(
              child: RestMenuPage(key: args.key, storeId: args.storeId)));
    },
    CustomiseFoodRoute.name: (routeData) {
      final args = routeData.argsAs<CustomiseFoodRouteArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: WrappedRoute(
              child: CustomiseFoodPage(key: args.key, itemId: args.itemId)));
    },
    MapRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: WrappedRoute(child: const MapPage()));
    },
    OrdersRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: WrappedRoute(child: const OrdersPage()));
    },
    OrderDetailRoute.name: (routeData) {
      final args = routeData.argsAs<OrderDetailRouteArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: WrappedRoute(
              child: OrderDetailPage(key: args.key, orderId: args.orderId)));
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
                RouteConfig(RestMenuRoute.name,
                    path: '', parent: OverviewWrapperRoute.name),
                RouteConfig(CustomiseFoodRoute.name,
                    path: '', parent: OverviewWrapperRoute.name),
                RouteConfig('*#redirect',
                    path: '*',
                    parent: OverviewWrapperRoute.name,
                    redirectTo: '',
                    fullMatch: true)
              ]),
          RouteConfig(MapWrapperRoute.name,
              path: 'map',
              parent: HomeRoute.name,
              children: [
                RouteConfig(MapRoute.name,
                    path: '', parent: MapWrapperRoute.name),
                RouteConfig(RestMenuRoute.name,
                    path: '', parent: MapWrapperRoute.name),
                RouteConfig(CustomiseFoodRoute.name,
                    path: '', parent: MapWrapperRoute.name),
                RouteConfig('*#redirect',
                    path: '*',
                    parent: MapWrapperRoute.name,
                    redirectTo: '',
                    fullMatch: true)
              ]),
          RouteConfig(OrdersWrapperRoute.name,
              path: 'orders',
              parent: HomeRoute.name,
              children: [
                RouteConfig(OrdersRoute.name,
                    path: '', parent: OrdersWrapperRoute.name),
                RouteConfig(OrderDetailRoute.name,
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
              redirectTo: 'overview',
              fullMatch: true)
        ]),
        RouteConfig(SignInRoute.name, path: '/signin'),
        RouteConfig(OtpRoute.name, path: '/otp'),
        RouteConfig(CartRoute.name, path: '/cart'),
        RouteConfig(ProfileCompletionRoute.name, path: '/completion'),
        RouteConfig(OrderStatusRoute.name, path: '/order-status'),
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
/// [SignInPage]
class SignInRoute extends PageRouteInfo<SignInRouteArgs> {
  SignInRoute({Key? key, void Function()? onCompleted})
      : super(SignInRoute.name,
            path: '/signin',
            args: SignInRouteArgs(key: key, onCompleted: onCompleted));

  static const String name = 'SignInRoute';
}

class SignInRouteArgs {
  const SignInRouteArgs({this.key, this.onCompleted});

  final Key? key;

  final void Function()? onCompleted;

  @override
  String toString() {
    return 'SignInRouteArgs{key: $key, onCompleted: $onCompleted}';
  }
}

/// generated route for
/// [OtpPage]
class OtpRoute extends PageRouteInfo<OtpRouteArgs> {
  OtpRoute(
      {Key? key,
      required void Function()? onCompleted,
      required String phoneNumber})
      : super(OtpRoute.name,
            path: '/otp',
            args: OtpRouteArgs(
                key: key, onCompleted: onCompleted, phoneNumber: phoneNumber));

  static const String name = 'OtpRoute';
}

class OtpRouteArgs {
  const OtpRouteArgs(
      {this.key, required this.onCompleted, required this.phoneNumber});

  final Key? key;

  final void Function()? onCompleted;

  final String phoneNumber;

  @override
  String toString() {
    return 'OtpRouteArgs{key: $key, onCompleted: $onCompleted, phoneNumber: $phoneNumber}';
  }
}

/// generated route for
/// [CartPage]
class CartRoute extends PageRouteInfo<void> {
  const CartRoute() : super(CartRoute.name, path: '/cart');

  static const String name = 'CartRoute';
}

/// generated route for
/// [ProfileCompletionPage]
class ProfileCompletionRoute extends PageRouteInfo<ProfileCompletionRouteArgs> {
  ProfileCompletionRoute({Key? key, void Function()? onComplete})
      : super(ProfileCompletionRoute.name,
            path: '/completion',
            args: ProfileCompletionRouteArgs(key: key, onComplete: onComplete));

  static const String name = 'ProfileCompletionRoute';
}

class ProfileCompletionRouteArgs {
  const ProfileCompletionRouteArgs({this.key, this.onComplete});

  final Key? key;

  final void Function()? onComplete;

  @override
  String toString() {
    return 'ProfileCompletionRouteArgs{key: $key, onComplete: $onComplete}';
  }
}

/// generated route for
/// [OrderStatusPage]
class OrderStatusRoute extends PageRouteInfo<OrderStatusRouteArgs> {
  OrderStatusRoute({Key? key, required String orderId})
      : super(OrderStatusRoute.name,
            path: '/order-status',
            args: OrderStatusRouteArgs(key: key, orderId: orderId));

  static const String name = 'OrderStatusRoute';
}

class OrderStatusRouteArgs {
  const OrderStatusRouteArgs({this.key, required this.orderId});

  final Key? key;

  final String orderId;

  @override
  String toString() {
    return 'OrderStatusRouteArgs{key: $key, orderId: $orderId}';
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
class MapWrapperRoute extends PageRouteInfo<void> {
  const MapWrapperRoute({List<PageRouteInfo>? children})
      : super(MapWrapperRoute.name, path: 'map', initialChildren: children);

  static const String name = 'MapWrapperRoute';
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
/// [RestMenuPage]
class RestMenuRoute extends PageRouteInfo<RestMenuRouteArgs> {
  RestMenuRoute({Key? key, required String storeId})
      : super(RestMenuRoute.name,
            path: '', args: RestMenuRouteArgs(key: key, storeId: storeId));

  static const String name = 'RestMenuRoute';
}

class RestMenuRouteArgs {
  const RestMenuRouteArgs({this.key, required this.storeId});

  final Key? key;

  final String storeId;

  @override
  String toString() {
    return 'RestMenuRouteArgs{key: $key, storeId: $storeId}';
  }
}

/// generated route for
/// [CustomiseFoodPage]
class CustomiseFoodRoute extends PageRouteInfo<CustomiseFoodRouteArgs> {
  CustomiseFoodRoute({Key? key, required String itemId})
      : super(CustomiseFoodRoute.name,
            path: '', args: CustomiseFoodRouteArgs(key: key, itemId: itemId));

  static const String name = 'CustomiseFoodRoute';
}

class CustomiseFoodRouteArgs {
  const CustomiseFoodRouteArgs({this.key, required this.itemId});

  final Key? key;

  final String itemId;

  @override
  String toString() {
    return 'CustomiseFoodRouteArgs{key: $key, itemId: $itemId}';
  }
}

/// generated route for
/// [MapPage]
class MapRoute extends PageRouteInfo<void> {
  const MapRoute() : super(MapRoute.name, path: '');

  static const String name = 'MapRoute';
}

/// generated route for
/// [OrdersPage]
class OrdersRoute extends PageRouteInfo<void> {
  const OrdersRoute() : super(OrdersRoute.name, path: '');

  static const String name = 'OrdersRoute';
}

/// generated route for
/// [OrderDetailPage]
class OrderDetailRoute extends PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({Key? key, required String orderId})
      : super(OrderDetailRoute.name,
            path: '', args: OrderDetailRouteArgs(key: key, orderId: orderId));

  static const String name = 'OrderDetailRoute';
}

class OrderDetailRouteArgs {
  const OrderDetailRouteArgs({this.key, required this.orderId});

  final Key? key;

  final String orderId;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [AccountPage]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute() : super(AccountRoute.name, path: '');

  static const String name = 'AccountRoute';
}
