import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/jobhist_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/presentations/transfer_details_screen/bloc/job_history_bloc.dart';
import 'package:pran_rfl_erp/presentations/transfer_details_screen/widgets/job_details_table_widget.dart';
import 'package:pran_rfl_erp/presentations/transfer_details_screen/widgets/job_order_details_dialog_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  List<_ChartData> chartData = [];
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Transfer Details"),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: BlocBuilder<JobHistoryBloc, JobHistoryState>(
              builder: (context, state) {
                if (state is JobHistoryLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is JobHistorySuccess) {
                  var jobHisDataSource = JobHistoryDataSource(
                    jobHistoryData: state.jobHistoryList,
                  );

                  chartData = state.jobHistoryList
                      .map(
                        (e) => _ChartData(e.jobOrderNo ?? "", e.madeP ?? 0),
                      )
                      .toList();
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: JobDetailsTableWidget(
                          source: jobHisDataSource,
                          onCellTap: (details) {
                            // log(
                            //   source._jobHisData[details.rowColumnIndex.rowIndex - 1]
                            //       .getCells()
                            //       .elementAt(details.rowColumnIndex.columnIndex)
                            //       .value
                            //       .toString(),
                            // );
                            if (details.rowColumnIndex.columnIndex == 0) {
                              AppModal.showCustomModal(
                                context,
                                content: JobOrderDetailsDialog(
                                  jobOrderNo: jobHisDataSource
                                      .rows[details.rowColumnIndex.rowIndex - 1]
                                      .getCells()
                                      .elementAt(
                                          details.rowColumnIndex.columnIndex)
                                      .value
                                      .toString(),
                                  itemName: jobHisDataSource
                                      .rows[details.rowColumnIndex.rowIndex - 1]
                                      .getCells()
                                      .elementAt(1)
                                      .value
                                      .toString(),
                                  cells: jobHisDataSource
                                      .rows[details.rowColumnIndex.rowIndex - 1]
                                      .getCells()
                                      .sublist(2),
                                ),
                              );
                            }
                          },
                        ),
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
                            dataSource: chartData,
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
                            dataSource: chartData,
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                            ),
                            // Radius of pie
                            radius: '80%',
                            explode: true,

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
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final num y;
}
