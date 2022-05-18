// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_restaurant/bloc/auth/auth_cubit.dart';
import 'package:flutter_restaurant/bloc/preferences/preferences_cubit.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';
import 'package:flutter_restaurant/views/core/app_theme.dart';
import 'package:flutterfire_ui/i10n.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PreferencesCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<AuthCubit>(),
        ),
      ],
      child: BlocSelector<PreferencesCubit, PreferencesState, Locale>(
        selector: (state) => state.locale,
        builder: (context, locale) {
          return MaterialApp.router(
            title: 'CCTV',
            theme: AppTheme.lightTheme,
            locale: locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              FlutterFireUILocalizations.delegate,
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
