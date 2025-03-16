import 'package:flutter/material.dart';

import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';

class PoC3Screen extends StatelessWidget {
  const PoC3Screen({super.key, required this.fromName});
  static const String routeName = "PO-C-3-SCREEN";
  static const String routePath = "/PO-C-3-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return POC3ScreenBody(
      fromName: fromName,
    );
  }
}

class POC3ScreenBody extends StatefulWidget {
  const POC3ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<POC3ScreenBody> createState() => _POC3ScreenBodyState();
}

class _POC3ScreenBodyState extends State<POC3ScreenBody> {
  TextEditingController orgDropDownTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    orgDropDownTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      AppModal.showCustomModal(
                        context,
                        content: const RequisitionDetailsDialog(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: appTheme.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: appTheme.primary,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Purchase Requisition No",
                            style: textTheme.bodyMedium!.copyWith(
                              color: appTheme.primary,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RequisitionDetailsDialog extends StatelessWidget {
  const RequisitionDetailsDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
