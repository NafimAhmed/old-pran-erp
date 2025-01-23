import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CommonTextFieldWidget extends StatelessWidget {
  const CommonTextFieldWidget({
    super.key,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.labelText,
    this.inputFormatters,
    this.style,
    this.obscureText = false,
    this.validator,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.readOnly = false,
    this.suffixIcon,
    this.enabled,
    this.textCapitalization = TextCapitalization.none,
    this.hintText,
    this.filled = true,
    this.fillColor = Colors.white,
    this.onTap,
    this.expands = false,
    this.maxLines = 1,
  });
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final bool obscureText;
  final String? Function(String? value)? validator;
  final TextAlign textAlign;
  final bool readOnly;
  final void Function()? onTap;
  final void Function(String value)? onChanged;
  final Widget? suffixIcon;
  final bool? enabled;
  final TextCapitalization textCapitalization;
  final String? hintText;
  final bool? filled;
  final Color? fillColor;
  final bool expands;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: textCapitalization,
      expands: expands,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText,
      autocorrect: false,
      maxLines: maxLines,
      textAlign: textAlign,
      enableSuggestions: false,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: style ??
          textTheme.bodyMedium!.copyWith(
            color: appTheme.primary,
          ),
      onTapOutside: (event) {
        focusNode?.unfocus();
      },
      onTap: onTap,
      decoration: InputDecoration(
        isDense: true,
        filled: filled,
        fillColor: fillColor,
        hintText: hintText,
        labelText: labelText,
        suffixIcon: suffixIcon,
        floatingLabelStyle: textTheme.bodyMedium!.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
