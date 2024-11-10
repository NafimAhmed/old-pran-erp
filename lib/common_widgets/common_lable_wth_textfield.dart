import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CommonLableWthTextField extends StatelessWidget {
  const CommonLableWthTextField({
    super.key,
    required this.focusNode,
    required this.textController,
    this.validator,
    this.onChanged,
    required this.lableName,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.obscureText = false,
    this.suffixIcon,
  });
  final String lableName;
  final FocusNode focusNode;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final void Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool obscureText;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
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
                lableName,
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
        Expanded(
          flex: 2,
          child: CommonTextFieldWidget(
            suffixIcon: suffixIcon,
            obscureText: obscureText,
            readOnly: readOnly,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            controller: textController,
            keyboardType: keyboardType,
            style: textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: appTheme.primary,
            ),
            inputFormatters: inputFormatters,
            labelText: "",
            validator: validator,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
