import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  const CustomDropdownSearch({
    super.key,
    required this.items,
    this.onChanged,
    this.suffix,
    this.border,
    this.width,
    this.popupHeight,
    this.borderDecoration,
    this.borderColor,
    this.hintText,
    this.hintStyle,
    this.value,
    this.validator,
    this.enabled = true,
  });

  final List<T> items;
  final String? hintText;
  final void Function(T? value)? onChanged;
  final Widget? suffix;
  final InputBorder? border;
  final TextStyle? hintStyle;

  final T? value;
  final String? Function(dynamic value)? validator;

  final double? width;
  final double? popupHeight;
  final InputBorder? borderDecoration;
  final Color? borderColor;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: items,
      selectedItem: value,
      enabled: enabled,

      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 0,
          ),
          isDense: true,
          enabled: true,
        ),
      ),
      popupProps: PopupProps.dialog(
        // showSelectedItems: true,
        showSearchBox: true,
        scrollbarProps: ScrollbarProps(thumbColor: appTheme.primary),
        dialogProps: const DialogProps(),
        itemBuilder: (context, item, isSelected) {
          return ListTile(
            title: Text(
              item.toString(),
              style: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
            ),
          );
        },

        searchFieldProps: TextFieldProps(
          cursorColor: appTheme.primary,
          style: textTheme.bodyMedium,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            filled: true,
            isDense: true,
            helperStyle: const TextStyle(color: Colors.black),
            labelStyle: const TextStyle(color: Colors.black),
            hintText: "Search",
            hintStyle: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
            enabled: true,
          ),
        ),
        containerBuilder: (context, popupWidget) {
          return Container(
            height: 250,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            alignment: Alignment.topLeft,
            child: popupWidget,
          );
        },
      ),
      // onChanged: (value) {
      //   onChanged?.call(value);
      // },
      onChanged: onChanged,
      // dropdownButtonProps: DropdownButtonProps(
      //   // style: ButtonStyle(
      //   //   side: MaterialStateProperty.resolveWith<BorderSide>(
      //   //     (states) => BorderSide(
      //   //       color: borderColor ?? Colors.black,
      //   //     ),
      //   //   ),
      //   // ),
      //   icon: Icon(Icons.d),
      //   iconSize: 14,
      //   onPressed: null,
      //   visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      // ),
      dropdownBuilder: (context, selectedItem) {
        return Text(
          selectedItem?.toString() ?? hintText ?? "Select",
          style: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
          overflow: TextOverflow.ellipsis,
        );
      },
      validator: validator,
    );
  }
}
