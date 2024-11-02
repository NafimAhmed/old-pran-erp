import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class InvC1Screen extends StatelessWidget {
  const InvC1Screen({super.key});
  static const String routeName = "INV-C-1-SCREEN";
  static const String routePath = "/INV-C-1-SCREEN";
  @override
  Widget build(BuildContext context) {
    return const InterOrgTransfer();
  }
}

class InterOrgTransfer extends StatefulWidget {
  const InterOrgTransfer({super.key});

  @override
  State<InterOrgTransfer> createState() => _InterOrgTransferState();
}

class _InterOrgTransferState extends State<InterOrgTransfer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Inter Org Transfer"),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const UserDetailsWidget(),
            ReadOrWidget(
              qrType: "From Item OR",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
