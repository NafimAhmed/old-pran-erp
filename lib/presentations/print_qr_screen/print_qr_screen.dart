import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pdfrx/pdfrx.dart' as pdfview;
import 'package:permission_handler/permission_handler.dart';
import 'package:pran_rfl_erp/app_data/entities/user_qr_print_response.dart';

import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/pdf_service.dart';

import 'package:pran_rfl_erp/presentations/print_qr_screen/cubit/qr_generate_cubit.dart';
import 'package:printing/printing.dart';

class PrintQrScreen extends StatelessWidget {
  const PrintQrScreen({super.key, required this.userBatchQrData});
  static const String routePath = "/printQr-screen";
  static const String routeName = "printQr-screen";
  final UserBatchQrData userBatchQrData;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrGenerateCubit(),
      child: PrintQrScreenBody(
        userBatchQrData: userBatchQrData,
      ),
    );
  }
}

class PrintQrScreenBody extends StatefulWidget {
  const PrintQrScreenBody({super.key, required this.userBatchQrData});
  final UserBatchQrData userBatchQrData;
  @override
  State<PrintQrScreenBody> createState() => _PrintQrScreenBodyState();
}

class _PrintQrScreenBodyState extends State<PrintQrScreenBody> {
  @override
  void initState() {
    context.read<QrGenerateCubit>().generateQr(widget.userBatchQrData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Print Qr Code"),
      body: Column(
        children: [
          BlocBuilder<QrGenerateCubit, Uint8List?>(
            builder: (context, state) {
              if (state != null) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  height: 190,
                  child: pdfview.PdfViewer.data(
                    state,
                    sourceName: "",
                    params: pdfview.PdfViewerParams(
                      backgroundColor: Colors.transparent,
                      margin: 0,
                      maxScale: 20,
                      loadingBannerBuilder:
                          (context, bytesDownloaded, totalBytes) => Center(
                        child: CircularProgressIndicator(
                          value: totalBytes != null
                              ? bytesDownloaded / totalBytes
                              : null,
                          backgroundColor: appTheme.primary,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Container(
                height: 190,
              );
            },
          ),
          ElevatedButton(
            onPressed: () async {
              // Capture the data from QrGenerateCubit before any async call
              final qrData = context.read<QrGenerateCubit>().state;

              // Request permissions
              Map<Permission, PermissionStatus> statuses = await [
                Permission.location,
                Permission.bluetooth,
                Permission.bluetoothConnect,
                Permission.bluetoothScan
              ].request();
              // log(statuses.toString());

              // Use context to select the device after checking mounted state
              if (!context.mounted) return;
              try {
                var status = await Printing.layoutPdf(
                  // format: PdfPageFormat.standard.copyWith(
                  //   height: 2.5 * PdfPageFormat.inch,
                  //   width: 4.15 * PdfPageFormat.inch,
                  //   marginBottom: 0.05 * PdfPageFormat.cm,
                  //   marginLeft: 0.05 * PdfPageFormat.cm,
                  //   marginRight: 0.05 * PdfPageFormat.cm,
                  //   marginTop: 0.05 * PdfPageFormat.cm,
                  // ),
                  // dynamicLayout: true,
                  // forceCustomPrintPaper: true,
                  // usePrinterSettings: true,
                  onLayout: (format) =>
                      PdfService.createBatchQrPdf(widget.userBatchQrData),
                );
                log(status.toString());
              } catch (e) {
                log("Not Printed Due to Exception");
              }
            },
            child: Text(
              "Pritnt Qr",
              style: textTheme.bodyMedium!.copyWith(
                color: appTheme.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> requestPermission() async {
  //   final permission = Permission.bluetooth.status;

  //   if (await permission.isDenied) {

  //     log(statuses.toString());
  //   }
  // }
}
