import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CommonTableWidget extends StatelessWidget {
  const CommonTableWidget({
    super.key,
    required this.source,
    this.onCellTap,
    this.frozenColumnsCount = 0,
    this.colVisibilityOff = const [],
  });
  final TabDataSource source;
  final void Function(DataGridCellTapDetails details)? onCellTap;
  final int frozenColumnsCount;
  final List<String> colVisibilityOff;
  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      rowHeight: 30,
      headerRowHeight: 36,
      source: source,
      frozenColumnsCount: frozenColumnsCount,
      gridLinesVisibility: GridLinesVisibility.none,
      headerGridLinesVisibility: GridLinesVisibility.none,
      columnWidthMode: ColumnWidthMode.auto,
      shrinkWrapRows: true,
      onCellTap: onCellTap,
      columns: <GridColumn>[
        ...List.generate(
          source._tableData.isNotEmpty
              ? source._tableData.first.getCells().length
              : 0,
          (index) {
            return GridColumn(
              visible: !colVisibilityOff.contains(
                  source._tableData.first.getCells()[index].columnName),
              columnName: source._tableData.first.getCells()[index].columnName,
              label: Container(
                color: appTheme.primary,
                alignment: Alignment.center,
                child: Text(
                  source._tableData.first.getCells()[index].columnName,
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
class TabDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  TabDataSource(
      {required List<Map<String, dynamic>> tableData,
      required List<String> alignment}) {
    _alignment = alignment;
    _tableData = tableData.map<DataGridRow>((e) {
      Map<String, dynamic> map = e;
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

  List<DataGridRow> _tableData = [];
  List<String> _alignment = [];
  @override
  List<DataGridRow> get rows => _tableData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = effectiveRows.indexOf(row);
    return DataGridRowAdapter(
        color: rowIndex % 2 == 0
            ? appTheme.primary.withOpacity(0.2)
            : appTheme.primary.withOpacity(0.1),
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: _alignment.contains(e.columnName)
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
