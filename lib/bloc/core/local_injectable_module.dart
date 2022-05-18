import 'package:injectable/injectable.dart';

abstract class LocalInjectableModule {
  final kScheme = 'https';
  String get host;
  String get mapsApiKey;
}

@prod
@Injectable(as: LocalInjectableModule)
class DevModule extends LocalInjectableModule {
  @override
  String host = 'ae.drivo.ru';

  @override
  String mapsApiKey = 'AIzaSyC9vJ0ihIE4qnqRPlpE8xgOfoFIjEbH5NE';
}

@dev
@Injectable(as: LocalInjectableModule)
class ProdModule extends LocalInjectableModule {
  @override
  String host = 'backend.drivo.ru';

  @override
  String mapsApiKey = 'AIzaSyDUkKN4c_ufoXrBU639kmQT3D7lIUMpF9s';
}
