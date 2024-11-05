import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pran_rfl_erp/app_data/entities/user_qr_print_response.dart';

class PdfService {
  static Future<Uint8List> createBatchQrPdf(
      UserBatchQrData userBatchQrData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.standard.copyWith(
          height: 2.0 * PdfPageFormat.inch,
          width: 4.10 * PdfPageFormat.inch,
          marginBottom: 0.15 * PdfPageFormat.cm,
          marginLeft: 0.15 * PdfPageFormat.cm,
          marginRight: 0.15 * PdfPageFormat.cm,
          marginTop: 0.15 * PdfPageFormat.cm,
        ),
        build: (pw.Context context) {
          return pw.Container(
            // color: PdfColors.amber,
            padding: const pw.EdgeInsets.only(
              right: 7,
              left: 5,
              top: 5,
              bottom: 5,
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            left: pw.BorderSide(
                              color: PdfColors.black,
                            ),
                            right: pw.BorderSide(
                              color: PdfColors.black,
                            ),
                            top: pw.BorderSide(
                              color: PdfColors.black,
                            ),
                            bottom: pw.BorderSide(
                              color: PdfColors.black,
                            ),
                          ),
                          color: PdfColors.white,
                        ),
                        child: pw.Column(
                          children: [
                            buildQrDetails(
                              lable: "ORG",
                              value: userBatchQrData.organizationCode ?? "",
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            buildQrDetails(
                              lable: "Item",
                              value: userBatchQrData.itemName ?? "",
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            buildQrDetails(
                              lable: "Batch No",
                              value: userBatchQrData.batchNo ?? "",
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            buildQrDetails(
                              lable: "Total Qty",
                              value: userBatchQrData.totalQty.toString(),
                            )
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.BarcodeWidget(
                      color: PdfColors.black,
                      barcode: pw.Barcode.qrCode(),
                      width: 80,
                      height: 80,
                      data: userBatchQrData.toJson(),
                    ),
                    // pw.Expanded(
                    //   flex: 1,
                    //   child:
                    // )
                  ],
                ),
                // pw.Spacer(),
                // pw.Text(
                //   "Test Message To See the output",
                //   textAlign: pw.TextAlign.right,
                //   style: const pw.TextStyle(
                //     fontSize: 8,
                //     color: PdfColors.black,
                //   ),
                // )
              ],
            ),
          );
        },
      ),
    );
    Uint8List data = await pdf.save();
    return data;
  }
}

pw.Widget buildQrDetails({required String lable, required String value}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Flexible(
        child: pw.Text(
          lable,
          textAlign: pw.TextAlign.left,
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.black,
          ),
        ),
      ),
      pw.SizedBox(
        width: 5,
      ),
      pw.Flexible(
        flex: 2,
        child: pw.Text(
          value,
          textAlign: pw.TextAlign.right,
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.black,
          ),
        ),
      )
    ],
  );
}
