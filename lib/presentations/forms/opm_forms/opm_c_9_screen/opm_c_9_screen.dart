import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/batch_complete_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/bloc/batch_comp_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/widgets/complete_widget.dart';

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
          create: (context) => BatchCompBloc(getService()), //list
        ),
      ],
      child: OpmC9ScreenBody(fromName: fromName),
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
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
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
            const SizedBox(height: 15),
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
                  border: Border.all(color: appTheme.primary),
                ),
                tabs: const [
                  Tab(text: "Release"),
                  Tab(text: "Receive"),
                  Tab(text: "Complete"),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(color: appTheme.green),
                  Container(color: appTheme.primary),
                  const CompleteTab(),
                ],
              ),
            ),
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
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    context.read<BatchCompBloc>().add(
      GetBatchCompData(userId: loggedUser.userId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Expanded(
          child: BlocBuilder<BatchCompBloc, BatchCompState>(
            builder: (context, state) {
              if (state.fetchStatus == RequestStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.fetchStatus == RequestStatus.success) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    var data = state.batchCompData[index];
                    return CompleteWidget(data: data);
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: state.batchCompData.length,
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}
