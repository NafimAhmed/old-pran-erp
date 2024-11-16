import 'dart:convert';

class BatchCompDataResponse {
  final int? statusCode;
  final String? message;
  final List<BatchCompData>? batchCompData;

  BatchCompDataResponse({
    this.statusCode,
    this.message,
    this.batchCompData,
  });

  BatchCompDataResponse copyWith({
    int? statusCode,
    String? message,
    List<BatchCompData>? batchCompData,
  }) =>
      BatchCompDataResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        batchCompData: batchCompData ?? this.batchCompData,
      );

  factory BatchCompDataResponse.fromJson(String str) =>
      BatchCompDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchCompDataResponse.fromMap(Map<String, dynamic> json) =>
      BatchCompDataResponse(
        statusCode: json["status_code"],
        message: json["message"],
        batchCompData: json["Batch_Comp_data"] == null
            ? []
            : List<BatchCompData>.from(
                json["Batch_Comp_data"]!.map((x) => BatchCompData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "Batch_Comp_data": batchCompData == null
            ? []
            : List<dynamic>.from(batchCompData!.map((x) => x.toMap())),
      };
}

class BatchCompData {
  final String? batchNo;
  final int? batchId;
  final String? itemCode;
  final String? itemName;
  final String? lotno;
  final int? trnqty;
  final String? subinventory;
  final int? rackLocatorId;
  final String? joborder;
  final String? racklocator;
  final int? actualQty;

  BatchCompData({
    this.batchNo,
    this.batchId,
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

  BatchCompData copyWith({
    String? batchNo,
    int? batchId,
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
      BatchCompData(
        batchNo: batchNo ?? this.batchNo,
        batchId: batchId ?? this.batchId,
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

  factory BatchCompData.fromJson(String str) =>
      BatchCompData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchCompData.fromMap(Map<String, dynamic> json) => BatchCompData(
        batchNo: json["BATCH_NO"],
        batchId: json["BATCH_ID"],
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
