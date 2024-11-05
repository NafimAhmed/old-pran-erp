import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  static Future<Uint8List> createQrPdf() async {
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
            color: PdfColors.amber,
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
                              value: "PBO-RIP-Plas Export",
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            buildQrDetails(
                              lable: "Item",
                              value:
                                  "620256 Storage Container Square Lid367 ml Lid367 ml Lid367 ml Purple",
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            buildQrDetails(
                              lable: "Order Info",
                              value: "Test Order Info",
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            buildQrDetails(
                              lable: "Prod Qty",
                              value: "12345466555555555",
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
                      data:
                          "This is the test data to print qr code for batch data automation all these things are to test this print..",
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
