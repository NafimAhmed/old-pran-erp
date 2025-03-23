import 'package:flutter/material.dart';

class AppModal {
  static Future<T?> showCustomModal<T>(BuildContext context,
      {String? title, Widget? content}) async {
    return await showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        alignment: Alignment.center,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: content,
      ),
    );
  }
}
