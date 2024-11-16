import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class InvC2Screen extends StatelessWidget {
  const InvC2Screen({super.key});
  static const String routeName = "INV-C-2-SCREEN";
  static const String routePath = "/INV-C-2-SCREEN";
  @override
  Widget build(BuildContext context) {
    return const InvC2ScreenBody();
  }
}

class InvC2ScreenBody extends StatelessWidget {
  const InvC2ScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Receiving Transactions"),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    height: 100,
                    color: appTheme.green,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
