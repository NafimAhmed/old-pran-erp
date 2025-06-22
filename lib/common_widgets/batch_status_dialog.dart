import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/app_data/models/batch_status_check_response.dart';
import 'package:pran_rfl_erp/common_widgets/common_dialog_header.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class BatchStatusDialog extends StatelessWidget {
  const BatchStatusDialog({
    super.key,
    required this.data,
  });

  final BatchStatusCheckResponse data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CommonDialogHeader(title: "Batch Status"),
          Row(
            children: [
              const Text("Batch Status:"),
              Expanded(
                child: Text(
                  textAlign: TextAlign.right,
                  data.batchStatusCk?.first.batchStatus ?? "",
                  style: textTheme.bodyMedium!.copyWith(
                    fontSize: 17,
                    color: ["Closed", "Completed"]
                            .contains(data.batchStatusCk?.first.batchStatus)
                        ? appTheme.green
                        : const Color.fromARGB(255, 252, 62, 62),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Batch No:"),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.right,
                        data.batchStatusCk?.first.batchNo ?? "",
                        style: textTheme.bodyMedium!.copyWith(
                            // fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("ORG:"),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.right,
                        data.batchStatusCk?.first.organizationCode ?? "",
                        style: textTheme.bodyMedium!.copyWith(
                            // fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("User:"),
              Expanded(
                child: Text(
                  textAlign: TextAlign.right,
                  data.batchStatusCk?.first.userName ?? "",
                  style: textTheme.bodyMedium!.copyWith(
                      // fontSize: 17,
                      // fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Org Name:"),
              Expanded(
                child: Text(
                  textAlign: TextAlign.right,
                  data.batchStatusCk?.first.organizationName ?? "",
                  style: textTheme.bodyMedium!.copyWith(
                      // fontSize: 17,
                      // fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Cur.Location: "),
              Expanded(
                child: Text(
                  textAlign: TextAlign.right,
                  data.batchLocation?.description ?? "",
                  style: textTheme.bodyMedium!.copyWith(
                      // fontSize: 17,
                      // fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Cur.Stock: "),
              Expanded(
                child: Text(
                  textAlign: TextAlign.right,
                  "${data.batchLocation?.stock ?? "-"}",
                  style: textTheme.bodyMedium!.copyWith(
                      // fontSize: 17,
                      // fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
