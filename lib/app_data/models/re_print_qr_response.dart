import 'dart:convert';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';

class RePrintQrResponse {
  final int? statusCode;
  final String? message;
  final List<RqrData>? rqrData;

  RePrintQrResponse({
    this.statusCode,
    this.message,
    this.rqrData,
  });

  RePrintQrResponse copyWith({
    int? statusCode,
    String? message,
    List<RqrData>? rqrData,
  }) =>
      RePrintQrResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        rqrData: rqrData ?? this.rqrData,
      );

  factory RePrintQrResponse.fromJson(String str) =>
      RePrintQrResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RePrintQrResponse.fromMap(Map<String, dynamic> json) =>
      RePrintQrResponse(
        statusCode: json["status_code"],
        message: json["message"],
        rqrData: json["rqr_data"] == null
            ? []
            : List<RqrData>.from(
                json["rqr_data"]!.map((x) => RqrData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "rqr_data": rqrData == null
            ? []
            : List<dynamic>.from(rqrData!.map((x) => x.toMap())),
      };
}

class RqrData {
  final String? lotNo;
  final String? batchNo;
  final String? itemName;
  final String? orgCode;
  final String? customerName;
  final String? subInv;
  final int? madeQty;
  final String? makeDate;
  final int? madeBy;
  final String? userName;
  final String? jobOrderNo;
  final String? deliveryDate;

  RqrData({
    this.lotNo,
    this.batchNo,
    this.itemName,
    this.orgCode,
    this.customerName,
    this.subInv,
    this.madeQty,
    this.makeDate,
    this.madeBy,
    this.userName,
    this.jobOrderNo,
    this.deliveryDate,
  });

  RqrData copyWith({
    String? lotNo,
    String? batchNo,
    String? itemName,
    String? orgCode,
    String? customerName,
    String? subInv,
    int? madeQty,
    String? makeDate,
    int? madeBy,
    String? userName,
    String? jobOrderNo,
    String? deliveryDate,
  }) =>
      RqrData(
        lotNo: lotNo ?? this.lotNo,
        batchNo: batchNo ?? this.batchNo,
        itemName: itemName ?? this.itemName,
        orgCode: orgCode ?? this.orgCode,
        customerName: customerName ?? this.customerName,
        subInv: subInv ?? this.subInv,
        madeQty: madeQty ?? this.madeQty,
        makeDate: makeDate ?? this.makeDate,
        madeBy: madeBy ?? this.madeBy,
        userName: userName ?? this.userName,
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        deliveryDate: deliveryDate ?? this.deliveryDate,
      );

  factory RqrData.fromJson(String str) => RqrData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RqrData.fromMap(Map<String, dynamic> json) => RqrData(
        lotNo: json["lot_no"],
        batchNo: json["batch_no"],
        itemName: json["ITEM_NAME"],
        orgCode: json["ORG_CODE"],
        customerName: json["CUSTOMER_NAME"],
        subInv: json["SUB_INV"],
        madeQty: json["MADE_QTY"],
        makeDate: json["MAKE_DATE"],
        madeBy: json["MADE_BY"],
        userName: json["USER_NAME"],
        jobOrderNo: json["JOB_ORDER_NO"],
        deliveryDate: json["DELIVERY_DATE"],
      );

  Map<String, dynamic> toMap() => {
        "lot_no": lotNo,
        "batch_no": batchNo,
        "ITEM_NAME": itemName,
        "ORG_CODE": orgCode,
        "CUSTOMER_NAME": customerName,
        "SUB_INV": subInv,
        "MADE_QTY": madeQty,
        "MAKE_DATE": makeDate,
        "MADE_BY": madeBy,
        "USER_NAME": userName,
        "JOB_ORDER_NO": jobOrderNo,
        "DELIVERY_DATE": deliveryDate,
      };
  Map<String, dynamic> toUiMap() => {
        "Item Name": itemName,
        "Lot No": lotNo,
        "Job Order No": jobOrderNo,
        "Batch No": batchNo,
        "Sub Inv": subInv,
        "Made Qt": madeQty,
        "Make Date":
            DateTime.parse(makeDate ?? "").toFormatedString("dd-MM-yyyy"),
        "Made By": "$madeBy-$userName",
      };
}
