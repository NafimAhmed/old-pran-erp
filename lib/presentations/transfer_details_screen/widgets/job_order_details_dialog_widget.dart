import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class JobOrderDetailsDialog extends StatelessWidget {
  const JobOrderDetailsDialog({
    super.key,
    required this.jobOrderNo,
    required this.cells,
  });
  final String jobOrderNo;
  final List<DataGridCell<dynamic>> cells;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.close,
                color: appTheme.primary,
                size: 20,
              ),
            ),
          ),
          Text(
            jobOrderNo,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            cells.length,
            (index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cells[index].columnName,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      cells[index].value.toString(),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
