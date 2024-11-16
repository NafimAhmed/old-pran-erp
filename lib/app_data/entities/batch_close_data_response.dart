import 'dart:convert';

class BatchCloseDataResponse {
  final int? statusCode;
  final String? message;
  final List<BatchCloseData>? iotTrnData;

  BatchCloseDataResponse({
    this.statusCode,
    this.message,
    this.iotTrnData,
  });

  BatchCloseDataResponse copyWith({
    int? statusCode,
    String? message,
    List<BatchCloseData>? iotTrnData,
  }) =>
      BatchCloseDataResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        iotTrnData: iotTrnData ?? this.iotTrnData,
      );

  factory BatchCloseDataResponse.fromJson(String str) =>
      BatchCloseDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchCloseDataResponse.fromMap(Map<String, dynamic> json) =>
      BatchCloseDataResponse(
        statusCode: json["status_code"],
        message: json["message"],
        iotTrnData: json["Batch_Close_data"] == null
            ? []
            : List<BatchCloseData>.from(json["Batch_Close_data"]!
                .map((x) => BatchCloseData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "Batch_Close_data": iotTrnData == null
            ? []
            : List<dynamic>.from(iotTrnData!.map((x) => x.toMap())),
      };
}

class BatchCloseData {
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

  BatchCloseData({
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

  BatchCloseData copyWith({
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
      BatchCloseData(
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

  factory BatchCloseData.fromJson(String str) =>
      BatchCloseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchCloseData.fromMap(Map<String, dynamic> json) => BatchCloseData(
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
