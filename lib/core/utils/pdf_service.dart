import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  static Future<Uint8List> createQrPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.standard.copyWith(
          height: 4.7 * PdfPageFormat.cm,
          width: 9.7 * PdfPageFormat.cm,
          marginBottom: 0.5 * PdfPageFormat.cm,
          marginLeft: 0.5 * PdfPageFormat.cm,
          marginRight: 0.5 * PdfPageFormat.cm,
          marginTop: 0.5 * PdfPageFormat.cm,
        ),
        build: (pw.Context context) {
          return pw.Container(
            // color: PdfColors.amber,
            child: pw.Column(
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
                              value: "PBO-RIP-Plas Export",
                            ),
                            buildQrDetails(
                              lable: "Item",
                              value:
                                  "620256 Storage Container Square Lid367 ml Purple",
                            ),
                            buildQrDetails(
                              lable: "Order Info",
                              value: "",
                            ),
                            buildQrDetails(
                              lable: "Prod Qty",
                              value: "12345466",
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.BarcodeWidget(
                      color: PdfColors.black,
                      barcode: pw.Barcode.qrCode(),
                      width: 80,
                      height: 80,
                      data: "My data",
                    ),
                    // pw.Expanded(
                    //   flex: 1,
                    //   child:
                    // )
                  ],
                )
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
