import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/grn_qr_list_response.dart';
import 'package:pran_rfl_erp/core/utils/pdf_service.dart';

class GrnQrGenerateCubit extends Cubit<Uint8List?> {
  GrnQrGenerateCubit() : super(null);
  Future<void> generateQr(GrnQr grnQrData) async {
    var data = await PdfService.createGrnQrPdf(grnQrData);
    emit(data);
  }
}
