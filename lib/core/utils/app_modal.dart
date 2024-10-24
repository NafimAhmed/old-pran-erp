import 'package:flutter/material.dart';

class AppModal {
  static Future<T?> showCustomModal<T>(BuildContext context,
      {String? title, Widget? content}) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: content,
      ),
    );
  }
}
