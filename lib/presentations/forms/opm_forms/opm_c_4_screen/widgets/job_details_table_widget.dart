import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/app_data/models/jobhist_response.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class JobDetailsTableWidget extends StatelessWidget {
  const JobDetailsTableWidget(
      {super.key, required this.source, this.onCellTap});
  final JobHistoryDataSource source;
  final void Function(DataGridCellTapDetails)? onCellTap;
  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        gridLineColor: appTheme.white,
        frozenPaneLineColor: Colors.transparent,
      ),
      child: SfDataGrid(
        rowHeight: 32,
        headerRowHeight: 38,
        source: source,
        frozenColumnsCount: 1,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.none,
        columnWidthMode: ColumnWidthMode.auto,
        shrinkWrapRows: true,
        onCellTap: onCellTap,
        columns: <GridColumn>[
          ...List.generate(
            source._jobHisRowData.isNotEmpty
                ? source._jobHisRowData.first.getCells().length
                : 0,
            (index) {
              return GridColumn(
                columnName:
                    source._jobHisRowData.first.getCells()[index].columnName,
                label: Container(
                  color: appTheme.primary,
                  alignment: Alignment.center,
                  child: Text(
                    source._jobHisRowData.first.getCells()[index].columnName,
                    style: textTheme.bodyMedium!.copyWith(
                      color: appTheme.white,
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class JobHistoryDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  JobHistoryDataSource({required List<JobHistory> jobHistoryData}) {
    _jobHisData = jobHistoryData;
    _jobHisRowData = jobHistoryData.map<DataGridRow>((e) {
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
        ],
      );
    }).toList();
  }

  List<DataGridRow> _jobHisRowData = [];
  List<JobHistory> _jobHisData = [];
  @override
  List<DataGridRow> get rows => _jobHisRowData;
  List<JobHistory> get jobHisData => _jobHisData;
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = effectiveRows.indexOf(row);

    return DataGridRowAdapter(
        color: rowIndex % 2 == 0
            ? appTheme.primary.withOpacity(0.2)
            : appTheme.primary.withOpacity(0.1),
        cells: row.getCells().map<Widget>((e) {
          LinearGradient? getColor() {
            if (e.columnName == 'Made P %') {
              try {
                Color fillColor = appTheme.green;
                double fillPercent = double.parse(e.value
                    .toString()
                    .replaceAll('%', '')); // fills for container from side
                if (fillPercent <= 10) {
                  fillColor = Colors.red; // 0-10
                } else if (fillPercent <= 20) {
                  fillColor = Colors.deepOrange; // 10-20
                } else if (fillPercent <= 30) {
                  fillColor = Colors.orange; // 20-30
                } else if (fillPercent <= 40) {
                  fillColor = Colors.amber; // 30-40
                } else if (fillPercent <= 50) {
                  fillColor = Colors.yellow; // 40-50
                } else if (fillPercent <= 60) {
                  fillColor = Colors.teal; // 50-60
                } else if (fillPercent <= 70) {
                  fillColor = Colors.cyan; // 60-70
                } else if (fillPercent <= 80) {
                  fillColor = Colors.blue; // 70-80
                } else if (fillPercent <= 90) {
                  fillColor = Colors.indigo; // 80-90
                } else if (fillPercent < 100) {
                  fillColor = Colors.purple; // 90-99
                } else {
                  fillColor = Colors.green; // 100
                }
                fillPercent = fillPercent / 100;
                // Return a gradient based on the value
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  tileMode: TileMode.clamp,
                  stops: [
                    0.0,
                    fillPercent,
                    fillPercent,
                    1.0
                  ], // Adjust stops for smooth transition
                  colors: [
                    fillColor,
                    fillColor,
                    appTheme.white,
                    appTheme.white,

                    // Background color
                  ],
                );
              } catch (e) {
                return null;
              }
            }
            return null; // Return null for non-relevant columns
          }

          TextStyle? getTextStyle() {
            return [
              "Made P %",
              "Job Order No",
            ].contains(e.columnName)
                ? const TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                : null;
          }

          return Container(
            decoration: BoxDecoration(gradient: getColor()),
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
              e.value.toString(),
              textAlign: TextAlign.center,
              style: getTextStyle(),
            ),
          );
        }).toList());
  }
}
