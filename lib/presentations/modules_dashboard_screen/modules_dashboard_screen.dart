import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';

import 'package:pran_rfl_erp/common_widgets/shapes/custom_shape_painter2.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/image_constant.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_menu_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/login_screeen/bloc/login_bloc.dart';
import 'package:pran_rfl_erp/presentations/login_screeen/login_screen.dart';
import 'package:pran_rfl_erp/presentations/module_screen/module_screen.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';

class ModulesDashboardScreen extends StatelessWidget {
  const ModulesDashboardScreen({
    super.key,
  });
  static const String routePath = "/dashboard-screen";
  static const String routeName = "dashboard-screen";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(getService()),
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
        backgroundColor: Colors.blueGrey[50],
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
                      Container(
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
                        // child: ClipRRect(
                        //   borderRadius: BorderRadius.circular(80),
                        //   child: Image.asset(
                        //     fit: BoxFit.fill,
                        //     ImageConstant.malePlaceholder,
                        //   ),
                        // ),
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
            Expanded(
              child: BlocBuilder<UserMenuBloc, UserMenuState>(
                builder: (context, state) {
                  if (state is UserMenuLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is UserMenuSuccess) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          mainAxisExtent: 130,
                        ),
                        itemCount: state.menuItems.length,
                        itemBuilder: (context, index) {
                          return ModuleWidget(
                            icon: ImageConstant.process,
                            title:
                                state.menuItems.elementAt(index).moduleName ??
                                    "",
                            onTap: () {
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
                          );
                        },
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
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
          // padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   stops: const [0.65, 0.35],
            //   colors: [
            //     appTheme.white,
            //     appTheme.primary,
            //   ],
            // ),
            border: Border(
              bottom: BorderSide(
                color: appTheme.primary,
              ),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: appTheme.primary,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  icon,
                  height: 60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
