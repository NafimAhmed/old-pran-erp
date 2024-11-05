import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/user_qr_print_response.dart';
import 'package:pran_rfl_erp/core/utils/pdf_service.dart';

class QrGenerateCubit extends Cubit<Uint8List?> {
  QrGenerateCubit() : super(null);
  Future<void> generateQr(UserBatchQrData userBatchQrData) async {
    var data = await PdfService.createBatchQrPdf(userBatchQrData);
    emit(data);
  }
}
