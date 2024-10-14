import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/shapes/custom_shape_painter.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/production_screen/bloc/prod_qr_bloc.dart';
import 'package:pran_rfl_erp/presentations/transfer_screen/transfer_screen.dart';

class ProductionScreen extends StatelessWidget {
  const ProductionScreen({super.key});
  static const String routeName = "prod-supervisor/production-screen";
  static const String routePath = "prod-supervisor/production-screen";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProdQrBloc(),
      child: const ProductionScreenBody(),
    );
  }
}

class ProductionScreenBody extends StatefulWidget {
  const ProductionScreenBody({super.key});

  @override
  State<ProductionScreenBody> createState() => _ProductionScreenBodyState();
}

class _ProductionScreenBodyState extends State<ProductionScreenBody> {
  TextEditingController quentityTextController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController goodQtyTextController = TextEditingController();
  FocusNode goodQtyFocusNode = FocusNode();
  TextEditingController badQtyTextController = TextEditingController();
  FocusNode badQtyFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CommonAppBar(appBartitle: "Production"),
      body: CustomPaint(
        painter: CustomShapePainter(),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: appTheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Flexible(
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_2,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(child: Text("Miraj Hossain Shawon"))
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            DateTime.now().toFormatedString("dd-MMM-yyy"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              BlocListener<ProdQrBloc, ProdQrState>(
                listener: (context, state) {
                  if (state is ProdQrError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Unable to get locator Id",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: appTheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(
                              20,
                            ),
                            bottomRight: Radius.circular(
                              20,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Scan QR",
                            style: textTheme.bodyMedium!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton.filled(
                      onPressed: () async {
                        var data = await _buildScanner(context, controller);

                        context.read<ProdQrBloc>().add(
                              ProdQrDataGet(
                                qrData: data,
                              ),
                            );
                      },
                      icon: Icon(
                        Icons.qr_code_scanner_rounded,
                        color: appTheme.white,
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<ProdQrBloc, ProdQrState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  if (state is ProdQrLoaded) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: appTheme.primary.withOpacity(
                            0.5,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Locator Id",
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            state.locatorId,
                            style: textTheme.bodyMedium,
                          )
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: appTheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(
                            20,
                          ),
                          bottomRight: Radius.circular(
                            20,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Enter Quantity",
                          style: textTheme.bodyMedium!.copyWith(
                            color: appTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CommonTextFieldWidget(
                      focusNode: passwordFocusNode,
                      textAlign: TextAlign.center,
                      controller: quentityTextController,
                      keyboardType: TextInputType.phone,
                      style: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: appTheme.primary,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      labelText: "",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Quantity";
                        }
                        return null;
                      },
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: appTheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(
                                  20,
                                ),
                                bottomRight: Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Good Quantity",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextFieldWidget(
                            focusNode: goodQtyFocusNode,
                            textAlign: TextAlign.center,
                            controller: goodQtyTextController,
                            keyboardType: TextInputType.phone,
                            style: textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: appTheme.primary,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            labelText: "",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Good Quantity";
                              }
                              return null;
                            },
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: appTheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(
                                  20,
                                ),
                                bottomRight: Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Bad Quantity",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextFieldWidget(
                            focusNode: badQtyFocusNode,
                            textAlign: TextAlign.center,
                            controller: badQtyTextController,
                            keyboardType: TextInputType.phone,
                            style: textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: appTheme.primary,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            labelText: "",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Bad Quantity";
                              }
                              return null;
                            },
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // context.read<QrCodeBloc>().add(QrCodeDataSave());
                  },
                  child: Text(
                    "Save",
                    style: textTheme.bodyMedium!.copyWith(
                      color: appTheme.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _buildScanner(
      BuildContext context, MobileScannerController? controller) async {
    // Use a completer to wait for the scanned result
    final completer = Completer<String>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              5.0,
            ),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.45,
            padding: const EdgeInsets.all(10.0),
            child: QrScannerWidget(
              controller: controller,
              onDetect: (barcodes) {
                final String detectedData = barcodes.barcodes.isNotEmpty
                    ? barcodes.barcodes.first.rawValue ?? 'No data found'
                    : 'No data found';

                // Complete the completer with the detected data
                completer.complete(detectedData);

                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );

    // Await the completion of the completer and return the result
    return completer.future;
  }
}
