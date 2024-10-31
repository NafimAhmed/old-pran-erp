import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
import 'package:pdfrx/pdfrx.dart' as pdfview;
import 'package:permission_handler/permission_handler.dart';

import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/generate_qr_screen/cubit/qr_generate_cubit.dart';

class GenerateQrScreen extends StatefulWidget {
  const GenerateQrScreen({super.key});
  static const String routePath = "/generateQr-screen";
  static const String routeName = "generateQr-screen";
  @override
  State<GenerateQrScreen> createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrGenerateCubit(),
      child: const GenerateQrScreenBody(),
    );
  }
}

class GenerateQrScreenBody extends StatefulWidget {
  const GenerateQrScreenBody({super.key});

  @override
  State<GenerateQrScreenBody> createState() => _GenerateQrScreenBodyState();
}

class _GenerateQrScreenBodyState extends State<GenerateQrScreenBody> {
  @override
  void initState() {
    context.read<QrGenerateCubit>().setNewData("Miraj");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Generate Qr Code"),
      body: Column(
        children: [
          BlocBuilder<QrGenerateCubit, Uint8List?>(
            builder: (context, state) {
              if (state != null) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  color: Colors.blueGrey,
                  height: 200,
                  child: pdfview.PdfViewer.data(
                    state,
                    sourceName: "",
                    params: pdfview.PdfViewerParams(
                      backgroundColor: appTheme.green,
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
              return Container();
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
              log(statuses.toString());

              // Use context to select the device after checking mounted state
              if (!mounted) {
                return;
              }
              final device =
                  await FlutterBluetoothPrinter.selectDevice(context);

              // Print if a device is selected and the widget is still mounted
              if (device != null && mounted) {
                try {
                  var res = await FlutterBluetoothPrinter.printBytes(
                    data: qrData!, // Use the captured data
                    address: device.address,
                    keepConnected: true,
                    delayTime: 50,
                    onProgress: (total, sent) {
                      log(total.toString());
                      log(sent.toString());
                    },
                  );
                } catch (e) {
                  log(e.toString());
                }
              }
            },
            child: const Text("GetData"),
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
