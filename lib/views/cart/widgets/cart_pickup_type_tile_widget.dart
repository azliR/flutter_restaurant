import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart';
import 'package:flutter_restaurant/models/enums/enums.dart';
import 'package:flutter_restaurant/views/core/widgets/pill.dart';

class CartPickupTypeTile extends StatelessWidget {
  const CartPickupTypeTile({super.key});

  Future<PickupType?> _changePickupTypeDialog(
    BuildContext context,
    PickupType pickupType,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return showModalBottomSheet<PickupType>(
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
                  itemCount: PickupType.values.length,
                  itemBuilder: (context, index) {
                    final e = PickupType.values[index];

                    return RadioListTile(
                      groupValue: pickupType,
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
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<CartCubit>();

    return BlocSelector<CartCubit, CartState, PickupType>(
      selector: (state) => state.pickupType,
      builder: (context, pickupType) {
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
                  backgroundColor: pickupType.color,
                  child: pickupType.icon,
                ),
                title: Text(
                  pickupType.toReadableStringTitle(context),
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.onBackground),
                ),
                subtitle: Text(
                  pickupType.toReadableStringDesc(context),
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.outline),
                ),
                trailing: OutlinedButton(
                  onPressed: () async {
                    final selectedPickupType =
                        await _changePickupTypeDialog(context, pickupType);
                    if (selectedPickupType != null) {
                      cubit.onPickupTypeChanged(selectedPickupType);
                    }
                  },
                  child: const Text('Change'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
