import 'package:flutter/material.dart';
import 'package:flutter_restaurant/views/auth/widgets/login_tab_view.dart';
import 'package:flutter_restaurant/views/core/widgets/auth_consumer.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    Key? key,
    this.onCompleted,
  }) : super(key: key);

  final VoidCallback? onCompleted;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return AuthListener(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign In'),
        ),
        body: AuthListener(
          child: LoginTabView(
            onCompleted: widget.onCompleted,
          ),
        ),
      ),
    );
  }
}
