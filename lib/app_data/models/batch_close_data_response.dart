import 'dart:convert';

class BatchCloseDataResponse {
  final int? statusCode;
  final String? message;
  final List<BatchCloseData>? batchCloseData;

  BatchCloseDataResponse({this.statusCode, this.message, this.batchCloseData});

  BatchCloseDataResponse copyWith({
    int? statusCode,
    String? message,
    List<BatchCloseData>? batchCloseData,
  }) => BatchCloseDataResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    batchCloseData: batchCloseData ?? this.batchCloseData,
  );

  factory BatchCloseDataResponse.fromJson(String str) =>
      BatchCloseDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchCloseDataResponse.fromMap(Map<String, dynamic> json) =>
      BatchCloseDataResponse(
        statusCode: json["status_code"],
        message: json["message"],
        batchCloseData: json["Batch_Close_data"] == null
            ? []
            : List<BatchCloseData>.from(
                json["Batch_Close_data"]!.map((x) => BatchCloseData.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "Batch_Close_data": batchCloseData == null
        ? []
        : List<dynamic>.from(batchCloseData!.map((x) => x.toMap())),
  };
}

class BatchCloseData {
  final String? orgCode;
  final String? batchNo;
  final int? batchId;
  final String? itemCode;
  final String? itemName;
  final num? batchQty;
  final num? madeQty;
  final String? batchStatus;

  BatchCloseData({
    this.orgCode,
    this.batchNo,
    this.batchId,
    this.itemCode,
    this.itemName,
    this.batchQty,
    this.madeQty,
    this.batchStatus,
  });

  BatchCloseData copyWith({
    String? orgCode,
    String? batchNo,
    int? batchId,
    String? itemCode,
    String? itemName,
    int? batchQty,
    int? madeQty,
    String? batchStatus,
  }) => BatchCloseData(
    orgCode: orgCode ?? this.orgCode,
    batchNo: batchNo ?? this.batchNo,
    batchId: batchId ?? this.batchId,
    itemCode: itemCode ?? this.itemCode,
    itemName: itemName ?? this.itemName,
    batchQty: batchQty ?? this.batchQty,
    madeQty: madeQty ?? this.madeQty,
    batchStatus: batchStatus ?? this.batchStatus,
  );

  factory BatchCloseData.fromJson(String str) =>
      BatchCloseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchCloseData.fromMap(Map<String, dynamic> json) => BatchCloseData(
    orgCode: json["ORG_CODE"],
    batchNo: json["BATCH_NO"],
    batchId: json["BATCH_ID"],
    itemCode: json["ITEM_CODE"],
    itemName: json["ITEM_NAME"],
    batchQty: json["BATCH_QTY"],
    madeQty: json["MADE_QTY"],
    batchStatus: json["BATCH_STATUS"],
  );

  Map<String, dynamic> toMap() => {
    "ORG_CODE": orgCode,
    "BATCH_NO": batchNo,
    "BATCH_ID": batchId,
    "ITEM_CODE": itemCode,
    "ITEM_NAME": itemName,
    "BATCH_QTY": batchQty,
    "MADE_QTY": madeQty,
    "BATCH_STATUS": batchStatus,
  };
}
