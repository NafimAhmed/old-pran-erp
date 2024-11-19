import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_15_screen/bloc/job_order_history_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_15_screen/widgets/job_order_history_table_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OpmC15Screen extends StatelessWidget {
  const OpmC15Screen({super.key});
  static const String routeName = "OPM-C-15-SCREEN";
  static const String routePath = "/OPM-C-15-SCREEN";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobOrderHistoryBloc(getService()),
      child: const OpmC15ScreenBody(),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final num y;
}

class OpmC15ScreenBody extends StatefulWidget {
  const OpmC15ScreenBody({super.key});

  @override
  State<OpmC15ScreenBody> createState() => _OpmC15ScreenBodyState();
}

class _OpmC15ScreenBodyState extends State<OpmC15ScreenBody> {
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    context.read<JobOrderHistoryBloc>().add(GetJobOrderHistory());
    super.initState();
  }

  late TooltipBehavior _tooltip;
  List<_ChartData> chartData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Job Order Stock Summary"),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: BlocBuilder<JobOrderHistoryBloc, JobOrderHistoryState>(
              builder: (context, state) {
                if (state is JobOrderHistoryLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is JobOrderHistorySuccess) {
                  var jobHisDataSource = JobOrderHisDataSource(
                      jobOrderHistoryData: state.jobOrderDataList);

                  chartData = state.jobOrderDataList
                      .map(
                        (e) => _ChartData(e.jobOrderNo ?? "", e.rackQty ?? 0),
                      )
                      .toList();
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: JobOrderHisTabWidget(
                          source: jobHisDataSource,
                          onCellTap: (details) {},
                        ),
                      ),
                      SfCircularChart(
                        title: ChartTitle(
                          text: "Job Order Summary",
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
                      const SizedBox(
                        height: 10,
                      ),
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
