import 'dart:convert';

class BatchQrDataResponse {
  final int? statusCode;
  final String? message;
  final String? errorMessage;
  final List<BatchQrData>? batchQrData;

  BatchQrDataResponse({
    this.statusCode,
    this.message,
    this.errorMessage,
    this.batchQrData,
  });

  BatchQrDataResponse copyWith({
    int? statusCode,
    String? message,
    String? errorMessage,
    List<BatchQrData>? batchQrData,
  }) =>
      BatchQrDataResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errorMessage: errorMessage ?? this.errorMessage,
        batchQrData: batchQrData ?? this.batchQrData,
      );

  factory BatchQrDataResponse.fromJson(String str) =>
      BatchQrDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchQrDataResponse.fromMap(Map<String, dynamic> json) =>
      BatchQrDataResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errorMessage: json["error_message"],
        batchQrData: json["batch_qr_data"] == null
            ? []
            : List<BatchQrData>.from(
                json["batch_qr_data"]!.map((x) => BatchQrData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "error_message": errorMessage,
        "batch_qr_data": batchQrData == null
            ? []
            : List<dynamic>.from(batchQrData!.map((x) => x.toMap())),
      };
}

class BatchQrData {
  final int? orgId;
  final int? inventoryItemId;
  final int? batchId;
  final int? locatorId;
  final num? goodQty;
  final String? jobOrderNo;
  final String? createdDate;
  final String? locLocator;

  BatchQrData({
    this.orgId,
    this.inventoryItemId,
    this.batchId,
    this.locatorId,
    this.goodQty,
    this.jobOrderNo,
    this.createdDate,
    this.locLocator,
  });

  BatchQrData copyWith({
    int? orgId,
    int? inventoryItemId,
    int? batchId,
    int? locatorId,
    num? goodQty,
    String? jobOrderNo,
    String? createdDate,
    String? locLocator,
  }) =>
      BatchQrData(
        orgId: orgId ?? this.orgId,
        inventoryItemId: inventoryItemId ?? this.inventoryItemId,
        batchId: batchId ?? this.batchId,
        locatorId: locatorId ?? this.locatorId,
        goodQty: goodQty ?? this.goodQty,
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        createdDate: createdDate ?? this.createdDate,
        locLocator: locLocator ?? this.locLocator,
      );

  factory BatchQrData.fromJson(String str) =>
      BatchQrData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchQrData.fromMap(Map<String, dynamic> json) => BatchQrData(
        orgId: json["ORG_ID"],
        inventoryItemId: json["INVENTORY_ITEM_ID"],
        batchId: json["BATCH_ID"],
        locatorId: json["LOCATOR_ID"],
        goodQty: json["GOOD_QTY"],
        jobOrderNo: json["JOB_ORDER_NO"],
        createdDate: json["CREATED_DATE"],
        locLocator: json["LOC_LOCATOR"],
      );

  Map<String, dynamic> toMap() => {
        "ORG_ID": orgId,
        "INVENTORY_ITEM_ID": inventoryItemId,
        "BATCH_ID": batchId,
        "LOCATOR_ID": locatorId,
        "GOOD_QTY": goodQty,
        "JOB_ORDER_NO": jobOrderNo,
        "CREATED_DATE": createdDate,
        "LOC_LOCATOR": locLocator,
      };
}
