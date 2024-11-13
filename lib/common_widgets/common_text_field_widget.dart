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
  final void Function(String value)? onChanged;
  final Widget? suffixIcon;
  final bool? enabled;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText,
      autocorrect: false,
      textAlign: textAlign,
      enableSuggestions: false,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: style ??
          textTheme.bodyMedium!.copyWith(
            color: appTheme.primary,
          ),
      decoration: InputDecoration(labelText: labelText, suffixIcon: suffixIcon)
          .applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
