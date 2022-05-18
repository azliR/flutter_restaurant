import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_restaurant/views/auth/phone_validation_page.dart';
import 'package:flutter_restaurant/views/home/account/report_page.dart';
import 'package:flutter_restaurant/views/home/home_page.dart';
import 'package:flutter_restaurant/views/home/orders/orders_page.dart';
import 'package:flutter_restaurant/views/home/overview/overview_page.dart';
import 'package:flutter_restaurant/views/splash/splash_page.dart';

part 'app_router.gr.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(
      path: '/',
      page: SplashPage,
    ),
    AutoRoute(
      path: '/home',
      page: HomePage,
      children: [
        AutoRoute(
          path: 'overview',
          page: EmptyRouterPage,
          name: 'OverviewWrapperRoute',
          children: [
            AutoRoute(path: '', page: OverviewPage),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: 'orders',
          page: EmptyRouterPage,
          name: 'OrdersWrapperRoute',
          children: [
            AutoRoute(path: '', page: OrdersPage),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: 'my',
          page: EmptyRouterPage,
          name: 'AccountWrapperRoute',
          children: [
            AutoRoute(path: '', page: AccountPage),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        RedirectRoute(path: '*', redirectTo: 'promotion'),
      ],
    ),
    AutoRoute(
      path: '/phone-validation',
      page: PhoneValidationPage,
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class AppRouter extends _$AppRouter {}
