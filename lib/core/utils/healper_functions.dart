import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/common_widgets/qr_scanner_widget.dart';

Future<String> buildScanner(
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
          height: MediaQuery.of(context).size.height * 0.35,
          width: MediaQuery.of(context).size.width * 0.25,
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
