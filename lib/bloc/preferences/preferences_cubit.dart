import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'preferences_state.dart';

@injectable
class PreferencesCubit extends HydratedCubit<PreferencesState> {
  PreferencesCubit() : super(PreferencesState.initial());

  void setLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
  }

  @override
  PreferencesState? fromJson(Map<String, dynamic> json) {
    return PreferencesState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(PreferencesState state) {
    return state.toMap();
  }
}
