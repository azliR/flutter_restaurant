import 'package:firebase_auth/firebase_auth.dart' hide PhoneVerificationFailed;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/injection.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:flutter_restaurant/views/core/widgets/progress_overlay.dart';
import 'package:flutterfire_ui/auth.dart';

class PhoneValidationPage extends StatefulWidget {
  const PhoneValidationPage({
    Key? key,
    required this.phoneNumber,
    required this.onSuccess,
  }) : super(key: key);

  final String phoneNumber;
  final void Function() onSuccess;

  @override
  State<PhoneValidationPage> createState() => _PhoneValidationPageState();
}

class _PhoneValidationPageState extends State<PhoneValidationPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    _phoneController.text = widget.phoneNumber;
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = getIt<FirebaseAuth>();
    final flowKey = Object();

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: AuthFlowBuilder<PhoneAuthController>(
            auth: firebaseAuth,
            listener: (oldState, newState, controller) {
              if (newState is PhoneVerified) {
                controller.signIn(newState.credential);
                widget.onSuccess();
                Navigator.pop(context);
              }
            },
            builder: (context, state, controller, child) {
              if (state is AwaitingPhoneNumber || state is SMSCodeRequested) {
                return ProgressOverlay(
                  visible: state is SMSCodeRequested,
                  child: ListView(
                    padding: kListPadding,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20).copyWith(top: 40),
                        child: Icon(
                          Icons.phone,
                          color: Colors.blue,
                          size: MediaQuery.of(context).size.width / 4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.phoneValidationEnterPhoneTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.phoneValidationEnterPhoneMessage,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 15,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        // onChanged: cubit.onPhoneChanged,
                        validator: (value) {
                          if (value == null) {
                            return context.l10n.phoneValidationPhoneEmpty;
                          } else {
                            if (!value.startsWith('08')) {
                              return context
                                  .l10n.phoneValidationPhoneStartsWith;
                            } else if (value.length < 10) {
                              return context.l10n.phoneValidationPhoneLength;
                            }
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: context.l10n.phoneValidationPhoneLabel,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            controller.acceptPhoneNumber(
                              _phoneController.text.replaceFirst('0', '+62'),
                            );
                          }
                        },
                        child: Text(
                            context.l10n.phoneValidationCodeSendCodeButton,),
                      ),
                    ],
                  ),
                );
              } else if (state is SMSCodeSent) {
                return ListView(
                  padding: kListPadding,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20).copyWith(top: 40),
                      child: Icon(
                        Icons.sms_rounded,
                        color: Colors.blue,
                        size: MediaQuery.of(context).size.width / 4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.phoneValidationEnterCodeTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.phoneValidationEnterCodeMessage,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    SMSCodeInputView(
                      flowKey: flowKey,
                      auth: firebaseAuth,
                    ),
                  ],
                );
              } else if (state is PhoneVerificationFailed) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.phoneValidationVerificationFailedTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.phoneValidationVerificationFailedMessage,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(context.l10n.backButtonLabel),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
