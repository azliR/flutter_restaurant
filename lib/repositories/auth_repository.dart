import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRepository {
  AuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  FirebaseAuth get firebaseAuth => _firebaseAuth;

  User? get user => _firebaseAuth.currentUser;
}
