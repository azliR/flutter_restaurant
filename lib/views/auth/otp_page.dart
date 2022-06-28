import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/auth/auth_cubit.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/views/core/misc/asset_images.dart';
import 'package:flutter_restaurant/views/core/widgets/auth_consumer.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return Scaffold(
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
          child: ListView(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: BackButton(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: SvgPicture.asset(
                  kAppLogoImagePng,
                  width: 108,
                ),
              ),
              Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Column(
                      children: [
                        Text(
                          context.l10n.otpTitle,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            context.l10n.otpSubtitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        const SizedBox(height: 36),
                        TextField(
                          controller: _otpController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: context.l10n.otpEnterOtpHint,
                            prefixIcon: Icon(
                              Icons.password_rounded,
                              color: Theme.of(context).colorScheme.primary,
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
                                  textStyle:
                                      Theme.of(context).textTheme.subtitle2,
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
                            onPressed: () {
                              context.read<AuthCubit>().verifyOtp(
                                  _otpController.text.trim(),
                                  widget.phoneNumber);
                            },
                            child: Text(context.l10n.otpLoginButton),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
