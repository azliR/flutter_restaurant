import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/models/enums/enums.dart';
import 'package:flutter_restaurant/views/core/widgets/pill.dart';

class CartOrderTypeTile extends StatefulWidget {
  const CartOrderTypeTile({Key? key}) : super(key: key);

  @override
  State<CartOrderTypeTile> createState() => _CartOrderTypeTileState();
}

class _CartOrderTypeTileState extends State<CartOrderTypeTile> {
  late final TextEditingController _minutesController;
  final _minMinutes = 1;
  final _maxMinutes = 120;

  Future<OrderType?> _changeOrderTypeDialog(
    BuildContext context,
    OrderType orderType,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return showModalBottomSheet<OrderType>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Pill(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Select order type',
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: OrderType.values.length,
                  itemBuilder: (context, index) {
                    final e = OrderType.values[index];

                    return RadioListTile(
                      groupValue: orderType,
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: e,
                      onChanged: (value) => Navigator.pop(context, value),
                      secondary: CircleAvatar(
                        backgroundColor: e.color,
                        child: e.icon,
                      ),
                      title: Text(
                        e.toReadableStringTitle(context),
                        style: textTheme.titleMedium
                            ?.copyWith(color: colorScheme.onBackground),
                      ),
                      subtitle: Text(
                        e.toReadableStringDesc(context),
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.outline),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _minutesController = TextEditingController(
      text: context.read<CartCubit>().state.scheduleMinutes.toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<CartCubit>();

    return BlocListener<CartCubit, CartState>(
      listenWhen: (previous, current) =>
          previous.scheduleMinutes != current.scheduleMinutes,
      listener: (context, state) {
        _minutesController.value = TextEditingValue(
          text: state.scheduleMinutes.toString(),
          selection: TextSelection.fromPosition(
            TextPosition(offset: state.scheduleMinutes.toString().length),
          ),
        );
      },
      child: BlocSelector<CartCubit, CartState, OrderType>(
        selector: (state) => state.orderType,
        builder: (context, orderType) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order type',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: orderType.color,
                    child: orderType.icon,
                  ),
                  title: Text(
                    orderType.toReadableStringTitle(context),
                    style: textTheme.titleMedium
                        ?.copyWith(color: colorScheme.onBackground),
                  ),
                  subtitle: Text(
                    orderType.toReadableStringDesc(context),
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.outline),
                  ),
                  trailing: OutlinedButton(
                    onPressed: () async {
                      final selectedOrderType =
                          await _changeOrderTypeDialog(context, orderType);
                      if (selectedOrderType != null) {
                        cubit.onOrderTypeChanged(selectedOrderType);
                        if (selectedOrderType == OrderType.scheduled) {}
                      }
                    },
                    child: const Text('Change'),
                  ),
                ),
              ),
              if (orderType == OrderType.scheduled)
                Card(
                  margin: const EdgeInsets.only(top: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Schedule order',
                          style: textTheme.titleSmall?.copyWith(
                            color: colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'I will be here in',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 80,
                                    ),
                                    child: TextFormField(
                                      controller: _minutesController,
                                      textAlign: TextAlign.center,
                                      style: textTheme.titleMedium?.copyWith(
                                        color: colorScheme.onBackground,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        _MaxValueFormatter(
                                          _minMinutes,
                                          _maxMinutes,
                                        )
                                      ],
                                      onChanged: (value) {
                                        final newValue = int.tryParse(value);
                                        if (newValue != null) {
                                          cubit.onMinutesChanged(newValue);
                                        }
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        isDense: true,
                                        enabledBorder: Theme.of(context)
                                            .inputDecorationTheme
                                            .enabledBorder
                                            ?.copyWith(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  context.l10n.cartMinutes,
                                  style: textTheme.bodyMedium
                                      ?.copyWith(color: colorScheme.outline),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            BlocSelector<CartCubit, CartState, int>(
                              selector: (state) {
                                return state.scheduleMinutes;
                              },
                              builder: (context, scheduleMinutes) {
                                return Wrap(
                                  runSpacing: 8,
                                  spacing: 8,
                                  children: [
                                    InputChip(
                                      label: const Text('5 min'),
                                      selected: scheduleMinutes == 5,
                                      onPressed: () {
                                        cubit.onMinutesChanged(5);
                                      },
                                    ),
                                    InputChip(
                                      label: const Text('10 min'),
                                      selected: scheduleMinutes == 10,
                                      onPressed: () {
                                        cubit.onMinutesChanged(10);
                                      },
                                    ),
                                    InputChip(
                                      label: const Text('15 min'),
                                      selected: scheduleMinutes == 15,
                                      onPressed: () {
                                        cubit.onMinutesChanged(15);
                                      },
                                    ),
                                    InputChip(
                                      label: const Text('30 min'),
                                      selected: scheduleMinutes == 30,
                                      onPressed: () {
                                        cubit.onMinutesChanged(30);
                                      },
                                    ),
                                    InputChip(
                                      label: const Text('1 hour'),
                                      selected: scheduleMinutes == 60,
                                      onPressed: () {
                                        cubit.onMinutesChanged(60);
                                      },
                                    ),
                                    InputChip(
                                      label: const Text('2 hour'),
                                      selected: scheduleMinutes == 120,
                                      onPressed: () {
                                        cubit.onMinutesChanged(120);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

class _MaxValueFormatter extends TextInputFormatter {
  _MaxValueFormatter(
    this.minValue,
    this.maxValue,
  );

  final int minValue;
  final int maxValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final value = int.tryParse(newValue.text);
    if (value != null) {
      if (value < minValue) {
        return TextEditingValue(
          text: '$minValue',
          selection:
              TextSelection.collapsed(offset: minValue.toString().length),
        );
      } else if (value > maxValue) {
        return TextEditingValue(
          text: '$maxValue',
          selection:
              TextSelection.collapsed(offset: maxValue.toString().length),
        );
      } else {
        return newValue;
      }
    } else {
      return newValue;
    }
  }
}
