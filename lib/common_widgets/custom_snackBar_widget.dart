import 'package:flutter/material.dart';

import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CustomSnackBar {
  static SnackBar successSnackber({
    required String message,
  }) {
    return SnackBar(
      content: Text(
        message,
        style: textTheme.bodyMedium!.copyWith(
          color: appTheme.white, // White text for both success and error
        ),
      ),
      backgroundColor: appTheme.primary,
      behavior: SnackBarBehavior.floating,
      elevation: 5,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static SnackBar errorSnackber({
    required String message,
  }) {
    return SnackBar(
      content: Text(
        message,
        style: textTheme.bodyMedium!.copyWith(
          color: appTheme.white, // White text for both success and error
        ),
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      elevation: 5,
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
