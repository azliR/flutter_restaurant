import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_restaurant/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._authRepository,
  ) : super(AuthInitial());

  final AuthRepository _authRepository;

  FirebaseAuth get firebaseAuth => _authRepository.firebaseAuth;

  User? get user => _authRepository.user;
}
