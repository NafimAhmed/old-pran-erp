import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CommonDropDownMenuWidget<T> extends StatelessWidget {
  const CommonDropDownMenuWidget({
    super.key,
    this.enabled = true,
    this.controller,
    this.onSelected,
    required this.dropdownMenuEntries,
    this.hintText,
  });
  final bool enabled;
  final TextEditingController? controller;
  final Function(T? value)? onSelected;
  final List<T> dropdownMenuEntries;
  final String? hintText;
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      menuHeight: 250,
      expandedInsets: EdgeInsets.zero,
      enableSearch: true,
      requestFocusOnTap: true,
      enabled: enabled,
      // enableFilter: true,
      controller: controller,
      hintText: hintText,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: textTheme.bodySmall!.copyWith(
          color: appTheme.primary,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),

      textStyle: textTheme.bodySmall!.copyWith(
        color: appTheme.primary,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      onSelected: onSelected,

      dropdownMenuEntries: dropdownMenuEntries.map(
        (e) {
          return DropdownMenuEntry(
            value: e,
            label: e.toString(),
            labelWidget: Text(
              e.toString(),
              style: textTheme.bodySmall!.copyWith(
                color: appTheme.primary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
