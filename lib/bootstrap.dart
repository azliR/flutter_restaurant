// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_restaurant/firebase_options.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart' as path;

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder, String env) async {
  await runZonedGuarded(
    () async {
      await HydratedBlocOverrides.runZoned(
        () async => runApp(await builder()),
        blocObserver: AppBlocObserver(),
        createStorage: () async {
          final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
          FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

          configureInjection(env);

          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
          FlutterFireUIAuth.configureProviders([
            const PhoneProviderConfiguration(),
          ]);

          FlutterError.onError = (details) {
            log(details.exceptionAsString(), stackTrace: details.stack);
          };

          FlutterNativeSplash.remove();

          return HydratedStorage.build(
            storageDirectory: kIsWeb
                ? HydratedStorage.webStorageDirectory
                : await path.getApplicationSupportDirectory(),
          );
        },
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
