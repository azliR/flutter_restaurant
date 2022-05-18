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
    PhoneValidationRoute.name: (routeData) {
      final args = routeData.argsAs<PhoneValidationRouteArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: PhoneValidationPage(
              key: args.key,
              phoneNumber: args.phoneNumber,
              onSuccess: args.onSuccess));
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(PhoneValidationRoute.name, path: '/phone-validation'),
        RouteConfig('*#redirect', path: '*', redirectTo: '/', fullMatch: true)
      ];
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
