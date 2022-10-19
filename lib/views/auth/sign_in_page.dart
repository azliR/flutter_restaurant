import 'package:flutter/material.dart';
import 'package:flutter_restaurant/views/auth/widgets/login_tab_view.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
    this.onCompleted,
  });

  final VoidCallback? onCompleted;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Number Verification'),
      ),
      body: LoginTabView(
        onCompleted: widget.onCompleted,
      ),
    );
  }
}
