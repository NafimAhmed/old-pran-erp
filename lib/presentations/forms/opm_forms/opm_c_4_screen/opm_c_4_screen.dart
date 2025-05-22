import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/job_details_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/job_loc_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/job_ord_info_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/top_jo_info_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/widgets/job_details_table_widget.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/widgets/top_jo_Info_dialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OpmC4Screen extends StatelessWidget {
  const OpmC4Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-4-SCREEN";
  static const String routePath = "/OPM-C-4-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TopJoInfoBloc(getService()),
        ),
        BlocProvider(
          create: (context) => JobDetailsBloc(getService()), //FG/SFG details
        ),
        BlocProvider(
          create: (context) =>
              JobLocatorDrilBloc(getService()), // Locator Details
        ),
        BlocProvider(
          create: (context) => JobOrderInfoBloc(getService()), //FG/SFG Status
        ),
      ],
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
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    context.read<TopJoInfoBloc>().add(TopJoInfoGet(userId: loggedUser.userId));
    super.initState();
  }

  DataGridController controller = DataGridController();
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName), //job report
      body: BlocListener<JobOrderInfoBloc, JobOrderInfoState>(
        listener: (context, state) {},
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: BlocBuilder<TopJoInfoBloc, TopJoInfoState>(
              builder: (context, state) {
                if (state is TopJoInfoLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is TopJoInfoSuccess) {
                  var jobHisDataSource = JobHistoryDataSource(
                    jobHistoryData: state.topJoInfoList,
                  );

                  chartData = state.topJoInfoList
                      .map(
                        (e) => _ChartData(e.jobOrderNo ?? "", e.goodQty ?? 0),
                      )
                      .toList();

                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      CommonTextFieldWidget(
                        controller: _searchController,
                        hintText: "Search Job Order No",
                        onChanged: (value) {
                          context.read<TopJoInfoBloc>().add(
                                TopJoInfoFilter(
                                  searchValue: _searchController.text,
                                ),
                              );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: JobDetailsTableWidget(
                          controller: controller,
                          source: jobHisDataSource,
                          onCellTap: (details) {
                            if ([0, 1, 2]
                                .contains(details.rowColumnIndex.columnIndex)) {
                              var jobOrder = jobHisDataSource
                                  .jobHisData[
                                      details.rowColumnIndex.rowIndex - 1]
                                  .jobOrderNo;

                              AppModal.showCustomModal(
                                context,
                                content: TopJoInfoDialog(
                                  jobOrder: jobOrder ?? "",
                                  blocContext: context,
                                  userId: loggedUser.userId,
                                ),
                              );
                            }
                          },
                        ),
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
      bottomNavigationBar: const UserDetailsWidget(),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final num y;
}
