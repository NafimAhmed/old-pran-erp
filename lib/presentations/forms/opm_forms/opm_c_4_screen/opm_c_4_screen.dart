import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/job_history_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/widgets/job_details_table_widget.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/widgets/job_order_details_dialog_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OpmC4Screen extends StatelessWidget {
  const OpmC4Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-4-SCREEN";
  static const String routePath = "/OPM-C-4-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobHistoryBloc(getService()),
      child: TransferDetailsScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class TransferDetailsScreenBody extends StatefulWidget {
  const TransferDetailsScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<TransferDetailsScreenBody> createState() =>
      _TransferDetailsScreenBodyState();
}

class _TransferDetailsScreenBodyState extends State<TransferDetailsScreenBody> {
  List<JobHistory> jobHisory = <JobHistory>[];

  List<_ChartData> chartData = [];
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context
        .read<JobHistoryBloc>()
        .add(JobHistoryGet(userId: loggedUser.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName), //job report
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
                  // for (int i = 0; i < state.jobHistoryList.length; i++) {
                  //   chartData.add(
                  //     _ChartData(i, state.jobHistoryList[i].goodQty ?? 0),
                  //   );
                  // }
                  chartData = state.jobHistoryList
                      .map(
                        (e) => _ChartData(e.jobOrderNo ?? "", e.goodQty ?? 0),
                      )
                      .toList();

                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      // const UserDetailsWidget(),
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
                                      .elementAt(2)
                                      .value
                                      .toString(),
                                  cells: jobHisDataSource
                                      .rows[details.rowColumnIndex.rowIndex - 1]
                                      .getCells()
                                      .sublist(3),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SfCartesianChart(
                        zoomPanBehavior: ZoomPanBehavior(
                          enablePinching: true,
                          zoomMode: ZoomMode.x,
                          enablePanning: true,
                        ),
                        primaryYAxis: const NumericAxis(
                          interval: 10000,
                        ),
                        primaryXAxis: CategoryAxis(
                          labelRotation: 90,
                          labelStyle: textTheme.bodySmall,
                        ),
                        series: <CartesianSeries<_ChartData, String>>[
                          ColumnSeries<_ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            isVisibleInLegend: true,
                            // Width of the columns
                            width: 1,
                            // Spacing between the columns
                            spacing: 0.2,
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
      bottomNavigationBar: const UserDetailsWidget(),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final num y;
}
