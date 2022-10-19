import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

abstract class LocalInjectableModule {
  String get schemeApi;
  String get hostApi;
  int get portApi;
}

@prod
@Injectable(as: LocalInjectableModule)
class ProdModule extends LocalInjectableModule {
  @override
  String schemeApi = 'https';

  @override
  String hostApi = 'azlir-restaurant-api.herokuapp.com';

  @override
  int portApi = 443;
}

@dev
@Injectable(as: LocalInjectableModule)
class DevModule extends LocalInjectableModule {
  @override
  String schemeApi = 'http';

  @override
  String hostApi =
      (!kIsWeb && Platform.isAndroid) ? '192.168.0.142' : 'localhost';

  @override
  int portApi = 8080;
}
