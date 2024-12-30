import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CommonDropdownButton<T> extends StatelessWidget {
  const CommonDropdownButton({
    super.key,
    required this.hintText,
    this.items,
    this.value,
    required this.onChanged,
    this.validator,
  });
  final String hintText;
  final List<T>? items;
  final T? value;
  final void Function(T? value) onChanged;
  final String? Function(T? value)? validator;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      padding: EdgeInsets.zero,
      menuMaxHeight: 250,
      iconEnabledColor: Colors.black,
      decoration: InputDecoration(
        fillColor: appTheme.white,
        filled: true,
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      hint: Text(
        hintText,
        style: textTheme.bodyMedium!.copyWith(
          color: appTheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: textTheme.bodyMedium!.copyWith(
        overflow: TextOverflow.ellipsis,
        color: appTheme.primary,
        fontWeight: FontWeight.bold,
      ),
      items: items?.map(
        (e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e.toString()),
          );
        },
      ).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
