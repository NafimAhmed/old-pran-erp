import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/shapes/custom_shape_painter.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/transfer_screen/bloc/transfer_batch_bloc.dart';

import 'package:pran_rfl_erp/presentations/transfer_screen/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/transfer_screen/cubit/rack_qr_cubit.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});
  static const String routeName = "prod-supervisor/express-qr-screen";
  static const String routePath = "prod-supervisor/express-qr-screen";
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ItemQrCubit(),
        ),
        BlocProvider(
          create: (context) => RackQrCubit(),
        ),
        BlocProvider(
          create: (context) => TransferBatchBloc(getService()),
        ),
      ],
      child: const TransferScreenBody(),
    );
  }
}

class TransferScreenBody extends StatefulWidget {
  const TransferScreenBody({super.key});

  @override
  State<TransferScreenBody> createState() => _TransferScreenBodyState();
}

MobileScannerController? controller = MobileScannerController();

class _TransferScreenBodyState extends State<TransferScreenBody> {
  List<String> itemQrData = [];

  List<String> rackQrData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Transfer"),
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
                          "Item QR",
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

                      // context.read<QrCodeBloc>().add(
                      //       QrCodeDataGet(
                      //           sourceQrData: data, destinationQrData: ""),
                      //     );
                      context.read<ItemQrCubit>().setItemData(itemQrData: data);
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
              BlocConsumer<ItemQrCubit, ItemQrState>(
                listener: (context, state) {
                  if (state is ItemQrDataError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Unable to Get Item QR Data",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ItemQrInitial) {
                    itemQrData.clear();
                  }
                  if (state is ItemQrDataLoaded) {
                    itemQrData = state.itemQRDatalist;
                    return Container(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Batch Id",
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                itemQrData[0],
                                style: textTheme.bodyMedium,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Item Id",
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                itemQrData[1],
                                style: textTheme.bodyMedium,
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
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
                          "Rack QR",
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
                      try {
                        var data = await _buildScanner(context, controller);
                        context
                            .read<RackQrCubit>()
                            .setrackData(rackQrData: data);
                      } catch (e) {
                        log('Error');
                      }
                    },
                    icon: Icon(
                      Icons.qr_code_scanner_rounded,
                      color: appTheme.white,
                    ),
                  ),
                ],
              ),
              BlocConsumer<RackQrCubit, RackQrState>(
                listener: (context, state) {
                  if (state is RackQrDataError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Unable to Get Rack QR Data",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is RackQrInitial) {
                    rackQrData.clear();
                  }
                  if (state is RackQrDataLoaded) {
                    rackQrData = state.rackQRDatalist;
                    return Container(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rack Id",
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                rackQrData[0],
                                style: textTheme.bodyMedium,
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 15,
              ),
              BlocConsumer<TransferBatchBloc, TransferBatchState>(
                listener: (context, state) {
                  if (state is TransferBatchSuccess) {
                    context.read<ItemQrCubit>().resetItemData();
                    context.read<RackQrCubit>().resetRackData();
                  }
                },
                builder: (context, state) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (itemQrData.isNotEmpty && rackQrData.isNotEmpty) {
                          context.read<TransferBatchBloc>().add(
                                TransferBatch(
                                    batchId: itemQrData[0],
                                    itemId: itemQrData[1],
                                    rackId: rackQrData[0]),
                              );
                        }
                      },
                      child: Text(
                        state is TransferBatchLoading ? "Saving..." : "Save",
                        style: textTheme.bodyMedium!.copyWith(
                          color: appTheme.white,
                        ),
                      ),
                    ),
                  );
                },
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

class QrScannerWidget extends StatelessWidget {
  const QrScannerWidget({
    super.key,
    required this.controller,
    required this.onDetect,
    this.errorBuilder,
  });

  final MobileScannerController? controller;
  final void Function(BarcodeCapture)? onDetect;
  final Widget Function(BuildContext context, MobileScannerException exception,
      Widget? widget)? errorBuilder;
  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: onDetect,
      errorBuilder: errorBuilder,
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
