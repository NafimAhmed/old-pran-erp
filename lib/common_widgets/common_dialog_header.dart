import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CommonDialogHeader extends StatelessWidget {
  const CommonDialogHeader({
    super.key,
    required this.title,
    this.onTap,
  });
  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: appTheme.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: appTheme.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: onTap ??
              () {
                context.pop();
              },
          child: Container(
            width: 40,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: appTheme.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              Icons.close,
              color: appTheme.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
