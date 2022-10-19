import 'package:flutter/material.dart';

class Pill extends StatelessWidget {
  const Pill({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        width: 48,
        height: 4,
        decoration: BoxDecoration(
          color: colorScheme.outline.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
