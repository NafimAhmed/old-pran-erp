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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.060,
      child: DropdownMenu<T>(
        menuHeight: 250,
        expandedInsets: EdgeInsets.zero,
        enableSearch: false,
        requestFocusOnTap: true,
        enabled: enabled,
        enableFilter: true,
        controller: controller,
        hintText: hintText,
        filterCallback: (entries, filter) {
          try {
            final String trimmedFilter = filter.trim().toLowerCase();
            if (trimmedFilter.isEmpty) {
              return entries;
            }
            List<DropdownMenuEntry<T>> fentries = entries
                .where(
                  (DropdownMenuEntry<T> entry) =>
                      entry.label.toLowerCase().contains(trimmedFilter),
                )
                .toList();
            return fentries.isEmpty ? [] : fentries;
          } catch (e) {
            return entries;
          }
        },
        inputDecorationTheme: InputDecorationTheme(
          fillColor: appTheme.white,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
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
        dropdownMenuEntries: List.generate(
          dropdownMenuEntries.length,
          (index) {
            return DropdownMenuEntry(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  index % 2 == 0
                      ? appTheme.primary.withOpacity(0.2)
                      : appTheme.white,
                ),
              ),
              value: dropdownMenuEntries[index],
              label: dropdownMenuEntries[index].toString(),
              labelWidget: Text(
                dropdownMenuEntries[index].toString(),
                style: textTheme.bodySmall!.copyWith(
                  color: appTheme.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
