import 'package:flutter_restaurant/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
void configureInjection(String env) => getIt.init(environment: env);
