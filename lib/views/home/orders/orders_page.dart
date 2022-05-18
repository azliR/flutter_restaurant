import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/preferences/preferences_cubit.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.registrationTitle),
        actions: [
          IconButton(
            onPressed: () {
              context.read<PreferencesCubit>().setLocale(const Locale('id'));
            },
            icon: const Icon(Icons.translate),
          ),
        ],
      ),
      body: BlocSelector<RegistrationCubit, RegistrationState, bool>(
        selector: (state) => state.isSubmitting,
        builder: (context, isSubmitting) {
          return ProgressOverlay(
            visible: isSubmitting,
            child: const _RegistrationForms(),
          );
        },
      ),
    );
  }
}

class _RegistrationForms extends StatefulWidget {
  const _RegistrationForms({Key? key}) : super(key: key);

  @override
  State<_RegistrationForms> createState() => _RegistrationFormsState();
}

class _RegistrationFormsState extends State<_RegistrationForms> {
  final _formKey = GlobalKey<FormState>();
  final _scheduleController = TextEditingController();

  Future<void> _onScheduleTap() async {
    final cubit = context.read<RegistrationCubit>();
    final locale = context.read<PreferencesCubit>().state.locale;
    final now = DateTime.now();

    final newSelectedDate = await showDatePicker(
      context: context,
      locale: locale,
      initialDate: cubit.state.registration.schedule,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (newSelectedDate != null) {
      final newSelectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          cubit.state.registration.schedule,
        ),
      );
      if (newSelectedTime != null) {
        final newDateTime = newSelectedDate.add(
          Duration(
            hours: newSelectedTime.hour,
            minutes: newSelectedTime.minute,
          ),
        );
        _scheduleController.text = formatDateTime(
          newDateTime,
          locale: locale,
        );
        cubit.onScheduleChanged(newDateTime);
      }
    }
  }

  Future<void> _onSubmitPressed() async {
    final cubit = context.read<RegistrationCubit>();
    final authCubit = context.read<AuthCubit>();

    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(context.l10n.registrationConfirmTitle),
            content: Text(context.l10n.registrationConfirmMessage),
            actions: [
              TextButton(
                child: Text(context.l10n.cancelButtonLabel),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(context.l10n.confirmButtonLabel),
                onPressed: () async {
                  Navigator.pop(context);
                  if (authCubit.user == null) {
                    context.router.push(
                      PhoneValidationRoute(
                        phoneNumber: cubit.state.registration.phone,
                        onSuccess: () {
                          _onSubmitPressed();
                        },
                      ),
                    );
                  } else {
                    await _submit();
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _submit() async {
    final cubit = context.read<RegistrationCubit>();

    await cubit.onSubmit(
      onSuccess: () {},
      onError: (error) async {
        await showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Gagal mengirim pesanan!'),
              content: Text(error),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('OKE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    _scheduleController.text = formatDateTime(
      DateTime.now().add(const Duration(hours: 1)),
      locale: context.read<PreferencesCubit>().state.locale,
    );
    super.initState();
  }

  @override
  void dispose() {
    _scheduleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegistrationCubit>();

    return BlocListener<PreferencesCubit, PreferencesState>(
      listenWhen: (previous, current) => previous.locale != current.locale,
      listener: (context, state) {
        _scheduleController.text = formatDateTime(
          cubit.state.registration.schedule,
          locale: state.locale,
        );
      },
      child: BlocSelector<RegistrationCubit, RegistrationState, bool>(
        selector: (state) => state.autovalidate,
        builder: (context, autovalidate) {
          return Form(
            key: _formKey,
            autovalidateMode: autovalidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: ListView(
              padding: kListPadding,
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onChanged: cubit.onNameChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.registrationNameEmpty;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: context.l10n.registrationNameLabel,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  minLines: 2,
                  maxLines: 4,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: cubit.onAddressChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.registrationAddressEmpty;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: context.l10n.registrationAddressLabel,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  maxLength: 15,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.next,
                  onChanged: cubit.onPhoneChanged,
                  validator: (value) {
                    if (value == null) {
                      return context.l10n.registrationPhoneEmpty;
                    } else {
                      if (!value.startsWith('08')) {
                        return context.l10n.registrationPhoneStartsWith;
                      } else if (value.length < 10) {
                        return context.l10n.registrationPhoneLength;
                      }
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: context.l10n.registrationPhoneLabel,
                    helperText: 'Nomor telepon aktif untuk dihubungi',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.registrationPointsEmpty;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: context.l10n.registrationPoints,
                    helperText: context.l10n.registrationPointsHelper,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _scheduleController,
                  readOnly: true,
                  onTap: _onScheduleTap,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.calendar_month),
                    labelText: context.l10n.registrationScheduleLabel,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onSubmitPressed,
                  child: Text(context.l10n.registrationRegisterButton),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
