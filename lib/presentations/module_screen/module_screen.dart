import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/shapes/custom_shape_painter.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_menu_bloc.dart';
import 'package:pran_rfl_erp/presentations/generate_qr_screen/generate_qr_screen.dart';

class ModuleScreen extends StatelessWidget {
  const ModuleScreen({
    super.key,
    required this.moduleName,
  });
  final String moduleName;
  static const String routePath = "/module-screen";
  static const String routeName = "module-screen";
  @override
  Widget build(BuildContext context) {
    return ModuleScreenBody(
      moduleName: moduleName,
    );
  }
}

class ModuleScreenBody extends StatefulWidget {
  const ModuleScreenBody({
    super.key,
    required this.moduleName,
  });
  final String moduleName;
  @override
  State<ModuleScreenBody> createState() => _ModuleScreenBodyState();
}

class _ModuleScreenBodyState extends State<ModuleScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.moduleName),
      resizeToAvoidBottomInset: false,
      body: CustomPaint(
        painter: CustomShapePainter(),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: BlocBuilder<UserMenuBloc, UserMenuState>(
                  builder: (context, state) {
                    if (state is UserMenuSuccess) {
                      var moduleMenu = state.menuItems
                          .where(
                            (element) =>
                                element.moduleName == widget.moduleName,
                          )
                          .first;
                      return ListView.separated(
                        itemCount: moduleMenu.userPmenuItems?.length ?? 0,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemBuilder: (context, index) {
                          var pMenuItem = moduleMenu.userPmenuItems?[index];
                          return Card(
                            elevation: 10,
                            child: ExpansionTile(
                              title: Text(
                                pMenuItem?.menuName ?? "",
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
                                OPMSubModuleWidget(
                                  title: "Generate Qr",
                                  onTap: () {
                                    context
                                        .pushNamed(GenerateQrScreen.routeName);
                                  },
                                ),
                                ...List.generate(
                                    pMenuItem?.userCmenuItems?.length ?? 0,
                                    (index) {
                                  var cMenuItem =
                                      pMenuItem?.userCmenuItems?[index];
                                  return OPMSubModuleWidget(
                                    title: cMenuItem?.menuName ?? "",
                                    onTap: () {
                                      context.pushNamed(cMenuItem!.linkAddrs!);
                                    },
                                  );
                                })
                              ],
                            ),
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

class OPMSubModuleWidget extends StatelessWidget {
  const OPMSubModuleWidget({
    super.key,
    required this.title,
    this.onTap,
  });
  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      titleTextStyle: textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.w600,
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right_rounded,
      ),
      enableFeedback: true,
      enabled: true,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
      ),
    );
  }
}

 // Card(
                //   elevation: 10,
                //   child: ExpansionTile(
                //     title: Text(
                //       "OPM Super User#",
                //       style: textTheme.bodyLarge!.copyWith(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     collapsedShape: const ContinuousRectangleBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(
                //           10,
                //         ),
                //       ),
                //     ),
                //     shape: const ContinuousRectangleBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(10),
                //       ),
                //     ),
                //     children: <Widget>[
                //       OPMSubModuleWidget(
                //         title: "Formulas",
                //         onTap: () {},
                //       ),
                //       OPMSubModuleWidget(
                //         title: "Recipes",
                //         onTap: () {},
                //       ),
                //     ],
                //   ),
                // ),