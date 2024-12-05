import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_dtl_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/bloc/batch_comp_data_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/bloc/batch_comp_dtl_data_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/bloc/batch_comp_dtl_data_ln_up_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/bloc/comp_batch_bloc.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OpmC9Screen extends StatelessWidget {
  const OpmC9Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-9-SCREEN";
  static const String routePath = "/opm_c_9_screen";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BatchCompDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => BatchCompDtlDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => BatchCompDtlLnUpdtBloc(getService()),
        ),
        BlocProvider(
          create: (context) => CompBatchBloc(getService()),
        ),
      ],
      child: OpmC9ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class OpmC9ScreenBody extends StatefulWidget {
  const OpmC9ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC9ScreenBody> createState() => _OpmC9ScreenBodyState();
}

class _OpmC9ScreenBodyState extends State<OpmC9ScreenBody>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late UserInfoModel loggedUser;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 2, length: 3, vsync: this);
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 30,
              child: TabBar(
                onTap: (value) {
                  if ([0, 1].contains(value)) {
                    _tabController.index = 2;
                  }
                },
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: appTheme.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: appTheme.primary,
                  ),
                ),
                tabs: const [
                  Tab(
                    text: "Release",
                  ),
                  Tab(
                    text: "Receive",
                  ),
                  Tab(
                    text: "Complete",
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    color: appTheme.green,
                  ),
                  Container(
                    color: appTheme.primary,
                  ),
                  const CompleteTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CompleteTab extends StatefulWidget {
  const CompleteTab({super.key});

  @override
  State<CompleteTab> createState() => _CompleteTabState();
}

class _CompleteTabState extends State<CompleteTab> {
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<BatchCompDataBloc>().add(
          GetBatchCompData(
            userId: loggedUser.userId,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BatchCompDtlDataBloc, BatchCompDtlDataState>(
      listener: (context, state) {
        if (state is BatchCompDtlDataSuccess) {
          AppModal.showCustomModal(
            context,
            content: BatchCompSkuDtlWidget(
              blocContext: context,
              tabData: state.skuDtlDataList,
            ),
          );
        }
      },
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: BlocBuilder<BatchCompDataBloc, BatchCompDataState>(
              builder: (context, state) {
                if (state is BatchCompDataLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is BatchCompDataSuccess) {
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      var data = state.batchCompDataList[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
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
                            BlocBuilder<BatchCompDtlDataBloc,
                                BatchCompDtlDataState>(
                              builder: (context, state) {
                                return Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                    ),
                                    onPressed: () {
                                      context.read<BatchCompDtlDataBloc>().add(
                                            GetBatchCompDtlData(
                                              userId: loggedUser.userId,
                                              batchId: data.batchId.toString(),
                                              listIndex: index,
                                            ),
                                          );
                                    },
                                    child: Text(
                                      state is BatchCompDtlDataLoading
                                          ? state.listIndex == index
                                              ? "Getting Data.."
                                              : "Complete"
                                          : "Complete",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Text(
                              data.itemName ?? "",
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.primary,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Org",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                                Text(
                                  data.organizationCode ?? "",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Batch No",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                                Text(
                                  data.batchNo ?? "",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Batch Qty",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                                Text(
                                  data.batchQty.toString(),
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Made Qty",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                                Text(
                                  data.madeQty.toString(),
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: state.batchCompDataList.length,
                  );
                }
                return Container();
              },
            ),
          )
        ],
      ),
    );
  }
}

class BatchCompSkuDtlWidget extends StatefulWidget {
  const BatchCompSkuDtlWidget({
    super.key,
    required this.blocContext,
    required this.tabData,
  });
  final BuildContext blocContext;
  final List<SkuDtlData> tabData;
  @override
  State<BatchCompSkuDtlWidget> createState() => _BatchCompSkuDtlWidgetState();
}

class _BatchCompSkuDtlWidgetState extends State<BatchCompSkuDtlWidget> {
  final DataGridController _dataGridController = DataGridController();
  late SkuDtlSource skuDtlSource;
  @override
  void initState() {
    skuDtlSource = SkuDtlSource(skuDtlData: widget.tabData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<BatchCompDtlLnUpdtBloc>(widget.blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<CompBatchBloc>(widget.blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<BatchCompDataBloc>(widget.blocContext),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(
          10,
        ),
        // height: MediaQuery.of(context).size.height * 0.5,
        child: BlocListener<BatchCompDtlLnUpdtBloc, BatchCompDtlLnUpdtState>(
          listener: (context, state) {
            if (state is BatchCompDtlLnUpdtSuccess) {
              setState(() {
                // When performing sorting or filtering,use DataGridSource.effectiveRows to retrieve the row.
                skuDtlSource.highlightRows.add(skuDtlSource
                    .effectiveRows[state.details.rowColumnIndex.rowIndex - 1]);
                skuDtlSource.nonEditableRows
                    .add(state.details.rowColumnIndex.rowIndex - 1);
                _dataGridController.selectedRow = null;
              });
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                  onCellTap: (details) {
                    // Ensure rowIndex is greater than 0 to avoid selecting the header.
                    if (details.rowColumnIndex.rowIndex > 0 &&
                        details.rowColumnIndex.columnIndex == 7 &&
                        !skuDtlSource.nonEditableRows
                            .contains(details.rowColumnIndex.rowIndex - 1)) {
                      var loggedUser =
                          context.read<LoggedUserInfoCubit>().state!;

                      // log(skuDtlSource
                      //     ._skuDtlData[details.rowColumnIndex.rowIndex - 1]
                      //     .materialDetailId
                      //     .toString());
                      widget.blocContext.read<BatchCompDtlLnUpdtBloc>().add(
                            GetBatchCompDtlLnUpdt(
                              userId: loggedUser.userId,
                              mtldtlid: skuDtlSource
                                  ._skuDtlData[
                                      details.rowColumnIndex.rowIndex - 1]
                                  .materialDetailId
                                  .toString(),
                              madeqty: skuDtlSource
                                  ._skuDtlData[
                                      details.rowColumnIndex.rowIndex - 1]
                                  .madeQty
                                  .toString(),
                              details: details,
                            ),
                          );
                    }
                  },
                  shrinkWrapRows: true,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columnWidthMode: ColumnWidthMode.auto,
                  allowEditing: true,
                  editingGestureType: EditingGestureType.tap,
                  selectionMode: SelectionMode.singleDeselect,
                  navigationMode: GridNavigationMode.cell,
                  columns: [
                    ...List.generate(
                      skuDtlSource._skuDtlRowData.first.getCells().length,
                      (index) {
                        return GridColumn(
                          visible: ![
                            "Material Dtl Id",
                            "Batch Id",
                            "Edit Enable"
                          ].contains(skuDtlSource._skuDtlRowData.first
                              .getCells()[index]
                              .columnName),
                          allowEditing: [
                            // "Batch Qty",
                            "Made Qty",
                            // "Cost Alloc",
                          ].contains(skuDtlSource._skuDtlRowData.first
                              .getCells()[index]
                              .columnName),
                          autoFitPadding: const EdgeInsets.all(10),
                          columnName: skuDtlSource._skuDtlRowData.first
                              .getCells()[index]
                              .columnName,
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              skuDtlSource._skuDtlRowData.first
                                  .getCells()[index]
                                  .columnName,
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
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: BlocConsumer<CompBatchBloc, CompBatchState>(
                  listener: (context, state) {
                    if (state is CompBatchSuccess) {
                      var loggedUser =
                          context.read<LoggedUserInfoCubit>().state!;
                      widget.blocContext.read<BatchCompDataBloc>().add(
                            GetBatchCompData(
                              userId: loggedUser.userId,
                            ),
                          );
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                      ),
                      onPressed: () {
                        var loggedUser =
                            context.read<LoggedUserInfoCubit>().state!;
                        widget.blocContext.read<CompBatchBloc>().add(
                              BatchComplete(
                                userId: loggedUser.userId,
                                batchId: skuDtlSource._skuDtlData.first.batchId
                                    .toString(),
                              ),
                            );
                      },
                      child: Text(
                        state is CompBatchLoading ? "Completing.." : "Complete",
                        style: textTheme.bodyMedium!.copyWith(
                          color: appTheme.white,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SkuDtlSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  SkuDtlSource({required List<SkuDtlData> skuDtlData}) {
    _skuDtlData = skuDtlData;
    _skuDtlRowData = skuDtlData.map<DataGridRow>((e) {
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

    for (int i = 0; i < skuDtlData.length; i++) {
      if (skuDtlData[i].editEnable == 1) {
        nonEditableRows.add(i);
      }
    }
  }
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();
  List<DataGridRow> _skuDtlRowData = [];
  List<SkuDtlData> _skuDtlData = [];
  List<DataGridRow> highlightRows = [];
  List<int> nonEditableRows = [];

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    // final dynamic oldValue = dataGridRow
    //         .getCells()
    //         .firstWhereOrNull((DataGridCell dataGridCell) =>
    //             dataGridCell.columnName == column.columnName)
    //         ?.value ??
    //     '';

    final int dataRowIndex = _skuDtlRowData.indexOf(dataGridRow);

    if (newCellValue != null) {
      if (column.columnName == 'Made Qty') {
        _skuDtlRowData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell<dynamic>(columnName: 'Made Qty', value: newCellValue);
        _skuDtlData[dataRowIndex] =
            _skuDtlData[dataRowIndex].copyWith(madeQty: newCellValue);
      }
      log(_skuDtlData[dataRowIndex].toString());
    }
  }

  @override
  bool onCellBeginEdit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    // Prevent editing for rows in nonEditableRows.

    return !nonEditableRows.contains(rowColumnIndex.rowIndex);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final bool isNumericType = [
      "Batch Qty",
      "Made Qty",
      "Cost Alloc",
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

  List<SkuDtlData> get rawList => _skuDtlData;
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
                      alignment: [
                        "Batch Id",
                        "Material Dtl Id",
                        "Batch No",
                        "Batch Qty",
                        "Made Qty",
                        "Cost Alloc",
                        "Edit Enable",
                      ].contains(row.getCells()[index].columnName)
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
