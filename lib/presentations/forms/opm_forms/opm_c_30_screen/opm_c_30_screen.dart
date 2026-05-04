import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';

class OpmC30Screen extends StatelessWidget {
  const OpmC30Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-30-SCREEN";
  static const String routePath = "/OPM-C-30-SCREEN";

  final String fromName;
  @override
  Widget build(BuildContext context) {
    return OpmC30ScreenBody(fromName: fromName);
  }
}

class OpmC30ScreenBody extends StatefulWidget {
  const OpmC30ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC30ScreenBody> createState() => _OpmC30ScreenBodyState();
}

class _OpmC30ScreenBodyState extends State<OpmC30ScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.amber,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Align(alignment: Alignment.centerLeft, child: Text("Miraj")),
              SizedBox(width: 50),
              Expanded(child: CommonTextFieldWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
