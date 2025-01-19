import 'package:flutter/material.dart';

import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';

class InventoryManagementScreen extends StatelessWidget {
  const InventoryManagementScreen({super.key});
  static const String routePath = "inventory-management-screen";
  static const String routeName = "inventory-management-screen";
  @override
  Widget build(BuildContext context) {
    return const InventoryManagementScreenBody();
  }
}

class InventoryManagementScreenBody extends StatefulWidget {
  const InventoryManagementScreenBody({super.key});

  @override
  State<InventoryManagementScreenBody> createState() =>
      _InventoryManagementScreenBodyState();
}

class _InventoryManagementScreenBodyState
    extends State<InventoryManagementScreenBody> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(appBartitle: "Test Data"),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
