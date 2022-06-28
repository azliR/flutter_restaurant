// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_auth/firebase_auth.dart' as _i4;
import 'package:flutter_restaurant/bloc/auth/auth_cubit.dart' as _i17;
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart' as _i14;
import 'package:flutter_restaurant/bloc/home/customise_food/customise_food_cubit.dart'
    as _i15;
import 'package:flutter_restaurant/bloc/home/map/map_cubit.dart' as _i7;
import 'package:flutter_restaurant/bloc/home/overview/overview_cubit.dart'
    as _i10;
import 'package:flutter_restaurant/bloc/home/rest_menu/rest_menu_cubit.dart'
    as _i12;
import 'package:flutter_restaurant/bloc/order/order_detail/order_detail_cubit.dart'
    as _i16;
import 'package:flutter_restaurant/bloc/order/orders/orders_cubit.dart' as _i9;
import 'package:flutter_restaurant/bloc/preferences/preferences_cubit.dart'
    as _i11;
import 'package:flutter_restaurant/repositories/auth_repository.dart' as _i13;
import 'package:flutter_restaurant/repositories/cart_repository.dart' as _i3;
import 'package:flutter_restaurant/repositories/core/firebase_injectable_module.dart'
    as _i18;
import 'package:flutter_restaurant/repositories/core/local_injectable_module.dart'
    as _i6;
import 'package:flutter_restaurant/repositories/home_repository.dart' as _i5;
import 'package:flutter_restaurant/repositories/order_repository.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

const String _prod = 'prod';
const String _dev = 'dev';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final firebaseInjectableModule = _$FirebaseInjectableModule();
  gh.lazySingleton<_i3.CartRepository>(() => _i3.CartRepository());
  gh.lazySingleton<_i4.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth);
  gh.lazySingleton<_i5.HomeRepository>(() => _i5.HomeRepository());
  gh.factory<_i6.LocalInjectableModule>(() => _i6.DevModule(),
      registerFor: {_prod});
  gh.factory<_i6.LocalInjectableModule>(() => _i6.ProdModule(),
      registerFor: {_dev});
  gh.factory<_i7.MapCubit>(() => _i7.MapCubit(get<_i5.HomeRepository>()));
  gh.lazySingleton<_i8.OrderRepository>(() => _i8.OrderRepository());
  gh.factory<_i9.OrdersCubit>(
      () => _i9.OrdersCubit(get<_i8.OrderRepository>()));
  gh.factory<_i10.OverviewCubit>(
      () => _i10.OverviewCubit(get<_i5.HomeRepository>()));
  gh.factory<_i11.PreferencesCubit>(() => _i11.PreferencesCubit());
  gh.factory<_i12.RestMenuCubit>(
      () => _i12.RestMenuCubit(get<_i5.HomeRepository>()));
  gh.lazySingleton<_i13.AuthRepository>(
      () => _i13.AuthRepository(get<_i4.FirebaseAuth>()));
  gh.factory<_i14.CartCubit>(() => _i14.CartCubit(get<_i3.CartRepository>()));
  gh.factory<_i15.CustomiseFoodCubit>(
      () => _i15.CustomiseFoodCubit(get<_i5.HomeRepository>()));
  gh.factory<_i16.OrderDetailCubit>(
      () => _i16.OrderDetailCubit(get<_i8.OrderRepository>()));
  gh.factory<_i17.AuthCubit>(() => _i17.AuthCubit(get<_i13.AuthRepository>()));
  return get;
}

class _$FirebaseInjectableModule extends _i18.FirebaseInjectableModule {}
