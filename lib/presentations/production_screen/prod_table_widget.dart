import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/app_data/entities/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProdTableWidget extends StatelessWidget {
  const ProdTableWidget({super.key, required this.source});
  final TempBatchDataSource source;
  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: source,
      // frozenRowsCount: 2,
      allowExpandCollapseGroup: true,

      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      columnWidthMode: ColumnWidthMode.fitByCellValue,
      shrinkWrapRows: true,
      // verticalScrollPhysics: const NeverScrollableScrollPhysics(),
      columns: <GridColumn>[
        ...List.generate(
          source._tempBatchData.first.getCells().length,
          (index) {
            return GridColumn(
              columnName:
                  source._tempBatchData.first.getCells()[index].columnName,
              visible:
                  source._tempBatchData.first.getCells()[index].columnName !=
                      "Flag Status",
              label: Container(
                color: appTheme.primary,
                alignment: Alignment.center,
                child: Text(
                  source._tempBatchData.first.getCells()[index].columnName,
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
class TempBatchDataSource<T> extends DataGridSource {
  /// Creates the employee data source class with required details.
  TempBatchDataSource({required List<TempBatchData> tempBatchData}) {
    _tempBatchData = tempBatchData.map<DataGridRow>((e) {
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

  List<DataGridRow> _tempBatchData = [];

  @override
  List<DataGridRow> get rows => _tempBatchData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getConditionalRowBackgroundColor() {
      final int flag = row.getCells()[8].value;
      if (flag == 1) {
        return Colors.red[300]!;
      }

      return Colors.transparent;
    }

    return DataGridRowAdapter(
        color: getConditionalRowBackgroundColor(),
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: ["Total Qty", "Original Qty", "Batch No", "Item Code"]
                    .contains(e.columnName)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.value.toString(),
            ),
          );
        }).toList());
  }

  @override
  Widget? buildGroupCaptionCellWidget(
      RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
        ),
        child: Text(summaryValue));
  }
}
