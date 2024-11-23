import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class OmC1Screen extends StatelessWidget {
  const OmC1Screen({super.key, required this.fromName});
  static const String routeName = "OM-C-1-SCREEN";
  static const String routePath = "/OM-C-1-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.white,
    );
  }
}
