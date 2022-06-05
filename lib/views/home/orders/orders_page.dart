import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/preferences/preferences_cubit.dart';

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
        title: const Text('context.l10n.registrationTitle'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<PreferencesCubit>().setLocale(const Locale('id'));
            },
            icon: const Icon(Icons.translate),
          ),
        ],
      ),
      body: const SizedBox(),
    );
  }
}
