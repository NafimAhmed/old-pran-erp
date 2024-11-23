import 'package:flutter/material.dart';

class OpmC17Screen extends StatelessWidget {
  const OpmC17Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-17-SCREEN";
  static const String routePath = "/OPM-C-17-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return OpmC17ScreenBody(
      fromName: fromName,
    );
  }
}

class OpmC17ScreenBody extends StatefulWidget {
  const OpmC17ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC17ScreenBody> createState() => _OpmC17ScreenBodyState();
}

class _OpmC17ScreenBodyState extends State<OpmC17ScreenBody> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
