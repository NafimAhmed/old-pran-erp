import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/express_qr_screen/bloc/qr_code_bloc.dart';

class ExpressQrScreen extends StatelessWidget {
  const ExpressQrScreen({super.key});
  static const String routeName = "prod-supervisor/express-qr-screen";
  static const String routePath = "prod-supervisor/express-qr-screen";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrCodeBloc(),
      child: const ExpressQrScreenBody(),
    );
  }
}

class ExpressQrScreenBody extends StatefulWidget {
  const ExpressQrScreenBody({super.key});

  @override
  State<ExpressQrScreenBody> createState() => _ExpressQrScreenBodyState();
}

MobileScannerController? controller = MobileScannerController();

class _ExpressQrScreenBodyState extends State<ExpressQrScreenBody> {
  Map<String, dynamic> sourceQrData = {};

  Map<String, dynamic> destinationQrData = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "ExpressQr"),
      body: BlocConsumer<QrCodeBloc, QrCodeState>(
        listener: (context, state) {
          if (state is QrCodeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Unable to Read QR Code",
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is QrCodeLoaded) {
            sourceQrData = state.sourceQrData;
            destinationQrData = state.destinationQrData;
          }
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
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
                            "Product/Source QR",
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

                        context.read<QrCodeBloc>().add(
                              QrCodeDataGet(
                                  sourceQrData: data, destinationQrData: ""),
                            );
                      },
                      icon: Icon(
                        Icons.qr_code_scanner_rounded,
                        color: appTheme.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                  visible: sourceQrData.isNotEmpty,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: appTheme.primary.withOpacity(
                        0.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        ...List.generate(
                          sourceQrData.length,
                          (index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  sourceQrData.entries.elementAt(index).key,
                                ),
                                Text(
                                  sourceQrData.entries
                                      .elementAt(index)
                                      .value
                                      .toString(),
                                ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
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
                            "Rack/Destination QR",
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
                        context.read<QrCodeBloc>().add(
                              QrCodeDataGet(
                                sourceQrData: "",
                                destinationQrData: data,
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
                BlocBuilder<QrCodeBloc, QrCodeState>(
                  builder: (context, state) {
                    if (state is QrCodeLoaded &&
                        state.destinationQrData.isNotEmpty) {
                      destinationQrData = state.destinationQrData;
                    }
                    return Visibility(
                      visible: destinationQrData.isNotEmpty,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.primary.withOpacity(
                            0.2,
                          ),
                        ),
                        child: Column(
                          children: [
                            ...List.generate(
                              destinationQrData.length,
                              (index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      destinationQrData.entries
                                          .elementAt(index)
                                          .key,
                                    ),
                                    Text(
                                      destinationQrData.entries
                                          .elementAt(index)
                                          .value
                                          .toString(),
                                    ),
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                // Visibility(
                //   visible: destinationQrData.isNotEmpty &&
                //           destinationQrData != "No data found"
                //       ? true
                //       : false,
                //   child: _buidDestInfoWidget(destinationQrData),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buidSourceInfoWidget(String text) {
    final Map<String, dynamic> data = json.decode(text);

    // if (text.isNotEmpty && text != "No data found") {
    //   List<String> splittedData = text.split("\n");
    //   splittedData.removeWhere(
    //     (element) => element.isEmpty,
    //   );
    //   return Column(
    //     children: [
    //       Container(
    //         decoration: BoxDecoration(
    //           color: appTheme.primary.withOpacity(0.2),
    //           borderRadius: const BorderRadius.only(
    //             topLeft: Radius.circular(10),
    //             bottomLeft: Radius.circular(10),
    //           ),
    //         ),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Container(
    //               padding: const EdgeInsets.all(10),
    //               decoration: BoxDecoration(
    //                 color: appTheme.tertiary,
    //                 borderRadius: const BorderRadius.only(
    //                   topLeft: Radius.circular(10),
    //                   bottomLeft: Radius.circular(10),
    //                 ),
    //               ),
    //               child: Text(
    //                 "Product Code",
    //                 style: textTheme.bodyMedium!.copyWith(
    //                   color: appTheme.white,
    //                 ),
    //               ),
    //             ),
    //             Flexible(
    //               child: Text(
    //                 splittedData[0],
    //                 style: textTheme.bodyMedium,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   );
    // }

    return Text(data.toString());
  }

  Widget _buidDestInfoWidget(String text) {
    if (text.isNotEmpty && text != "No data found") {
      List<String> splittedData = text.split("\n");
      splittedData.removeWhere(
        (element) => element.isEmpty,
      );
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: appTheme.primary.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: appTheme.tertiary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Rack Code",
                    style: textTheme.bodyMedium!.copyWith(
                      color: appTheme.white,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    splittedData[0],
                    style: textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Text(text);
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

class QrScannerWidget extends StatelessWidget {
  const QrScannerWidget({
    super.key,
    required this.controller,
    required this.onDetect,
  });

  final MobileScannerController? controller;
  final void Function(BarcodeCapture)? onDetect;
  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: onDetect,
    );
  }
}

// class DeleteReviewDialog extends StatelessWidget {
//   const DeleteReviewDialog({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 5),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           GestureDetector(
//             onTap: () {
//               context.pop();
//             },
//             child: const Align(
//               alignment: Alignment.topRight,
//               child: Icon(
//                 Icons.close,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             "Are you sure you want to delete this review?",
//             textAlign: TextAlign.center,
//             style: textTheme.bodyMedium!.copyWith(
//               fontWeight: FontWeight.bold,
//               color: const Color.fromRGBO(30, 30, 30, 1),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Container(
//             width: 137,
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 10,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(
//                 20,
//               ),
//               color: const Color.fromRGBO(196, 66, 23, 1),
//             ),
//             child: Center(
//               child: Text(
//                 "Delete",
//                 style: textTheme.bodyMedium!.copyWith(
//                   color: appTheme.white,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
