// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/auth/auth_cubit.dart';
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart';
import 'package:flutter_restaurant/bloc/preferences/preferences_cubit.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<PreferencesCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<AuthCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<CartCubit>(),
        ),
      ],
      child: BlocBuilder<PreferencesCubit, PreferencesState>(
        buildWhen: (previous, current) =>
            previous.locale != current.locale ||
            previous.themeMode != current.themeMode,
        builder: (context, state) {
          final lightColorScheme =
              ColorScheme.fromSeed(seedColor: const Color(0xFFd17d21));
          final darkColorScheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFFd17d21),
            brightness: Brightness.dark,
          );
          final textTheme = GoogleFonts.plusJakartaSansTextTheme();

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Restaurant',
            themeMode: state.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.deepOrange,
              cardTheme: const CardTheme(
                shadowColor: Colors.transparent,
                margin: EdgeInsets.zero,
              ),
              textTheme: textTheme,
              inputDecorationTheme: const InputDecorationTheme(filled: true),
              chipTheme: ChipThemeData(
                elevation: 0,
                pressElevation: 0,
                backgroundColor: lightColorScheme.surface,
                selectedColor: lightColorScheme.primaryContainer,
                selectedShadowColor: Colors.transparent,
                labelStyle: textTheme.bodyMedium
                    ?.copyWith(color: lightColorScheme.onSurface),
                side: BorderSide(color: lightColorScheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              snackBarTheme: const SnackBarThemeData(
                behavior: SnackBarBehavior.floating,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.deepOrange,
              cardTheme: const CardTheme(
                shadowColor: Colors.transparent,
                margin: EdgeInsets.zero,
              ),
              textTheme: textTheme,
              inputDecorationTheme: const InputDecorationTheme(filled: true),
              chipTheme: ChipThemeData(
                elevation: 0,
                pressElevation: 0,
                backgroundColor: darkColorScheme.surface,
                selectedColor: darkColorScheme.primaryContainer,
                selectedShadowColor: Colors.transparent,
                labelStyle: textTheme.bodyMedium
                    ?.copyWith(color: darkColorScheme.onSurface),
                side: BorderSide(color: darkColorScheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              snackBarTheme: const SnackBarThemeData(
                behavior: SnackBarBehavior.floating,
              ),
            ),
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            routeInformationParser: _appRouter.defaultRouteParser(),
            routerDelegate: _appRouter.delegate(),
          );
        },
      ),
    );
  }
}
