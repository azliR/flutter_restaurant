// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:flutter_restaurant/bloc/auth/auth_cubit.dart' as _i16;
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart' as _i17;
import 'package:flutter_restaurant/bloc/home/customise_food/customise_food_cubit.dart'
    as _i14;
import 'package:flutter_restaurant/bloc/home/map/map_cubit.dart' as _i6;
import 'package:flutter_restaurant/bloc/home/overview/overview_cubit.dart'
    as _i9;
import 'package:flutter_restaurant/bloc/home/rest_menu/rest_menu_cubit.dart'
    as _i11;
import 'package:flutter_restaurant/bloc/order/order_detail/order_detail_cubit.dart'
    as _i15;
import 'package:flutter_restaurant/bloc/order/orders/orders_cubit.dart' as _i8;
import 'package:flutter_restaurant/bloc/preferences/preferences_cubit.dart'
    as _i10;
import 'package:flutter_restaurant/repositories/auth_repository.dart' as _i12;
import 'package:flutter_restaurant/repositories/cart_repository.dart' as _i13;
import 'package:flutter_restaurant/repositories/core/firebase_injectable_module.dart'
    as _i18;
import 'package:flutter_restaurant/repositories/core/local_injectable_module.dart'
    as _i5;
import 'package:flutter_restaurant/repositories/home_repository.dart' as _i4;
import 'package:flutter_restaurant/repositories/order_repository.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

const String _prod = 'prod';
const String _dev = 'dev';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final firebaseInjectableModule = _$FirebaseInjectableModule();
  gh.lazySingleton<_i3.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth,);
  gh.lazySingleton<_i4.HomeRepository>(() => _i4.HomeRepository());
  gh.factory<_i5.LocalInjectableModule>(
    () => _i5.ProdModule(),
    registerFor: {_prod},
  );
  gh.factory<_i5.LocalInjectableModule>(
    () => _i5.DevModule(),
    registerFor: {_dev},
  );
  gh.factory<_i6.MapCubit>(() => _i6.MapCubit(get<_i4.HomeRepository>()));
  gh.lazySingleton<_i7.OrderRepository>(
      () => _i7.OrderRepository(get<_i3.FirebaseAuth>()),);
  gh.factory<_i8.OrdersCubit>(
      () => _i8.OrdersCubit(get<_i7.OrderRepository>()),);
  gh.factory<_i9.OverviewCubit>(
      () => _i9.OverviewCubit(get<_i4.HomeRepository>()),);
  gh.factory<_i10.PreferencesCubit>(() => _i10.PreferencesCubit());
  gh.factory<_i11.RestMenuCubit>(
      () => _i11.RestMenuCubit(get<_i4.HomeRepository>()),);
  gh.lazySingleton<_i12.AuthRepository>(
      () => _i12.AuthRepository(get<_i3.FirebaseAuth>()),);
  gh.lazySingleton<_i13.CartRepository>(
      () => _i13.CartRepository(get<_i3.FirebaseAuth>()),);
  gh.factory<_i14.CustomiseFoodCubit>(
      () => _i14.CustomiseFoodCubit(get<_i4.HomeRepository>()),);
  gh.factory<_i15.OrderDetailCubit>(
      () => _i15.OrderDetailCubit(get<_i7.OrderRepository>()),);
  gh.factory<_i16.AuthCubit>(() => _i16.AuthCubit(get<_i12.AuthRepository>()));
  gh.factory<_i17.CartCubit>(() => _i17.CartCubit(get<_i13.CartRepository>()));
  return get;
}

class _$FirebaseInjectableModule extends _i18.FirebaseInjectableModule {}
