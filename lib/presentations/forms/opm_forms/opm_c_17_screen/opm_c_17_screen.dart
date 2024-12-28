import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_17_screen/bloc/opm_dash_sm_bloc.dart';
import 'package:pran_rfl_erp/presentations/module_screen/module_screen.dart';

class OpmC17Screen extends StatelessWidget {
  const OpmC17Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-17-SCREEN";
  static const String routePath = "/OPM-C-17-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OpmDashSmBloc(getService()),
      child: OpmC17ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class OpmC17ScreenBody extends StatefulWidget {
  const OpmC17ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC17ScreenBody> createState() => _OpmC17ScreenBodyState();
}

class _OpmC17ScreenBodyState extends State<OpmC17ScreenBody> {
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<OpmDashSmBloc>().add(GetOpmDashSm(userId: loggedUser.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    // var dTopPad = MediaQuery.of(context).viewPadding.top;
    // var dBotPad = MediaQuery.of(context).viewPadding.bottom;

    // final double itemHeight = (size.height - dTopPad - dBotPad) / 5.5;
    // final double itemWidth = (size.width - 30) / 2;
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: ExpansionTile(
                        title: Text(
                          "Production Supervisor#",
                          style: textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        collapsedShape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                        ),
                        shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        children: <Widget>[
                          ...List.generate(10, (index) {
                            return OPMSubModuleWidget(
                              title: "Test",
                              onTap: () {},
                            );
                          })
                        ],
                      ),
                    )
                  ];
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Expanded(
            //   child: BlocBuilder<OpmDashSmBloc, OpmDashSmState>(
            //     builder: (context, state) {
            //       if (state is OpmDashSmSuccess) {
            //         var prodSts = state.dashReport.prodDtlStatus?.first;
            //         var jobSts = state.dashReport.jobDetailsStatus?.first;
            //         var batchSts = state.dashReport.batchStatus?.first;
            //         var exportSts = state.dashReport.extDtlStatus?.first;
            //         return GridView(
            //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //               crossAxisCount: 2,
            //               crossAxisSpacing: 15,
            //               mainAxisSpacing: 15,
            //               mainAxisExtent:
            //                   MediaQuery.of(context).size.height * 0.175
            //               // childAspectRatio: (itemWidth / itemHeight),
            //               ),
            //           children: [
            //             OpmDashSmWidget(
            //               data: jobSts?.toTabMap() ?? {},
            //               lable: "Job Status",
            //               onTap: () {
            //                 context.pushNamed(OpmDashDetailsScreen.routeName);
            //               },
            //             ),
            //             OpmDashSmWidget(
            //               data: prodSts?.toTabMap() ?? {},
            //               lable: "Product Status",
            //             ),
            //             OpmDashSmWidget(
            //               data: batchSts?.toTabMap() ?? {},
            //               lable: "Batch Status",
            //             ),
            //             OpmDashSmWidget(
            //               data: exportSts?.toTabMap() ?? {},
            //               lable: "Export Status",
            //             ),
            //           ],
            //         );
            //       }
            //       return Container();
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
