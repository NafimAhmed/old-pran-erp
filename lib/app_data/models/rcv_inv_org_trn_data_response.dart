import 'dart:convert';

class RcvInvOrgTrnDataResponse {
  final int? statusCode;
  final String? message;
  final List<RcvIotData>? rcvIotData;

  RcvInvOrgTrnDataResponse({
    this.statusCode,
    this.message,
    this.rcvIotData,
  });

  RcvInvOrgTrnDataResponse copyWith({
    int? statusCode,
    String? message,
    List<RcvIotData>? rcvIotData,
  }) =>
      RcvInvOrgTrnDataResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        rcvIotData: rcvIotData ?? this.rcvIotData,
      );

  factory RcvInvOrgTrnDataResponse.fromJson(String str) =>
      RcvInvOrgTrnDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RcvInvOrgTrnDataResponse.fromMap(Map<String, dynamic> json) =>
      RcvInvOrgTrnDataResponse(
        statusCode: json["status_code"],
        message: json["message"],
        rcvIotData: json["Rcv_IOT_data"] == null
            ? []
            : List<RcvIotData>.from(
                json["Rcv_IOT_data"]!.map((x) => RcvIotData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "Rcv_IOT_data": rcvIotData == null
            ? []
            : List<dynamic>.from(rcvIotData!.map((x) => x.toMap())),
      };
}

class RcvIotData {
  final String? batchNo;
  final int? batchId;
  final int? trnid;
  final String? itemCode;
  final String? itemName;
  final String? lotno;
  final num? trnqty;
  final String? subinventory;
  final int? rackLocatorId;
  final String? joborder;
  final String? racklocator;
  final num? actualQty;

  RcvIotData({
    this.batchNo,
    this.batchId,
    this.trnid,
    this.itemCode,
    this.itemName,
    this.lotno,
    this.trnqty,
    this.subinventory,
    this.rackLocatorId,
    this.joborder,
    this.racklocator,
    this.actualQty,
  });

  RcvIotData copyWith({
    String? batchNo,
    int? batchId,
    int? trnid,
    String? itemCode,
    String? itemName,
    String? lotno,
    int? trnqty,
    String? subinventory,
    int? rackLocatorId,
    String? joborder,
    String? racklocator,
    int? actualQty,
  }) =>
      RcvIotData(
        batchNo: batchNo ?? this.batchNo,
        batchId: batchId ?? this.batchId,
        trnid: trnid ?? this.trnid,
        itemCode: itemCode ?? this.itemCode,
        itemName: itemName ?? this.itemName,
        lotno: lotno ?? this.lotno,
        trnqty: trnqty ?? this.trnqty,
        subinventory: subinventory ?? this.subinventory,
        rackLocatorId: rackLocatorId ?? this.rackLocatorId,
        joborder: joborder ?? this.joborder,
        racklocator: racklocator ?? this.racklocator,
        actualQty: actualQty ?? this.actualQty,
      );

  factory RcvIotData.fromJson(String str) =>
      RcvIotData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RcvIotData.fromMap(Map<String, dynamic> json) => RcvIotData(
        batchNo: json["BATCH_NO"],
        batchId: json["BATCH_ID"],
        trnid: json["TRNID"],
        itemCode: json["ITEM_CODE"],
        itemName: json["ITEM_NAME"],
        lotno: json["LOTNO"],
        trnqty: json["TRNQTY"],
        subinventory: json["SUBINVENTORY"],
        rackLocatorId: json["RACK_LOCATOR_ID"],
        joborder: json["JOBORDER"],
        racklocator: json["RACKLOCATOR"],
        actualQty: json["ACTUAL_QTY"],
      );

  Map<String, dynamic> toMap() => {
        "BATCH_NO": batchNo,
        "BATCH_ID": batchId,
        "TRNID": trnid,
        "ITEM_CODE": itemCode,
        "ITEM_NAME": itemName,
        "LOTNO": lotno,
        "TRNQTY": trnqty,
        "SUBINVENTORY": subinventory,
        "RACK_LOCATOR_ID": rackLocatorId,
        "JOBORDER": joborder,
        "RACKLOCATOR": racklocator,
        "ACTUAL_QTY": actualQty,
      };
}
