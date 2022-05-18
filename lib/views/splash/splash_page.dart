import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    context.router.pushAndPopUntil(
      PhoneValidationRoute(
        phoneNumber: phoneNumber,
        onSuccess: onSuccess,
      ),
      predicate: (_) => false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
