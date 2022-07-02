import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
    emit(
      state.copyWith(
        isLoading: true,
        infoMessage: null,
        errorMessage: null,
      ),
    );

    await _authRepository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: (message) {
        emit(
          state.copyWith(
            infoMessage: message,
            isLoading: false,
          ),
        );
      },
      onCompleted: (userData) {
        emit(
          state.copyWith(
            userData: optionOf(userData),
            isLoading: false,
            authStatus: AuthStatus.authorised,
            isSkipped: false,
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

  Future<void> verifyOtp(String otp, String phoneNumber) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );
    await _authRepository.verifyOtp(
      otp: otp,
      onCompleted: (userData) {
        emit(
          state.copyWith(
            userData: optionOf(userData),
            isLoading: false,
            authStatus: AuthStatus.authorised,
            isSkipped: false,
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

  Future<void> updateProfile({
    required String name,
    required String language,
    required Function(UserData userData) onComplete,
  }) async {
    if (name != state.userData?.fullName) {
      emit(
        state.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      );

      await _authRepository.updateProfile(
        name: name,
        language: language,
        onCompleted: (userData) {
          emit(
            state.copyWith(
              userData: optionOf(userData),
              isLoading: false,
            ),
          );
          onComplete(userData);
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
    } else {
      onComplete(state.userData!);
    }
  }

  Future<void> signOut() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );

    await _authRepository.signOut(
      onCompleted: () {
        emit(
          state.copyWith(
            userData: optionOf(null),
            isLoading: false,
            authStatus: AuthStatus.unauthorised,
            isSkipped: false,
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

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.toJson();
  }
}
