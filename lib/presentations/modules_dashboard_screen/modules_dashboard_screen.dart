import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';

import 'package:pran_rfl_erp/common_widgets/shapes/custom_shape_painter2.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/image_constant.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_menu_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';

class ModulesDashboardScreen extends StatelessWidget {
  const ModulesDashboardScreen({
    super.key,
  });
  static const String routePath = "/dashboard-screen";
  static const String routeName = "dashboard-screen";

  @override
  Widget build(BuildContext context) {
    return const DashboardScreenBody();
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
  @override
  void initState() {
    var loggedUser = context.read<LoggedUserInfoCubit>().state;
    context.read<UserMenuBloc>().add(UserMenuGet(userId: loggedUser!.userId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: CustomShapePainter2(),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<LoggedUserInfoCubit, UserInfoModel?>(
                          buildWhen: (previous, current) => previous != current,
                          builder: (context, state) {
                            return Text(
                              state != null ? state.userName ?? "" : "",
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            );
                          },
                        ),
                        BlocBuilder<LoggedUserInfoCubit, UserInfoModel?>(
                          builder: (context, state) {
                            return Text(
                              "ID: ${state != null ? state.userId ?? "" : ""}",
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: BlocBuilder<UserMenuBloc, UserMenuState>(
                  builder: (context, state) {
                    if (state is UserMenuSuccess) {
                      return GridView.builder(
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
                              setState(() {});
                            },
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
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
