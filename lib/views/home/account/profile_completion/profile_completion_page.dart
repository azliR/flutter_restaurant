import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/auth/auth_cubit.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/views/core/misc/dialogs.dart';
import 'package:flutter_restaurant/views/core/widgets/auth_consumer.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ProfileCompletionPage extends StatefulWidget {
  const ProfileCompletionPage({Key? key, this.onComplete}) : super(key: key);

  final void Function()? onComplete;

  @override
  State<ProfileCompletionPage> createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _autovalidate = false;

  @override
  void initState() {
    final cubit = context.read<AuthCubit>();
    _nameController.text = cubit.state.userData?.fullName ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: AuthBuilder(
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  validator:
                      RequiredValidator(errorText: context.l10n.emptyError),
                  keyboardType: TextInputType.name,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: context.l10n.personalInfoFullName,
                    prefixIcon: Icon(
                      Icons.person_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: colorScheme.primary,
                      onPrimary: colorScheme.onPrimary,
                    ),
                    onPressed: () async {
                      setState(() {
                        _autovalidate = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        await cubit.updateProfile(
                          name: _nameController.text.trim(),
                          language: 'en',
                          onComplete: (userData) {
                            showSnackbar(
                              context,
                              context.l10n.personalInfoSuccessfullyUpdated,
                            );
                            if (widget.onComplete != null) {
                              Navigator.pop(context);
                              widget.onComplete?.call();
                            }
                          },
                        );
                      }
                    },
                    child: Text(context.l10n.saveButtonLabel),
                  ),
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: colorScheme.error,
                      onPrimary: colorScheme.onPrimary,
                    ),
                    onPressed: () => cubit.signOut(),
                    child: const Text('Sign out'),
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
