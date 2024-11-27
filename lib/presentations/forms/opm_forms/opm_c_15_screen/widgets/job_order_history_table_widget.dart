import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/app_data/models/Job_order_sum_history_response.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class JobOrderHisTabWidget extends StatelessWidget {
  const JobOrderHisTabWidget({super.key, required this.source, this.onCellTap});
  final JobOrderHisDataSource source;
  final void Function(DataGridCellTapDetails)? onCellTap;
  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: source,
      rowHeight: 30,
      headerRowHeight: 36,
      frozenColumnsCount: 1,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      columnWidthMode: ColumnWidthMode.fitByCellValue,
      shrinkWrapRows: true,
      onCellTap: onCellTap,
      columns: <GridColumn>[
        ...List.generate(
          source._jobOrderHisData.isNotEmpty
              ? source._jobOrderHisData.first.getCells().length
              : 0,
          (index) {
            return GridColumn(
              columnName:
                  source._jobOrderHisData.first.getCells()[index].columnName,
              label: Container(
                color: appTheme.primary,
                alignment: Alignment.center,
                child: Text(
                  source._jobOrderHisData.first.getCells()[index].columnName,
                  style: textTheme.bodyMedium!.copyWith(
                    color: appTheme.white,
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class JobOrderHisDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  JobOrderHisDataSource({required List<JobOrderData> jobOrderHistoryData}) {
    _jobOrderHisData = jobOrderHistoryData.map<DataGridRow>((e) {
      Map<String, dynamic> map = e.toTabMap();
      return DataGridRow(
        cells: [
          ...List.generate(
            map.length,
            (index) {
              return DataGridCell(
                columnName: map.entries.elementAt(index).key,
                value: map.entries.elementAt(index).value,
              );
            },
          )
        ],
      );
    }).toList();
  }

  List<DataGridRow> _jobOrderHisData = [];

  @override
  List<DataGridRow> get rows => _jobOrderHisData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = effectiveRows.indexOf(row);
    return DataGridRowAdapter(
        color: rowIndex % 2 == 0
            ? Colors.grey // Light grey for even rows
            : Colors.white,
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: [
              "FPO Qty",
              "Made Qty",
              "Int Qty",
              "Transfered Qty",
              "OnHand Qty",
            ].contains(e.columnName)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.value.toString(),
              textAlign: TextAlign.center,
            ),
          );
        }).toList());
  }
}
