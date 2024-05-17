import 'package:flutter/material.dart';

mixin DisplayMixin {
  BuildContext? context;

  void showError({required String errorMessage, required String errorTitle}) {
    showDialog(
        context: context!,
        builder: (ctx) => AlertDialog(
              title: Text(errorTitle),
              content: Text(errorMessage),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'))
              ],
            ));
  }
}
