import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
    return MobileScanner(controller: controller, onDetect: onDetect);
  }
}
