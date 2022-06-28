import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';

class UnauthorisedWidget extends StatelessWidget {
  const UnauthorisedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FlutterLogo(size: 64),
              const SizedBox(height: 8),
              Text(
                'Sign in to view this page',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                child: const Text('Sign in'),
                onPressed: () {
                  context.router.push(
                    SignInRoute(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
