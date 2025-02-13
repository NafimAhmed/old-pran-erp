import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/image_constant.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_menu_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_17_screen/bloc/opm_dash_sm_bloc.dart';
import 'package:pran_rfl_erp/presentations/login_screeen/bloc/login_bloc.dart';
import 'package:pran_rfl_erp/presentations/login_screeen/login_screen.dart';
import 'package:pran_rfl_erp/presentations/module_screen/module_screen.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';
import 'package:pran_rfl_erp/presentations/modules_dashboard_screen/cubit/app_info_cubit_cubit.dart';
import 'package:pran_rfl_erp/presentations/user_profile/user_profile_screen/user_profile_screen.dart';

class ModulesDashboardScreen extends StatelessWidget {
  const ModulesDashboardScreen({
    super.key,
  });
  static const String routePath = "/dashboard-screen";
  static const String routeName = "dashboard-screen";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(getService()),
        ),
        BlocProvider(
          create: (context) => AppInfoCubitCubit()..getInfo(),
        ),
        BlocProvider(
          create: (context) => OpmDashSmBloc(getService()),
        )
      ],
      child: const DashboardScreenBody(),
    );
  }
}

class DashboardScreenBody extends StatefulWidget {
  const DashboardScreenBody({
    super.key,
  });

  @override
  State<DashboardScreenBody> createState() => _DashboardScreenBodyState();
}

class _DashboardScreenBodyState extends State<DashboardScreenBody> {
  Map<String, List<String>> groupedModule = {};
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<UserMenuBloc>().add(UserMenuGet(userId: loggedUser.userId));
    context.read<UserOrgBloc>().add(UserOrgGet(userId: loggedUser.userId));
    context.read<OpmDashSmBloc>().add(GetOpmDashSm(userId: loggedUser.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<UserMenuBloc>()
            .add(UserMenuGet(userId: loggedUser.userId));
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: appTheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).viewPadding.top,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(UserProfileScreen.routeName);
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: appTheme.white,
                              width: 2,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                ImageConstant.malePlaceholder,
                              ),
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: BlocBuilder<LoggedUserInfoCubit, UserInfoModel?>(
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state != null ? state.userName : "",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.white,
                                      ),
                                    ),
                                    Text(
                                      "ID: ${state != null ? state.userId : ""}",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.white,
                                      ),
                                    ),
                                  ],
                                ),
                                BlocConsumer<LoginBloc, LoginState>(
                                  listener: (context, state) {
                                    if (state is LoginInitial) {
                                      context.pushReplacementNamed(
                                          LoginScreen.routeName);
                                    }
                                  },
                                  builder: (context, state) {
                                    return ElevatedButton(
                                      style:
                                          ElevatedButton.styleFrom().copyWith(
                                        padding: const WidgetStatePropertyAll<
                                            EdgeInsetsGeometry>(
                                          EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 10,
                                          ),
                                        ),
                                        minimumSize:
                                            WidgetStateProperty.all<Size>(
                                          const Size(80, 30),
                                        ),
                                        backgroundColor:
                                            const WidgetStatePropertyAll(
                                          Color.fromARGB(255, 151, 21, 11),
                                        ),
                                      ),
                                      onPressed: () {
                                        context.read<LoginBloc>().add(Logout());
                                      },
                                      child: Text(
                                        state is LoginLoading
                                            ? "Logging Out.."
                                            : "Logout",
                                        style: textTheme.bodyMedium!.copyWith(
                                          color: appTheme.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BlocBuilder<UserMenuBloc, UserMenuState>(
              builder: (context, state) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      if (state is UserMenuSuccess) {
                        return [
                          ...List.generate(state.menuItems.length, (index) {
                            return PopupMenuItem(
                              child: OPMSubModuleWidget(
                                title: state.menuItems
                                        .elementAt(index)
                                        .moduleName ??
                                    "",
                                onTap: () {
                                  // context.pop();
                                  if (state.menuItems
                                      .elementAt(index)
                                      .moduleName!
                                      .isNotEmpty) {
                                    context.pushNamed(
                                      ModuleScreen.routeName,
                                      extra: state.menuItems
                                          .elementAt(index)
                                          .moduleName,
                                    );
                                  }
                                },
                              ),
                            );
                          })
                        ];
                      }
                      return [];
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<OpmDashSmBloc, OpmDashSmState>(
                builder: (context, state) {
                  if (state is OpmDashSmLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is OpmDashSmSuccess) {
                    List<Map<String, Map<String, dynamic>>> list = [];

                    var prodSts = state.dashReport.prodDtlStatus?.first;
                    var jobSts = state.dashReport.jobDetailsStatus?.first;
                    var batchSts = state.dashReport.batchStatus?.first;
                    var exportSts = state.dashReport.extDtlStatus?.first;
                    if (jobSts != null) {
                      list.add({"Job Status": jobSts.toTabMap()});
                    }
                    if (prodSts != null) {
                      list.add({"Produsct Status": prodSts.toTabMap()});
                    }

                    if (batchSts != null) {
                      list.add({"Batch Status": batchSts.toTabMap()});
                    }
                    if (exportSts != null) {
                      list.add({"Export Status": exportSts.toTabMap()});
                    }
                    return GridView.builder(
                      itemCount: list.length,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          mainAxisExtent:
                              MediaQuery.of(context).size.height * 0.185
                          // childAspectRatio: (itemWidth / itemHeight),
                          ),
                      itemBuilder: (context, index) {
                        return OpmDashSmWidget(
                          data: list[index].entries.first.value,
                          lable: list[index].entries.first.key,
                          onTap: () {
                            // context.pushNamed(OpmDashDetailsScreen.routeName);
                          },
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          height: 30,
          decoration: BoxDecoration(
            color: appTheme.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Version:",
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.white,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              BlocBuilder<AppInfoCubitCubit, String?>(
                builder: (context, state) {
                  if (state != null) {
                    return Text(
                      state,
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.white,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OpmDashSmWidget extends StatelessWidget {
  const OpmDashSmWidget(
      {super.key, required this.data, required this.lable, this.onTap});
  final Map<String, dynamic> data;
  final String lable;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      elevation: 15,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: appTheme.primary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: appTheme.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: appTheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      lable,
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Column(
                  children: [
                    ...List.generate(
                      data.length,
                      (index) {
                        return Row(
                          children: [
                            Text(
                              data.entries.elementAt(index).key,
                              style: textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                data.entries.elementAt(index).value.toString(),
                                textAlign: TextAlign.right,
                                style: textTheme.bodySmall!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ModuleWidget extends StatelessWidget {
  const ModuleWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });
  final String title;
  final String icon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 15,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: appTheme.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: appTheme.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     title,
                //     style: textTheme.bodyMedium!.copyWith(
                //       fontWeight: FontWeight.bold,
                //       color: appTheme.primary,
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 5,
                // ),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: Image.asset(
                //     icon,
                //     height: 60,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
