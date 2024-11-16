import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';

class PdfService {
  static Future<Uint8List> createBatchQrPdf(
      UserBatchQrData userBatchQrData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.standard.copyWith(
          height: 5.6 * PdfPageFormat.cm,
          width: 10.41 * PdfPageFormat.cm,
          marginBottom: 0.05 * PdfPageFormat.cm,
          marginLeft: 0.05 * PdfPageFormat.cm,
          marginRight: 0.05 * PdfPageFormat.cm,
          marginTop: 0.05 * PdfPageFormat.cm,
        ),
        build: (pw.Context context) {
          return pw.Container(
            // color: PdfColors.amber,
            padding: const pw.EdgeInsets.only(
              right: 9,
              left: 9,
              top: 3,
              bottom: 3,
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 5,
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
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            buildQrDetails(
                              lable: "ItemName",
                              value: userBatchQrData.itemname ?? "",
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            buildQrDetails(
                              lable: "Customer",
                              value: userBatchQrData.custname ?? "",
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            buildQrDetails(
                              lable: "Buyer Name",
                              value: userBatchQrData.buyername ?? "",
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            buildQrDetails(
                              lable: "Job No",
                              value: userBatchQrData.jobno ?? "",
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            pw.Row(
                              children: [
                                pw.Flexible(
                                  child: buildQrDetailsWLa(
                                    lable: "FPO: ",
                                    value: userBatchQrData.fpono ?? "",
                                  ),
                                ),
                                pw.VerticalDivider(
                                  color: PdfColors.black,
                                  width: 5,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                                pw.Flexible(
                                  child: buildQrDetailsWLa(
                                    lable: "Batch: ",
                                    value: userBatchQrData.batchNo ?? "",
                                  ),
                                )
                              ],
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Flexible(
                                  child: buildQrDetailsWLa(
                                    lable: "QTY: ",
                                    value: userBatchQrData.goodQty.toString(),
                                  ),
                                ),
                                pw.VerticalDivider(
                                  color: PdfColors.black,
                                  width: 5,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                                pw.Flexible(
                                  child: pw.Text(
                                    userBatchQrData.expdate ?? "",
                                    textAlign: pw.TextAlign.right,
                                    style: const pw.TextStyle(
                                      fontSize: 8,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 5),
                    pw.BarcodeWidget(
                      color: PdfColors.black,
                      barcode: pw.Barcode.qrCode(),
                      width: 85,
                      height: 85,
                      data:
                          "${userBatchQrData.itemname}\n${userBatchQrData.buyername}\n${userBatchQrData.custname}\n${userBatchQrData.createdDate}\n${userBatchQrData.jobno}\n${userBatchQrData.locLocator}\n${"Good Qty:${userBatchQrData.goodQty}"}\n${userBatchQrData.toQrJson()}",
                    ),
                  ],
                ),
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
      // pw.Flexible(
      //   child: pw.Text(
      //     lable,
      //     textAlign: pw.TextAlign.left,
      //     style: const pw.TextStyle(
      //       fontSize: 8,
      //       color: PdfColors.black,
      //     ),
      //   ),
      // ),
      // pw.SizedBox(
      //   width: 5,
      // ),
      pw.Flexible(
        flex: 2,
        child: pw.Text(
          value,
          textAlign: pw.TextAlign.left,
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.black,
          ),
        ),
      )
    ],
  );
}

pw.Widget buildQrDetailsWLa({required String lable, required String value}) {
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
          textAlign: pw.TextAlign.left,
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.black,
          ),
        ),
      )
    ],
  );
}
