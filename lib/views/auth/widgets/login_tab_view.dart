import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/views/core/app_router.dart';
import 'package:flutter_restaurant/views/core/misc/dialogs.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginTabView extends StatefulWidget {
  const LoginTabView({
    Key? key,
    required this.onCompleted,
  }) : super(key: key);

  final VoidCallback? onCompleted;

  @override
  State<LoginTabView> createState() => _LoginTabViewState();
}

class _LoginTabViewState extends State<LoginTabView> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  bool _isAgree = false;
  bool _autovalidate = false;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter phone number',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    context.l10n.signInVerify,
                    textAlign: TextAlign.center,
                    style: textTheme.titleSmall
                        ?.copyWith(color: colorScheme.onBackground),
                  ),
                ),
                const SizedBox(height: 36),
                TextFormField(
                  controller: _phoneNumberController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\+]')),
                  ],
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  validator:
                      RequiredValidator(errorText: context.l10n.emptyError),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '+62896XXXXXXXX',
                    prefixIcon: Icon(
                      Icons.phone_rounded,
                      color: colorScheme.primary,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _isAgree,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      onChanged: (value) {
                        setState(() => _isAgree = value!);
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _isAgree = !_isAgree);
                        },
                        child: Text.rich(
                          TextSpan(
                            text: context.l10n.signInAgreement,
                            children: [
                              TextSpan(
                                text: context.l10n.signInTermAndService,
                                style: textTheme.bodyText2
                                    ?.copyWith(color: colorScheme.primary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              )
                            ],
                            style: textTheme.bodyMedium
                                ?.copyWith(color: colorScheme.onSurface),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: colorScheme.primary,
                      onPrimary: colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      setState(() => _autovalidate = true);

                      if (_formKey.currentState!.validate()) {
                        if (!_isAgree) {
                          showErrorSnackbar(
                            context,
                            context.l10n.signInNeedAgreeError,
                          );
                        } else {
                          context.router.push(
                            OtpRoute(
                              phoneNumber: _phoneNumberController.text.trim(),
                              onCompleted: widget.onCompleted,
                            ),
                          );
                        }
                      }
                    },
                    child: Text(context.l10n.signInContinueButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
