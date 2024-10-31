import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/core/utils/pdf_service.dart';

class QrGenerateCubit extends Cubit<Uint8List?> {
  QrGenerateCubit() : super(null);
  Future<void> setNewData(String d) async {
    var data = await PdfService.createQrPdf();
    emit(data);
  }
}
