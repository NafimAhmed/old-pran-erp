import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/common_widgets/shapes/custom_shape_painter2.dart';

import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/image_constant.dart';
import 'package:pran_rfl_erp/presentations/inventory_management_screen/inventory_management_screen.dart';
import 'package:pran_rfl_erp/presentations/opm_screen/opm_screen.dart';

class ModulesDashboardScreen extends StatelessWidget {
  const ModulesDashboardScreen({super.key});
  static const String routePath = "/modules-dashboard-screen";
  static const String routeName = "modules-dashboard-screen";
  @override
  Widget build(BuildContext context) {
    return const DashboardScreenBody();
  }
}

class DashboardScreenBody extends StatefulWidget {
  const DashboardScreenBody({super.key});

  @override
  State<DashboardScreenBody> createState() => _DashboardScreenBodyState();
}

class _DashboardScreenBodyState extends State<DashboardScreenBody> {
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
                        Text(
                          "Miraj Hossain Shawon",
                          style: textTheme.bodyMedium!.copyWith(
                            color: appTheme.white,
                          ),
                        ),
                        Text(
                          "ID: 494605",
                          style: textTheme.bodyMedium!.copyWith(
                            color: appTheme.white,
                          ),
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
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    mainAxisExtent: 130,
                  ),
                  children: [
                    ModuleWidget(
                      icon: ImageConstant.process,
                      title: "OPM",
                      onTap: () {
                        context.pushNamed(OpmScreen.routeName);
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(InventoryManagementScreen.routeName);
                      },
                      child: Visibility(
                        visible: true,
                        child: ModuleWidget(
                          icon: ImageConstant.inventory,
                          title: "Inventory Management",
                        ),
                      ),
                    ),
                    ModuleWidget(
                      icon: ImageConstant.cargo,
                      title: "Purchase Order",
                    ),
                    ModuleWidget(
                      icon: ImageConstant.orderManagement,
                      title: "Order Management",
                    ),
                  ],
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
