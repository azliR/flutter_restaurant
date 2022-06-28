import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/bloc/cart/cart_cubit.dart';
import 'package:flutter_restaurant/l10n/l10n.dart';
import 'package:flutter_restaurant/views/core/misc/utils.dart';

class CartSummary extends StatefulWidget {
  const CartSummary({Key? key}) : super(key: key);

  @override
  _CartSummaryState createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (previous, current) =>
          previous.carts != current.carts ||
          previous.discount != current.discount ||
          previous.isCouponLoading != current.isCouponLoading ||
          previous.couponFailure != current.couponFailure,
      builder: (context, state) {
        final subtotal = context.read<CartCubit>().subtotal;
        final total = context.read<CartCubit>().total;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.cartApplyCoupon,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _couponController,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                labelText: context.l10n.cartApplyCouponHint,
                errorText: state.couponFailure?.message,
                suffixIcon: state.isCouponLoading
                    ? const SizedBox(
                        width: 24,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed: () {},
                        child: Text(context.l10n.cartVerifyCoupon),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _CartDetailTile(
                      labelText: context.l10n.cartSubtotal,
                      value: subtotal,
                    ),
                    _CartDetailTile(
                      labelText: context.l10n.cartCoupon,
                      value: state.discount?.discAmount ?? 0,
                    ),
                    const Divider(),
                    _CartDetailTile(
                      labelText: context.l10n.cartTotal,
                      value: total,
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class _CartDetailTile extends StatelessWidget {
  const _CartDetailTile({
    Key? key,
    required this.labelText,
    required this.value,
    this.isTotal = false,
  }) : super(key: key);

  final String labelText;
  final num value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelText,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            formatCurrency(value),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
