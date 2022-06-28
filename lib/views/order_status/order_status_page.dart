import 'package:flutter/material.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class OrderStatusPage extends StatelessWidget {
  const OrderStatusPage({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Status'),
      ),
      body: ListView(
        padding: kListPadding,
        children: [
          Center(
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        PrettyQr(
                          data: orderId,
                          size: constraints.maxWidth > 200
                              ? 200
                              : constraints.maxWidth,
                          roundEdges: true,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: constraints.maxWidth > 200
                              ? 200
                              : constraints.maxWidth,
                          child: Text(
                            orderId,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Show this QR code to the store to confirm your order.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
