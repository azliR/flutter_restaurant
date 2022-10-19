import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/auth/auth_cubit.dart';
import 'package:flutter_restaurant/views/core/widgets/unauthorised_widget.dart';
import 'package:flutter_restaurant/views/home/account/profile_completion/profile_completion_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (state) => state.authStatus == AuthStatus.authorised,
      builder: (context, isAuthorised) {
        if (isAuthorised) {
          return const ProfileCompletionPage();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: const UnauthorisedWidget(),
          );
        }
      },
    );
  }
}
