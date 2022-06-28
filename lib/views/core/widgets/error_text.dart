import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({
    Key? key,
    required this.message,
    this.error,
    this.stackTrace,
    required this.onRetry,
  }) : super(key: key);

  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (stackTrace != null) ...[
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                          error: error,
                          stackTrace: stackTrace,
                        ),
                      );
                    },
                    child: const Text('Show stack trace'),
                  ),
                  const SizedBox(width: 8),
                ],
                ElevatedButton(
                  onPressed: onRetry,
                  // TODO: translate
                  child: const Text('Retry'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({Key? key, this.error, this.stackTrace}) : super(key: key);

  final Object? error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    // TODO: translate
    return AlertDialog(
      title: const Text('Error occurred!'),
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Error: ${error?.toString() ?? 'Unknown error'}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            'Stack trace: ${stackTrace?.toString() ?? 'Unknown stack trace'}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
