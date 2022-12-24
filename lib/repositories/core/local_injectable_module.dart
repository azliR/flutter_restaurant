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
  String schemeApi = 'http';

  @override
  String hostApi = '54.254.139.132';

  @override
  int portApi = 8080;
}

@dev
@Injectable(as: LocalInjectableModule)
class DevModule extends LocalInjectableModule {
  @override
  String schemeApi = 'http';

  @override
  String hostApi =
      (!kIsWeb && Platform.isAndroid) ? '192.168.117.188' : 'localhost';

  @override
  int portApi = 8080;
}
