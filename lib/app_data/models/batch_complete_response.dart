import 'dart:convert';

class BatchCompleteListResponse {
  final int? statusCode;
  final String? message;
  final List<BatchCompData>? batchCompData;

  BatchCompleteListResponse({
    this.statusCode,
    this.message,
    this.batchCompData,
  });

  BatchCompleteListResponse copyWith({
    int? statusCode,
    String? message,
    List<BatchCompData>? batchCloseData,
  }) => BatchCompleteListResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    batchCompData: batchCloseData ?? this.batchCompData,
  );

  factory BatchCompleteListResponse.fromJson(String str) =>
      BatchCompleteListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchCompleteListResponse.fromMap(Map<String, dynamic> json) =>
      BatchCompleteListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        batchCompData: json["Batch_Close_data"] == null
            ? []
            : List<BatchCompData>.from(
                json["Batch_Close_data"]!.map((x) => BatchCompData.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "Batch_Close_data": batchCompData == null
        ? []
        : List<dynamic>.from(batchCompData!.map((x) => x.toMap())),
  };
}

class BatchCompData {
  final String? orgCode;
  final int? organizationId;
  final String? batchNo;
  final int? batchId;
  final String? itemCode;
  final String? itemName;
  final num? batchQty;
  final num? madeQty;
  final String? batchStatus;

  BatchCompData({
    this.orgCode,
    this.organizationId,
    this.batchNo,
    this.batchId,
    this.itemCode,
    this.itemName,
    this.batchQty,
    this.madeQty,
    this.batchStatus,
  });

  BatchCompData copyWith({
    String? orgCode,
    int? organizationId,
    String? batchNo,
    int? batchId,
    String? itemCode,
    String? itemName,
    int? batchQty,
    double? madeQty,
    String? batchStatus,
  }) => BatchCompData(
    orgCode: orgCode ?? this.orgCode,
    organizationId: organizationId ?? this.organizationId,
    batchNo: batchNo ?? this.batchNo,
    batchId: batchId ?? this.batchId,
    itemCode: itemCode ?? this.itemCode,
    itemName: itemName ?? this.itemName,
    batchQty: batchQty ?? this.batchQty,
    madeQty: madeQty ?? this.madeQty,
    batchStatus: batchStatus ?? this.batchStatus,
  );

  factory BatchCompData.fromJson(String str) =>
      BatchCompData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchCompData.fromMap(Map<String, dynamic> json) => BatchCompData(
    orgCode: json["ORG_CODE"],
    organizationId: json["ORGANIZATION_ID"],
    batchNo: json["BATCH_NO"],
    batchId: json["BATCH_ID"],
    itemCode: json["ITEM_CODE"],
    itemName: json["ITEM_NAME"],
    batchQty: json["BATCH_QTY"],
    madeQty: json["MADE_QTY"]?.toDouble(),
    batchStatus: json["BATCH_STATUS"],
  );

  Map<String, dynamic> toMap() => {
    "ORG_CODE": orgCode,
    "ORGANIZATION_ID": organizationId,
    "BATCH_NO": batchNo,
    "BATCH_ID": batchId,
    "ITEM_CODE": itemCode,
    "ITEM_NAME": itemName,
    "BATCH_QTY": batchQty,
    "MADE_QTY": madeQty,
    "BATCH_STATUS": batchStatus,
  };
}
