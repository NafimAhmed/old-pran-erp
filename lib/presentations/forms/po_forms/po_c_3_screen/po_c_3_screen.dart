import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_dialog_header.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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

class RequisitionDetailsDialog extends StatefulWidget {
  const RequisitionDetailsDialog({
    super.key,
  });

  @override
  State<RequisitionDetailsDialog> createState() =>
      _RequisitionDetailsDialogState();
}

class _RequisitionDetailsDialogState extends State<RequisitionDetailsDialog> {
  late DataGridController? _dataGridController;
  late DataGridSource skuDtlSource;
  @override
  void initState() {
    _dataGridController = DataGridController();
    skuDtlSource = SkuDtlSource(skuDtlData: [
      TestData(item: "Test Item", unit: "PS", quantity: 100),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const CommonDialogHeader(title: "Requisition Details"),
          const SizedBox(
            height: 10,
          ),
          SfDataGridTheme(
            data: SfDataGridThemeData(
              selectionColor: appTheme.primary.withOpacity(0.1),
            ),
            child: SfDataGrid(
              source: skuDtlSource,
              controller: _dataGridController,
              rowHeight: 32,
              headerRowHeight: 38,
              columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.none,
              columnWidthMode: ColumnWidthMode.auto,
              shrinkWrapRows: true,
              onCellTap: (details) {
                // // Ensure rowIndex is greater than 0 to avoid selecting the header.
                // if (details.rowColumnIndex.rowIndex > 0 &&
                //     details.rowColumnIndex.columnIndex == 7 &&
                //     !skuDtlSource.nonEditableRows
                //         .contains(details.rowColumnIndex.rowIndex - 1)) {

                //   // log(skuDtlSource
                //   //     ._skuDtlData[details.rowColumnIndex.rowIndex - 1]
                //   //     .materialDetailId
                //   //     .toString());
                //   // widget.blocContext.read<BatchCompDtlLnUpdtBloc>().add(
                //   //       GetBatchCompDtlLnUpdt(
                //   //         userId: loggedUser.userId,
                //   //         mtldtlid: skuDtlSource
                //   //             ._skuDtlData[details.rowColumnIndex.rowIndex - 1]
                //   //             .materialDetailId
                //   //             .toString(),
                //   //         madeqty: skuDtlSource
                //   //             ._skuDtlData[details.rowColumnIndex.rowIndex - 1]
                //   //             .madeQty
                //   //             .toString(),
                //   //         details: details,
                //   //       ),
                //   //     );
                // }
              },
              allowEditing: true,
              editingGestureType: EditingGestureType.tap,
              selectionMode: SelectionMode.singleDeselect,
              navigationMode: GridNavigationMode.cell,
              columns: [
                ...List.generate(
                  skuDtlSource.rows.first.getCells().length,
                  (index) {
                    return GridColumn(
                      // visible: ![
                      //   "Material Dtl Id",
                      //   "Batch Id",
                      //   "Edit Enable"
                      // ].contains(
                      //     skuDtlSource.rows.first.getCells()[index].columnName),
                      allowEditing: [
                        "quantity",
                      ].contains(
                          skuDtlSource.rows.first.getCells()[index].columnName),
                      autoFitPadding: const EdgeInsets.all(10),
                      columnName:
                          skuDtlSource.rows.first.getCells()[index].columnName,
                      label: Container(
                        color: appTheme.primary,
                        alignment: Alignment.center,
                        child: Text(
                          skuDtlSource.rows.first.getCells()[index].columnName,
                          style: textTheme.bodyMedium!.copyWith(
                            color: appTheme.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TestData {
  final String item;
  final String unit;
  final int quantity;

  TestData({
    required this.item,
    required this.unit,
    required this.quantity,
  });

  TestData copyWith({
    String? item,
    String? unit,
    int? quantity,
  }) {
    return TestData(
      item: item ?? this.item,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
    );
  }

  factory TestData.fromJson(Map<String, dynamic> json) {
    return TestData(
      item: json['item'],
      unit: json['unit'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'unit': unit,
      'quantity': quantity,
    };
  }

  factory TestData.fromMap(Map<String, dynamic> map) {
    return TestData(
      item: map['item'],
      unit: map['unit'],
      quantity: map['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item,
      'unit': unit,
      'quantity': quantity,
      'Action': 'Action'
    };
  }
}

class SkuDtlSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  SkuDtlSource({required List<TestData> skuDtlData}) {
    _skuDtlData = skuDtlData;
    _skuDtlRowData = skuDtlData.map<DataGridRow>((e) {
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

    // for (int i = 0; i < skuDtlData.length; i++) {
    //   if (skuDtlData[i].editEnable == 1) {
    //     nonEditableRows.add(i);
    //   }
    // }
  }
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();
  List<DataGridRow> _skuDtlRowData = [];
  List<TestData> _skuDtlData = [];
  List<DataGridRow> highlightRows = [];
  List<int> nonEditableRows = [];

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    final int dataRowIndex = _skuDtlRowData.indexOf(dataGridRow);

    if (newCellValue != null) {
      if (column.columnName == 'quantity') {
        _skuDtlRowData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<dynamic>(columnName: 'quantity', value: newCellValue);
        _skuDtlData[dataRowIndex] =
            _skuDtlData[dataRowIndex].copyWith(quantity: newCellValue);
      }
    }
  }

  @override
  bool onCellBeginEdit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    return !nonEditableRows.contains(rowColumnIndex.rowIndex);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    newCellValue = null;

    final bool isNumericType = [
      "quantity",
    ].contains(column.columnName);

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        style: textTheme.bodySmall,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(2, 0, 0, 16.0),
        ),
        keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = num.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          // In Mobile Platform.
          // Call [CellSubmit] callback to fire the canSubmitCell and
          // onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }

  @override
  List<DataGridRow> get rows => _skuDtlRowData;

  List<TestData> get rawList => _skuDtlData;
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = effectiveRows.indexOf(row);
    // Color getBackgroundColor() {
    //   if (row == highlightRow) {
    //     return Colors.deepPurple;
    //   } else {
    //     return Colors.transparent;
    //   }
    // }

    return DataGridRowAdapter(
        color: highlightRows.isNotEmpty
            ? highlightRows.contains(row)
                ? Colors.orange[400]
                : rowIndex % 2 == 0
                    ? Colors.grey // Light grey for even rows
                    : Colors.white
            : rowIndex % 2 == 0
                ? Colors.grey // Light grey for even rows
                : Colors.white,
        cells: [
          ...List.generate(
            row.getCells().length,
            (index) {
              return ["Action"].contains(row.getCells()[index].columnName) &&
                      !nonEditableRows.contains(rowIndex)
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: appTheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          row.getCells()[index].value.toString(),
                          style: textTheme.bodySmall!.copyWith(
                            color: appTheme.white,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      alignment: ["quantity"]
                              .contains(row.getCells()[index].columnName)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      padding: const EdgeInsets.all(8.0),
                      child:
                          ["Action"].contains(row.getCells()[index].columnName)
                              ? null
                              : Text(
                                  row.getCells()[index].value.toString(),
                                  textAlign: TextAlign.center,
                                ),
                    );
            },
          )
        ]);
  }
}
