import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pran_rfl_erp/app_data/models/grn_qr_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/smpl_qr_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';

class PdfService {
  static Future<Uint8List> createBatchQrPdf(
    UserBatchQrData userBatchQrData,
  ) async {
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
                            left: pw.BorderSide(color: PdfColors.grey),
                            right: pw.BorderSide(color: PdfColors.grey),
                            top: pw.BorderSide(color: PdfColors.grey),
                            bottom: pw.BorderSide(color: PdfColors.grey),
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
                            // pw.Divider(
                            //   color: PdfColors.black,
                            //   height: 5,
                            //   indent: 0,
                            //   endIndent: 0,
                            // ),
                            // buildQrDetails(
                            //   lable: "Customer",
                            //   value: userBatchQrData.custname ?? "",
                            // ),
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
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Expanded(
                                  child: pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        "JO: ",
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColors.black,
                                        ),
                                      ),
                                      pw.Expanded(
                                        child: pw.Text(
                                          userBatchQrData.jobno ?? "",
                                          textAlign: pw.TextAlign.left,
                                          style: const pw.TextStyle(
                                            fontSize: 8,
                                            color: PdfColors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                pw.SizedBox(width: 5),
                                pw.Expanded(
                                  child: pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        "LOT: ",
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColors.black,
                                        ),
                                      ),
                                      pw.Expanded(
                                        child: pw.Text(
                                          userBatchQrData.lotno ?? "",
                                          textAlign: pw.TextAlign.left,
                                          style: const pw.TextStyle(
                                            fontSize: 8,
                                            color: PdfColors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                                    lable: "FPO : ",
                                    value: userBatchQrData.fpono ?? "",
                                  ),
                                ),
                                pw.SizedBox(width: 7),
                                pw.Flexible(
                                  child: buildQrDetailsWLa(
                                    lable: "Batch : ",
                                    value: userBatchQrData.batchNo ?? "",
                                  ),
                                ),
                              ],
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
                                    lable: "QTY : ",
                                    value: userBatchQrData.goodQty.toString(),
                                  ),
                                ),
                                pw.SizedBox(width: 5),
                                pw.Flexible(
                                  child: buildQrDetailsWLa(
                                    lable: "ExpDt : ",
                                    value: userBatchQrData.expdate ?? "",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 7),
                    pw.BarcodeWidget(
                      color: PdfColors.black,
                      barcode: pw.Barcode.qrCode(),
                      width: 90,
                      height: 90,
                      data:
                          "${userBatchQrData.itemname}\n${userBatchQrData.buyername}\n${DateTime.parse(userBatchQrData.createdDate ?? '').toFormatedString("dd/MM/yyyy")}\n${userBatchQrData.jobno}\n${userBatchQrData.locLocator}\n${"Good Qty:${userBatchQrData.goodQty}"}\n${userBatchQrData.toQrJson()}\nhttps://ego.rflgroupbd.com:8077/ords/r/rpro/smartqr/location-wise-stock-report2?P86_JOB_ORDER=${userBatchQrData.jobno}",
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

  static Future<Uint8List> createGrnQrPdf(GrnQr grnQrData) async {
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
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
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
                            left: pw.BorderSide(color: PdfColors.black),
                            right: pw.BorderSide(color: PdfColors.black),
                            top: pw.BorderSide(color: PdfColors.black),
                            bottom: pw.BorderSide(color: PdfColors.black),
                          ),
                          color: PdfColors.white,
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "${grnQrData.itemCode ?? ""}-${grnQrData.itemName ?? ""}",
                              textAlign: pw.TextAlign.left,
                              style: const pw.TextStyle(
                                fontSize: 8,
                                color: PdfColors.black,
                              ),
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),

                            pw.Text(
                              "Org: ${grnQrData.orgId}-${grnQrData.organizationCode ?? ""}",
                              textAlign: pw.TextAlign.left,
                              style: const pw.TextStyle(
                                fontSize: 8,

                                color: PdfColors.black,
                              ),
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
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Expanded(
                                  child: pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        "Lot: ",
                                        textAlign: pw.TextAlign.left,
                                        style: const pw.TextStyle(
                                          fontSize: 8,

                                          color: PdfColors.black,
                                        ),
                                      ),
                                      pw.Text(
                                        "${grnQrData.trnid}",
                                        textAlign: pw.TextAlign.left,
                                        style: const pw.TextStyle(
                                          fontSize: 8,
                                          color: PdfColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        "Qty: ",
                                        textAlign: pw.TextAlign.left,
                                        style: const pw.TextStyle(
                                          fontSize: 8,

                                          color: PdfColors.black,
                                        ),
                                      ),
                                      pw.Expanded(
                                        child: pw.Text(
                                          grnQrData.qty?.toString() ?? "",
                                          textAlign: pw.TextAlign.left,
                                          style: const pw.TextStyle(
                                            fontSize: 8,
                                            color: PdfColors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            pw.Text(
                              "Sub Inv: ${grnQrData.subInv ?? ""}",
                              textAlign: pw.TextAlign.left,
                              style: const pw.TextStyle(
                                fontSize: 8,

                                color: PdfColors.black,
                              ),
                            ),
                            pw.Divider(
                              color: PdfColors.black,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            pw.Text(
                              "Locator: ${grnQrData.locatorDesc ?? ""}",
                              textAlign: pw.TextAlign.left,
                              style: const pw.TextStyle(
                                fontSize: 8,

                                color: PdfColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 7),
                    pw.BarcodeWidget(
                      color: PdfColors.black,
                      barcode: pw.Barcode.qrCode(),
                      width: 80,
                      height: 80,
                      data:
                          "${grnQrData.trnid}${grnQrData.inventoryItemId}\n${grnQrData.itemName}\n${grnQrData.subInv}\n${grnQrData.locatorDesc}\n",
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

  static Future<Uint8List> createSmplQr(SampleColQr sampleColQr) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.standard.copyWith(
          height: 2.6 * PdfPageFormat.cm,
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
                            left: pw.BorderSide(color: PdfColors.grey),
                            right: pw.BorderSide(color: PdfColors.grey),
                            top: pw.BorderSide(color: PdfColors.grey),
                            bottom: pw.BorderSide(color: PdfColors.grey),
                          ),
                          color: PdfColors.white,
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Flexible(
                                  child: buildQrDetails(
                                    lable: "ItemName",
                                    value:
                                        "${sampleColQr.itemCode}-${sampleColQr.itemName}",
                                  ),
                                ),
                                pw.Flexible(
                                  child: buildQrDetails(
                                    lable: "Cust",
                                    value:
                                        "${sampleColQr.customerCode}-${sampleColQr.customerName}",
                                  ),
                                ),
                              ],
                            ),
                            pw.Divider(
                              color: PdfColors.grey400,
                              height: 5,
                              indent: 0,
                              endIndent: 0,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Expanded(
                                  child: pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        "Rcv Id#: ",
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColors.black,
                                        ),
                                      ),
                                      pw.Expanded(
                                        child: pw.Text(
                                          sampleColQr.headerId.toString(),
                                          textAlign: pw.TextAlign.left,
                                          style: const pw.TextStyle(
                                            fontSize: 8,
                                            color: PdfColors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        "Qty: ",
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColors.black,
                                        ),
                                      ),
                                      pw.Expanded(
                                        child: pw.Text(
                                          sampleColQr.qty.toString(),
                                          textAlign: pw.TextAlign.left,
                                          style: const pw.TextStyle(
                                            fontSize: 8,
                                            color: PdfColors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 7),
                    pw.BarcodeWidget(
                      color: PdfColors.black,
                      barcode: pw.Barcode.qrCode(),
                      width: 60,
                      height: 60,
                      data:
                          "${sampleColQr.itemCode}-${sampleColQr.itemName}\n${sampleColQr.qty}\n${sampleColQr.unit}\n${sampleColQr.id}\nhttps://ego.rflgroupbd.com:8077/ords/r/rpro/smartqr/sample-design-report-for-qr?P116_HEADER_ID=${sampleColQr.headerId}",
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
      pw.Flexible(
        flex: 2,
        child: pw.Text(
          value,
          textAlign: pw.TextAlign.left,
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.black),
        ),
      ),
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
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.black),
        ),
      ),
      pw.Flexible(
        flex: 2,
        child: pw.Text(
          value,
          textAlign: pw.TextAlign.right,
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.black),
        ),
      ),
    ],
  );
}
