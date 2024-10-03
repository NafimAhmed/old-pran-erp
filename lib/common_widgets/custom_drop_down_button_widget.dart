import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CommonDropDownWidget<T> extends StatelessWidget {
  const CommonDropDownWidget({
    super.key,
    this.hintText,
    this.items,
    required this.onChanged,
    this.value,
  });
  final String? hintText;
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final void Function(T?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<T>(
          value: value,
          selectedItemBuilder: (_) {
            return items!.map<Widget>(
              (e) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Batch Details No-${e.value.toString()}",
                    style: textTheme.bodyMedium!.copyWith(
                      color: appTheme.primary,
                    ),
                  ),
                );
              },
            ).toList();
          },
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.primary,
                width: 2.0,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.primary,
                width: 2.0,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.primary,
                width: 2.0,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
          ),
          hint: Text(hintText ?? "Select"),
          style: textTheme.bodySmall!.copyWith(
            color: appTheme.primary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          isExpanded: true,
          menuMaxHeight: 250,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
