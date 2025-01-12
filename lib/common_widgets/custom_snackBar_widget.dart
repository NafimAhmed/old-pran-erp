import 'package:flutter/material.dart';

import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/image_constant.dart';

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
      content: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Image.asset(
                fit: BoxFit.contain,
                color: Colors.white,
                ImageConstant.speechBubble,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Oh Snap!",
                    style: textTheme.bodyMedium!.copyWith(
                      color: appTheme
                          .white, // White text for both success and error
                    ),
                  ),
                  Text(
                    message,
                    style: textTheme.bodySmall!.copyWith(
                      color: appTheme
                          .white, // White text for both success and error
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
