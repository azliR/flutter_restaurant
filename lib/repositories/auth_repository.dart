import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/models/auth/user_data.dart';
import 'package:flutter_restaurant/repositories/core/local_injectable_module.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRepository {
  AuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  String? _verificationId;
  int? _forceResendingToken;
  ConfirmationResult? _confirmationResult;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String? message) onCodeSent,
    required void Function(UserData userData) onCompleted,
    required void Function(String? message) onError,
  }) async {
    try {
      if (kIsWeb ||
          Platform.isLinux ||
          Platform.isMacOS ||
          Platform.isWindows) {
        _confirmationResult =
            await _firebaseAuth.signInWithPhoneNumber(phoneNumber);
        onCodeSent('SMS has been sent');
      } else {
        await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          forceResendingToken: _forceResendingToken,
          verificationCompleted: (phoneAuthCredential) async {
            final user = _firebaseAuth.currentUser;
            String token;
            if (user != null) {
              await user.updatePhoneNumber(phoneAuthCredential);
              token = await user.getIdToken(true);
            } else {
              final userCredential =
                  await _firebaseAuth.signInWithCredential(phoneAuthCredential);
              token = await userCredential.user!.getIdToken(true);
            }

            await login(
              token: token,
              phone: phoneNumber,
              onCompleted: onCompleted,
              onError: onError,
            );

            _verificationId = null;
            _forceResendingToken = null;
          },
          verificationFailed: (error) {
            onError(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            _verificationId = verificationId;
            _forceResendingToken = forceResendingToken;
            onCodeSent('SMS has been sent');
          },
          codeAutoRetrievalTimeout: (verificationId) {
            _verificationId = verificationId;
          },
        );
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(e.toString());
    }
  }

  Future<void> verifyOtp({
    required String otp,
    required void Function(UserData userData) onCompleted,
    required void Function(String? message) onError,
  }) async {
    try {
      String token;
      String phone;

      if (kIsWeb ||
          Platform.isLinux ||
          Platform.isMacOS ||
          Platform.isWindows) {
        final userCredential = await _confirmationResult!.confirm(otp);
        final user = userCredential.user!;
        token = await user.getIdToken(true);
        phone = user.phoneNumber!;

        _confirmationResult = null;
      } else {
        final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: otp,
        );
        final user = _firebaseAuth.currentUser;
        user?.reload();
        if (user != null) {
          await user.updatePhoneNumber(credential);
          await _firebaseAuth.currentUser!.reload();
          token = await user.getIdToken(true);
          phone = user.phoneNumber!;
        } else {
          final userCredential =
              await _firebaseAuth.signInWithCredential(credential);
          final user = userCredential.user!;
          token = await user.getIdToken(true);
          phone = user.phoneNumber!;
        }
      }

      await login(
        token: token,
        phone: phone,
        onCompleted: onCompleted,
        onError: onError,
      );
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(e.toString());
    }
  }

  Future<void> login({
    required String token,
    required String phone,
    required void Function(UserData userData) onCompleted,
    required void Function(String? message) onError,
  }) async {
    try {
      final url = Uri(
        scheme: getIt<LocalInjectableModule>().schemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/user/auth',
      );
      final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );
      final body = (jsonDecode(response.body) as Map).cast<String, dynamic>();
      if (response.statusCode == 200) {
        final userData =
            UserData.fromJson(body['data'] as Map<String, dynamic>);
        onCompleted(userData);
      } else {
        final e = body['message'] as String?;
        onError(e);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(e.toString());
    }
  }

  Future<void> getProfile({
    required void Function(UserData userData) onCompleted,
    required void Function(String? message) onError,
  }) async {
    try {
      final token = await _firebaseAuth.currentUser!.getIdToken();
      final url = Uri(
        scheme: getIt<LocalInjectableModule>().schemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/user/profile',
      );
      final response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      );
      final body = jsonDecode(response.body) as Map;
      if (response.statusCode == 200) {
        onCompleted(UserData.fromJson((body['data'] as Map).cast()));
      } else {
        onError(body['message'] as String?);
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(e.toString());
    }
  }

  Future<void> updateProfile({
    required String name,
    required String language,
    required void Function(UserData userData) onCompleted,
    required void Function(String? message) onError,
  }) async {
    try {
      final token = await _firebaseAuth.currentUser!.getIdToken();
      final url = Uri(
        scheme: getIt<LocalInjectableModule>().schemeApi,
        host: getIt<LocalInjectableModule>().hostApi,
        port: getIt<LocalInjectableModule>().portApi,
        path: '/api/v1/user/profile',
      );
      final response = await http.put(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({
          'full_name': name,
          'language': language,
        }),
      );
      final body = jsonDecode(response.body) as Map;
      if (response.statusCode == 200) {
        onCompleted(UserData.fromJson((body['data'] as Map).cast()));
      } else {
        onError(body['message'].toString());
      }
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(e.toString());
    }
  }

  Future<void> signOut({
    required void Function() onCompleted,
    required void Function(String? message) onError,
  }) async {
    try {
      await _firebaseAuth.signOut();
      await HydratedBlocOverrides.current?.storage.clear();
      onCompleted();
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      onError(e.toString());
    }
  }
}
