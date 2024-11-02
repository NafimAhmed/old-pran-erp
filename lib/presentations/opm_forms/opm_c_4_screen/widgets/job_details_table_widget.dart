import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/app_data/entities/jobhist_response.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class JobDetailsTableWidget extends StatelessWidget {
  const JobDetailsTableWidget(
      {super.key, required this.source, this.onCellTap});
  final JobHistoryDataSource source;
  final void Function(DataGridCellTapDetails)? onCellTap;
  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: source,
      frozenColumnsCount: 1,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      columnWidthMode: ColumnWidthMode.fitByCellValue,
      shrinkWrapRows: true,
      onCellTap: onCellTap,
      columns: <GridColumn>[
        ...List.generate(
          source._jobHisData.first.getCells().length,
          (index) {
            return GridColumn(
              columnName: source._jobHisData.first.getCells()[index].columnName,
              label: Container(
                color: appTheme.primary,
                alignment: Alignment.center,
                child: Text(
                  source._jobHisData.first.getCells()[index].columnName,
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
class JobHistoryDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  JobHistoryDataSource({required List<JobHistory> jobHistoryData}) {
    _jobHisData = jobHistoryData.map<DataGridRow>((e) {
      Map<String, dynamic> map = e.toMapForTab();
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
          // DataGridCell<String>(
          //     columnName: 'job_order_no', value: e.jobOrderNo),
          // DataGridCell<String>(columnName: 'fpo_no', value: e.fpoNo),
          // DataGridCell<String>(columnName: 'item', value: e.item),
          // DataGridCell<String>(
          //     columnName: 'creation_date', value: e.creationDate),
          // DataGridCell<String>(
          //     columnName: 'plan_start_date', value: e.planStartDate),
          // DataGridCell<String>(
          //     columnName: 'plan_cmplt_date', value: e.planCmpltDate),
          // DataGridCell<num>(columnName: 'fpo_qty', value: e.fpoQty),
          // DataGridCell<String>(columnName: 'dtl_um', value: e.dtlUm),
          // DataGridCell<num>(
          //     columnName: 'total_made_qty', value: e.totalMadeQty),
          // DataGridCell<num>(columnName: 'good_qty', value: e.goodQty),
          // DataGridCell<num>(columnName: 'bad_qty', value: e.badQty),
          // DataGridCell<num>(columnName: 'trn_qty', value: e.trnQty),
          // DataGridCell<num>(columnName: 'rack_qty', value: e.rackQty),
          // DataGridCell<String>(columnName: 'made_p', value: "${e.madeP}%"),
          // DataGridCell<String>(
          //     columnName: 'due_made_p', value: "${e.dueMadeP}%"),
        ],
      );
    }).toList();
  }

  List<DataGridRow> _jobHisData = [];

  @override
  List<DataGridRow> get rows => _jobHisData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: [
          "FPO No",
          "FPO Qty",
          "Total Made Qty",
          "Good Qty",
          "Bad Qty",
          "Trn Qty",
          "Rack Qty",
          "Made P %",
          "Due Made P %"
        ].contains(e.columnName)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          ["Plan Start Date", "Plan Cmplt Date"].contains(e.columnName)
              ? DateTime.parse(e.value).toFormatedString("dd-MM-yyy")
              : e.value.toString(),
          textAlign: TextAlign.center,
        ),
      );
    }).toList());
  }
}
