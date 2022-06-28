import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/models/auth/auth_token.dart';
import 'package:flutter_restaurant/models/auth/user_data.dart';
import 'package:flutter_restaurant/repositories/auth_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit(
    this._authRepository,
  ) : super(AuthState.initial());

  final AuthRepository _authRepository;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    emit(state.copyWith(
      isLoading: true,
      infoMessage: null,
      errorMessage: null,
    ));

    await _authRepository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: (message) {
        emit(state.copyWith(
          infoMessage: message,
          isLoading: false,
        ));
      },
      onCompleted: () {
        emit(state.copyWith(
          // authToken: optionOf(authToken),
          // userData: optionOf(userData),
          isLoading: false,
          authStatus: AuthStatus.authorised,
          isSkipped: false,
        ));
      },
      onError: (message) {
        emit(state.copyWith(
          errorMessage: message,
          isLoading: false,
        ));
      },
    );
  }

  Future<void> verifyOtp(String otp, String phoneNumber) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));
    emit(state.copyWith(
      // authToken: optionOf(authToken),
      userData: optionOf(UserData(
        id: '1c7b3156-986b-487b-8d6c-2db03806ca30',
        fullName: '',
        createdAt: DateTime.now(),
        phone: phoneNumber,
        languageCode: 'en',
      )),
      isLoading: false,
      authStatus: AuthStatus.authorised,
      isSkipped: false,
    ));
    // await _authRepository.verifyOtp(
    //   otp: otp,
    //   onCompleted: (userData) {
    //     emit(state.copyWith(
    //       // authToken: optionOf(authToken),
    //       userData: optionOf(userData),
    //       isLoading: false,
    //       authStatus: AuthStatus.authorised,
    //       isSkipped: false,
    //     ));
    //   },
    //   onError: (message) {
    //     emit(state.copyWith(
    //       errorMessage: message,
    //       isLoading: false,
    //     ));
    //   },
    // );
  }

  Future<void> updateProfile({
    required String name,
    required String language,
  }) async {
    if (name != state.userData?.fullName) {
      emit(
        state.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      );

      await _authRepository.updateProfile(
        // token: state.authToken!.token,
        token: state.userData!.id,
        name: name,
        language: language,
        onCompleted: (userData) {
          emit(
            state.copyWith(
              userData: optionOf(userData),
              isLoading: false,
            ),
          );
        },
        onError: (message) {
          emit(
            state.copyWith(
              errorMessage: message,
              isLoading: false,
            ),
          );
        },
      );
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));

    await _authRepository.signOut(
      onCompleted: () {
        emit(state.copyWith(
          userData: optionOf(null),
          authToken: optionOf(null),
          isLoading: false,
          authStatus: AuthStatus.unauthorised,
          isSkipped: false,
        ));
      },
      onError: (message) {
        emit(state.copyWith(
          errorMessage: message,
          isLoading: false,
        ));
      },
    );
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.toJson();
  }
}
