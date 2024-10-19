import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/shapes/custom_shape_painter.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/production_screen/production_screen.dart';
import 'package:pran_rfl_erp/presentations/transfer_details_screen/transfer_details_screen.dart';
import 'package:pran_rfl_erp/presentations/transfer_screen/transfer_screen.dart';
import 'package:pran_rfl_erp/presentations/opm_prod_supervisor_screen/opm_prod_supervisor_screen.dart';

class OpmScreen extends StatelessWidget {
  const OpmScreen({
    super.key,
  });
  static const String routePath = "opm-screen";
  static const String routeName = "opm-screen";
  @override
  Widget build(BuildContext context) {
    return const OpmScreenBody();
  }
}

class OpmScreenBody extends StatefulWidget {
  const OpmScreenBody({
    super.key,
  });

  @override
  State<OpmScreenBody> createState() => _OpmScreenBodyState();
}

class _OpmScreenBodyState extends State<OpmScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Opm Module"),
      body: CustomPaint(
        painter: CustomShapePainter(),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 10,
                  child: ExpansionTile(
                    title: Text(
                      "OPM Super User#",
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
                        title: "Formulas",
                        onTap: () {},
                      ),
                      OPMSubModuleWidget(
                        title: "Recipes",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 10,
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
                      // OPMSubModuleWidget(
                      //   title: "Firm Planned Order Details",
                      //   onTap: () {},
                      // ),
                      // OPMSubModuleWidget(
                      //   title: "Create Document",
                      //   onTap: () {},
                      // ),
                      OPMSubModuleWidget(
                        title: "Batch Details",
                        onTap: () {
                          context.pushNamed(OpmProdSupervisorScreen.routeName);
                        },
                      ),
                      OPMSubModuleWidget(
                        title: "Material Transactions",
                        onTap: () {},
                      ),
                      OPMSubModuleWidget(
                        title: "Production",
                        onTap: () {
                          context.pushNamed(ProductionScreen.routeName);
                        },
                      ),
                      OPMSubModuleWidget(
                        title: "Transfer",
                        onTap: () {
                          context.pushNamed(TransferScreen.routeName);
                        },
                      ),
                      OPMSubModuleWidget(
                        title: "Tranfer Details",
                        onTap: () {
                          context.pushNamed(TransferDetailsScreen.routeName);
                        },
                      ),
                      // OPMSubModuleWidget(
                      //   title: "On-Hand, Availability",
                      //   onTap: () {},
                      // ),
                      // OPMSubModuleWidget(
                      //   title: "OPM Item Cost",
                      //   onTap: () {},
                      // ),
                      // OPMSubModuleWidget(
                      //   title: "Stock Transfer(Auto TO/IT)",
                      //   onTap: () {},
                      // ),

                      // OPMSubModuleWidget(
                      //   title: "Change Organization",
                      //   onTap: () {},
                      // ),
                    ],
                  ),
                ),
              ],
            ),
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

// class OpmWidget extends StatelessWidget {
//   const OpmWidget({
//     super.key,
//     required this.title,
//     required this.icon,
//     this.onTap,
//   });
//   final String title;
//   final String icon;
//   final void Function()? onTap;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Material(
//         borderRadius: BorderRadius.circular(8),
//         elevation: 15,
//         child: Container(
//           // padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             // gradient: LinearGradient(
//             //   begin: Alignment.topCenter,
//             //   end: Alignment.bottomCenter,
//             //   stops: const [0.65, 0.35],
//             //   colors: [
//             //     appTheme.white,
//             //     appTheme.primary,
//             //   ],
//             // ),
//             border: Border(
//               bottom: BorderSide(
//                 color: appTheme.primary,
//               ),
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   title,
//                   style: textTheme.bodyMedium!.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: appTheme.primary,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Image.asset(
//                   icon,
//                   height: 60,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
