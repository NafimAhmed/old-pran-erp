import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class ReadOrWidget extends StatelessWidget {
  const ReadOrWidget({
    super.key,
    required this.qrType,
    required this.onPressed,
  });
  final String qrType;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: appTheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(
                  20,
                ),
                bottomRight: Radius.circular(
                  20,
                ),
              ),
            ),
            child: Center(
              child: Text(
                qrType,
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton.filled(
          onPressed: onPressed,
          icon: Icon(
            Icons.qr_code_scanner_rounded,
            color: appTheme.white,
          ),
        ),
      ],
    );
  }
}
