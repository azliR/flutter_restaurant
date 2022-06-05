import 'package:injectable/injectable.dart';

abstract class LocalInjectableModule {
  String get kSchemeApi;
  String get hostApi;
  int get portApi;
  String get mapsApiKey;
}

@prod
@Injectable(as: LocalInjectableModule)
class DevModule extends LocalInjectableModule {
  @override
  String get kSchemeApi => 'https';

  @override
  String hostApi = 'azlir-restaurant-api.herokuapp.com';

  @override
  int portApi = 80;

  @override
  String mapsApiKey = 'AIzaSyC9vJ0ihIE4qnqRPlpE8xgOfoFIjEbH5NE';
}

@dev
@Injectable(as: LocalInjectableModule)
class ProdModule extends LocalInjectableModule {
  @override
  String get kSchemeApi => 'http';

  @override
  String hostApi = 'localhost';

  @override
  int portApi = 8080;

  @override
  String mapsApiKey = 'AIzaSyDUkKN4c_ufoXrBU639kmQT3D7lIUMpF9s';
}
