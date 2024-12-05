import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/app_data/models/lot_trn_response.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LotTrnTableWidget extends StatelessWidget {
  const LotTrnTableWidget(
      {super.key, required this.source, required this.dataGridController});
  final LotTrnDataSource source;
  final DataGridController dataGridController;
  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: source,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      columnWidthMode: ColumnWidthMode.fitByColumnName,
      showCheckboxColumn: true,
      selectionMode: SelectionMode.singleDeselect,
      controller: dataGridController,
      columns: <GridColumn>[
        ...List.generate(
          source._lotTrnData.isNotEmpty
              ? source._lotTrnData.first.getCells().length
              : 0,
          (index) {
            return GridColumn(
              columnName: source._lotTrnData.first.getCells()[index].columnName,
              label: Container(
                color: appTheme.primary,
                alignment: Alignment.center,
                child: Text(
                  source._lotTrnData.first.getCells()[index].columnName,
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
class LotTrnDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  LotTrnDataSource({required List<LotTrnData> lotTrnData}) {
    _lotTrnData = lotTrnData.map<DataGridRow>((e) {
      Map<String, dynamic> map = e.toMap();
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

  List<DataGridRow> _lotTrnData = [];

  @override
  List<DataGridRow> get rows => _lotTrnData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          e.value.toString(),
          textAlign: TextAlign.center,
        ),
      );
    }).toList());
  }
}
