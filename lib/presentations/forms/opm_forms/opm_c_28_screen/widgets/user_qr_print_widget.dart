import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class UserQrPrintWidget extends StatelessWidget {
  const UserQrPrintWidget(
      {super.key, required this.userBatchQrData, this.onPressed});
  final UserBatchQrData userBatchQrData;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: appTheme.primary,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom().copyWith(
                  padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                  ),
                  minimumSize: WidgetStateProperty.all<Size>(
                    const Size(80, 30),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    appTheme.tertiary,
                  ),
                ),
                onPressed: onPressed,
                child: Row(
                  children: [
                    Text(
                      "Print Qr",
                      style: textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        color: appTheme.white,
                      ),
                    ),
                    Icon(
                      Icons.qr_code,
                      color: appTheme.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildQrPrintDetail(
            "Job Order: ",
            userBatchQrData.jobno ?? "",
          ),
          _buildQrPrintDetail(
            "Item: ",
            userBatchQrData.itemname ?? "",
          ),
          _buildQrPrintDetail(
            "Good Qty: ",
            userBatchQrData.goodQty.toString(),
          ),
          _buildQrPrintDetail(
            "Locator: ",
            userBatchQrData.locLocator.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildQrPrintDetail(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.bodyMedium!.copyWith(
            fontSize: 14,
            color: appTheme.white,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: textTheme.bodyMedium!.copyWith(
              fontSize: 14,
              color: appTheme.white,
            ),
          ),
        )
      ],
    );
  }
}
