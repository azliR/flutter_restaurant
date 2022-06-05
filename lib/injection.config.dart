// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'bloc/auth/auth_cubit.dart' as _i11;
import 'bloc/home/overview/overview_cubit.dart' as _i10;
import 'bloc/preferences/preferences_cubit.dart' as _i8;
import 'repositories/auth_repository.dart' as _i9;
import 'repositories/core/firebase_injectable_module.dart' as _i12;
import 'repositories/core/local_injectable_module.dart' as _i6;
import 'repositories/home_repository.dart' as _i5;
import 'repositories/order_repository.dart' as _i7;

const String _prod = 'prod';
const String _dev = 'dev';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final firebaseInjectableModule = _$FirebaseInjectableModule();
  gh.lazySingleton<_i3.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth);
  gh.lazySingleton<_i4.FirebaseFirestore>(
      () => firebaseInjectableModule.firestore);
  gh.lazySingleton<_i5.HomeRepository>(() => _i5.HomeRepository());
  gh.factory<_i6.LocalInjectableModule>(() => _i6.DevModule(),
      registerFor: {_prod});
  gh.factory<_i6.LocalInjectableModule>(() => _i6.ProdModule(),
      registerFor: {_dev});
  gh.lazySingleton<_i7.OrderRepository>(() => _i7.OrderRepository());
  gh.factory<_i8.PreferencesCubit>(() => _i8.PreferencesCubit());
  gh.lazySingleton<_i9.AuthRepository>(
      () => _i9.AuthRepository(get<_i3.FirebaseAuth>()));
  gh.factory<_i10.HomeCubit>(() => _i10.HomeCubit(get<_i5.HomeRepository>()));
  gh.factory<_i11.AuthCubit>(() => _i11.AuthCubit(get<_i9.AuthRepository>()));
  return get;
}

class _$FirebaseInjectableModule extends _i12.FirebaseInjectableModule {}
