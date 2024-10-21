import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/jobhist_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/transfer_details_screen/bloc/job_history_bloc.dart';
import 'package:pran_rfl_erp/presentations/transfer_details_screen/widgets/job_order_details_dialog_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TransferDetailsScreen extends StatelessWidget {
  const TransferDetailsScreen({super.key});
  static const String routeName = "prod-supervisor/transfer-details-screen";
  static const String routePath = "prod-supervisor/transfer-details-screen";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobHistoryBloc(getService())..add(JobHistoryGet()),
      child: const TransferDetailsScreenBody(),
    );
  }
}

class TransferDetailsScreenBody extends StatefulWidget {
  const TransferDetailsScreenBody({super.key});

  @override
  State<TransferDetailsScreenBody> createState() =>
      _TransferDetailsScreenBodyState();
}

class _TransferDetailsScreenBodyState extends State<TransferDetailsScreenBody> {
  List<JobHistory> jobHisory = <JobHistory>[];

  late TooltipBehavior _tooltip;
  List<_ChartData> data = [];
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Transfer Details"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: BlocBuilder<JobHistoryBloc, JobHistoryState>(
            builder: (context, state) {
              if (state is JobHistorySuccess) {
                var jobHisDataSource =
                    JobHistoryDataSource(jobHistoryData: state.jobHistoryList);
                data = state.jobHistoryList
                    .map(
                      (e) => _ChartData(e.jobOrderNo ?? "", e.madeP ?? 0),
                    )
                    .toList();
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SfDataGrid(
                      source: jobHisDataSource,
                      frozenColumnsCount: 1,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      shrinkWrapRows: true,
                      onCellTap: (details) {
                        log(
                          jobHisDataSource
                              ._jobHisData[details.rowColumnIndex.rowIndex - 1]
                              .getCells()
                              .elementAt(details.rowColumnIndex.columnIndex)
                              .value
                              .toString(),
                        );
                        if (details.rowColumnIndex.columnIndex == 0) {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return Dialog(
                                alignment: Alignment.center,
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: JobOrderDetailsDialog(
                                  jobOrderNo: jobHisDataSource._jobHisData[
                                          details.rowColumnIndex.rowIndex - 1]
                                      .getCells()
                                      .elementAt(
                                          details.rowColumnIndex.columnIndex)
                                      .value
                                      .toString(),
                                ),
                              );
                            },
                          );
                        }
                      },
                      columns: <GridColumn>[
                        GridColumn(
                          columnName: 'job_order_no',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Job Order no',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'fpo_no',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'FPO No',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'item',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Item',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'creation_date',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Creation Date',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'plan_start_date',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Plan Start Date',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'plan_cmplt_date',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Plan Cmplt Date',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'fpo_qty',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Fpo Qty',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'dtl_um',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Unit',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'total_made_qty',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Total Made Qty',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'good_qty',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Good Qty',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'bad_qty',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Bad Qty',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'trn_qty',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Trn Qty',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'rack_qty',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Rack Qty',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'made_p',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Made P(%)',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'due_made_p',
                          label: Container(
                            color: appTheme.primary,
                            alignment: Alignment.center,
                            child: Text(
                              'Due Made P(%)',
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SfCircularChart(
                      title: ChartTitle(
                        text: "Production Progress",
                        textStyle: textTheme.bodySmall!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: appTheme.primary,
                        ),
                      ),
                      legend: const Legend(
                        isVisible: true,
                        alignment: ChartAlignment.near,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                        shouldAlwaysShowScrollbar: true,
                        orientation: LegendItemOrientation.vertical,
                      ),
                      tooltipBehavior: _tooltip,
                      series: <CircularSeries<_ChartData, String>>[
                        DoughnutSeries<_ChartData, String>(
                          dataSource: data,
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                          ),
                          enableTooltip: true,
                          explode: true,
                        )
                      ],
                    ),
                    SfCircularChart(
                      title: ChartTitle(
                        text: "Production Progress",
                        textStyle: textTheme.bodySmall!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: appTheme.primary,
                        ),
                      ),
                      legend: const Legend(
                        isVisible: true,
                        alignment: ChartAlignment.near,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                        shouldAlwaysShowScrollbar: true,
                        orientation: LegendItemOrientation.vertical,
                      ),
                      tooltipBehavior: _tooltip,
                      series: <CircularSeries>[
                        PieSeries<_ChartData, String>(
                          dataSource: data,
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                          ),
                          // Radius of pie
                          radius: '80%',
                          explode: true,
                          explodeIndex: 1,
                          enableTooltip: true,
                        )
                      ],
                    )
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class JobHistoryDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  JobHistoryDataSource({required List<JobHistory> jobHistoryData}) {
    _jobHisData = jobHistoryData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(
                  columnName: 'job_order_no', value: e.jobOrderNo),
              DataGridCell<String>(columnName: 'fpo_no', value: e.fpoNo),
              DataGridCell<String>(columnName: 'item', value: e.item),
              DataGridCell<String>(
                  columnName: 'creation_date', value: e.creationDate),
              DataGridCell<String>(
                  columnName: 'plan_start_date', value: e.planStartDate),
              DataGridCell<String>(
                  columnName: 'plan_cmplt_date', value: e.planCmpltDate),
              DataGridCell<num>(columnName: 'fpo_qty', value: e.fpoQty),
              DataGridCell<String>(columnName: 'dtl_um', value: e.dtlUm),
              DataGridCell<num>(
                  columnName: 'total_made_qty', value: e.totalMadeQty),
              DataGridCell<num>(columnName: 'good_qty', value: e.goodQty),
              DataGridCell<num>(columnName: 'bad_qty', value: e.badQty),
              DataGridCell<num>(columnName: 'trn_qty', value: e.trnQty),
              DataGridCell<num>(columnName: 'rack_qty', value: e.rackQty),
              DataGridCell<String>(columnName: 'made_p', value: "${e.madeP}%"),
              DataGridCell<String>(
                  columnName: 'due_made_p', value: "${e.dueMadeP}%"),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _jobHisData = [];

  @override
  List<DataGridRow> get rows => _jobHisData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final num y;
}
