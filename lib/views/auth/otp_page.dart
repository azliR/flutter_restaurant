import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/auth/auth_cubit.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/views/core/widgets/auth_consumer.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({
    Key? key,
    required this.onCompleted,
    required this.phoneNumber,
  }) : super(key: key);

  final VoidCallback? onCompleted;

  final String phoneNumber;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  int second = 0;
  int maxSecond = 30;

  Timer? _timer;

  void setTimer() {
    setState(() => second = maxSecond);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (second != 0) {
        setState(() => second = maxSecond - timer.tick);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    context.read<AuthCubit>().verifyPhoneNumber(widget.phoneNumber);
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.authStatus != current.authStatus,
            listener: (context, state) {
              Navigator.pop(context);
              Navigator.pop(context);
              widget.onCompleted?.call();
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                current.infoMessage != null &&
                previous.infoMessage != current.infoMessage,
            listener: (context, state) {
              setTimer();
            },
          ),
        ],
        child: AuthBuilder(
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.otpTitle,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        context.l10n.otpSubtitle,
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall
                            ?.copyWith(color: colorScheme.onBackground),
                      ),
                    ),
                    const SizedBox(height: 36),
                    TextField(
                      controller: _otpController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: context.l10n.otpEnterOtpHint,
                        prefixIcon: Icon(
                          Icons.password_rounded,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (previous, current) =>
                            previous.isLoading && !current.isLoading,
                        builder: (context, state) {
                          return TextButton(
                            style: TextButton.styleFrom(
                              textStyle: textTheme.subtitle2,
                            ),
                            onPressed: second == 0
                                ? () => context
                                    .read<AuthCubit>()
                                    .verifyPhoneNumber(widget.phoneNumber)
                                : null,
                            child: Text(
                              second == 0
                                  ? context.l10n.otpResendOtpButton
                                  : context.l10n.otpResendIn(second),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: colorScheme.primary,
                          onPrimary: colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          context.read<AuthCubit>().verifyOtp(
                                _otpController.text.trim(),
                                widget.phoneNumber,
                              );
                        },
                        child: Text(context.l10n.otpLoginButton),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
