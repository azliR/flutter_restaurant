import 'package:injectable/injectable.dart';

abstract class LocalInjectableModule {
  String get schemeApi;
  String get hostApi;
  int get portApi;
  String get mapsApiKey;
}

@prod
@Injectable(as: LocalInjectableModule)
class DevModule extends LocalInjectableModule {
  @override
  String get schemeApi => 'https';

  @override
  String hostApi = 'azlir-restaurant-api.herokuapp.com';

  @override
  int portApi = 80;

  @override
  String mapsApiKey = 'AIzaSyBC1ogdklGgz86CdT6ylaOW4obelcFt7qc';
}

@dev
@Injectable(as: LocalInjectableModule)
class ProdModule extends LocalInjectableModule {
  @override
  String get schemeApi => 'http';

  @override
  String hostApi = 'localhost';

  @override
  int portApi = 8080;

  @override
  String mapsApiKey = 'AIzaSyBC1ogdklGgz86CdT6ylaOW4obelcFt7qc';
}
