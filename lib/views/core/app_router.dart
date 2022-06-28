import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_restaurant/views/auth/otp_page.dart';
import 'package:flutter_restaurant/views/auth/sign_in_page.dart';
import 'package:flutter_restaurant/views/cart/cart_page.dart';
import 'package:flutter_restaurant/views/home/account/account_page.dart';
import 'package:flutter_restaurant/views/home/account/profile_completion/profile_completion_page.dart';
import 'package:flutter_restaurant/views/home/home_page.dart';
import 'package:flutter_restaurant/views/home/map/map_page.dart';
import 'package:flutter_restaurant/views/home/orders/order_detail/order_detail_page.dart';
import 'package:flutter_restaurant/views/home/orders/orders_page.dart';
import 'package:flutter_restaurant/views/home/overview/customise_food/customise_food_page.dart';
import 'package:flutter_restaurant/views/home/overview/overview_page.dart';
import 'package:flutter_restaurant/views/home/overview/rest_menu/rest_menu_page.dart';
import 'package:flutter_restaurant/views/order_status/order_status_page.dart';
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
            AutoRoute(path: '', page: RestMenuPage),
            AutoRoute(path: '', page: CustomiseFoodPage),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: 'map',
          page: EmptyRouterPage,
          name: 'MapWrapperRoute',
          children: [
            AutoRoute(path: '', page: MapPage),
            AutoRoute(path: '', page: RestMenuPage),
            AutoRoute(path: '', page: CustomiseFoodPage),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: 'orders',
          page: EmptyRouterPage,
          name: 'OrdersWrapperRoute',
          children: [
            AutoRoute(path: '', page: OrdersPage),
            AutoRoute(path: '', page: OrderDetailPage),
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
        RedirectRoute(path: '*', redirectTo: 'overview'),
      ],
    ),
    AutoRoute(
      path: '/signin',
      page: SignInPage,
    ),
    AutoRoute(
      path: '/otp',
      page: OtpPage,
    ),
    AutoRoute(
      path: '/cart',
      page: CartPage,
    ),
    AutoRoute(
      path: '/completion',
      page: ProfileCompletionPage,
    ),
    AutoRoute(
      path: '/order-status',
      page: OrderStatusPage,
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class AppRouter extends _$AppRouter {}
