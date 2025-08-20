import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';

class PoC4Screen extends StatelessWidget {
  const PoC4Screen({super.key, required this.fromName});
  static const String routeName = "PO-C-4-SCREEN";
  static const String routePath = "/PO-C-4-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return POC4ScreenBody(fromName: fromName);
  }
}

class POC4ScreenBody extends StatefulWidget {
  const POC4ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<POC4ScreenBody> createState() => _POC4ScreenBodyState();
}

class _POC4ScreenBodyState extends State<POC4ScreenBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(),
    );
  }
}
