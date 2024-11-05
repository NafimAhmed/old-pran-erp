import 'dart:convert';

class UserQrPrintResponse {
  final int? statusCode;
  final String? message;
  final List<UserBatchQrData>? userBatchData;

  UserQrPrintResponse({
    this.statusCode,
    this.message,
    this.userBatchData,
  });

  UserQrPrintResponse copyWith({
    int? statusCode,
    String? message,
    List<UserBatchQrData>? userBatchData,
  }) =>
      UserQrPrintResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        userBatchData: userBatchData ?? this.userBatchData,
      );

  factory UserQrPrintResponse.fromJson(String str) =>
      UserQrPrintResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserQrPrintResponse.fromMap(Map<String, dynamic> json) =>
      UserQrPrintResponse(
        statusCode: json["status_code"],
        message: json["message"],
        userBatchData: json["user_batch_data"] == null
            ? []
            : List<UserBatchQrData>.from(json["user_batch_data"]!
                .map((x) => UserBatchQrData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "user_batch_data": userBatchData == null
            ? []
            : List<dynamic>.from(userBatchData!.map((x) => x.toMap())),
      };
}

class UserBatchQrData {
  final String? organizationCode;
  final String? organizationName;
  final String? jobOrderNo;
  final int? trnid;
  final int? batchId;
  final String? batchNo;
  final int? materialDetailId;
  final int? inventoryItemId;
  final String? itemCode;
  final String? itemName;
  final int? originalQty;
  final int? totalQty;
  final String? batchStatus;
  final int? flagStatus;

  UserBatchQrData({
    this.organizationCode,
    this.organizationName,
    this.jobOrderNo,
    this.trnid,
    this.batchId,
    this.batchNo,
    this.materialDetailId,
    this.inventoryItemId,
    this.itemCode,
    this.itemName,
    this.originalQty,
    this.totalQty,
    this.batchStatus,
    this.flagStatus,
  });

  UserBatchQrData copyWith({
    String? organizationCode,
    String? organizationName,
    String? jobOrderNo,
    int? trnid,
    int? batchId,
    String? batchNo,
    int? materialDetailId,
    int? inventoryItemId,
    String? itemCode,
    String? itemName,
    int? originalQty,
    int? totalQty,
    String? batchStatus,
    int? flagStatus,
  }) =>
      UserBatchQrData(
        organizationCode: organizationCode ?? this.organizationCode,
        organizationName: organizationName ?? this.organizationName,
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        trnid: trnid ?? this.trnid,
        batchId: batchId ?? this.batchId,
        batchNo: batchNo ?? this.batchNo,
        materialDetailId: materialDetailId ?? this.materialDetailId,
        inventoryItemId: inventoryItemId ?? this.inventoryItemId,
        itemCode: itemCode ?? this.itemCode,
        itemName: itemName ?? this.itemName,
        originalQty: originalQty ?? this.originalQty,
        totalQty: totalQty ?? this.totalQty,
        batchStatus: batchStatus ?? this.batchStatus,
        flagStatus: flagStatus ?? this.flagStatus,
      );

  factory UserBatchQrData.fromJson(String str) =>
      UserBatchQrData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserBatchQrData.fromMap(Map<String, dynamic> json) => UserBatchQrData(
        organizationCode: json["ORGANIZATION_CODE"],
        organizationName: json["ORGANIZATION_NAME"],
        jobOrderNo: json["JOB_ORDER_NO"],
        trnid: json["TRNID"],
        batchId: json["batch_id"],
        batchNo: json["BATCH_NO"],
        materialDetailId: json["material_detail_id"],
        inventoryItemId: json["inventory_item_id"],
        itemCode: json["ITEM_CODE"],
        itemName: json["ITEM_NAME"],
        originalQty: json["ORIGINAL_QTY"],
        totalQty: json["TOTAL_QTY"],
        batchStatus: json["BATCH_STATUS"],
        flagStatus: json["FLAG_STATUS"],
      );

  Map<String, dynamic> toMap() => {
        "ORGANIZATION_CODE": organizationCode,
        "ORGANIZATION_NAME": organizationName,
        "JOB_ORDER_NO": jobOrderNo,
        "TRNID": trnid,
        "batch_id": batchId,
        "BATCH_NO": batchNo,
        "material_detail_id": materialDetailId,
        "inventory_item_id": inventoryItemId,
        "ITEM_CODE": itemCode,
        "ITEM_NAME": itemName,
        "ORIGINAL_QTY": originalQty,
        "TOTAL_QTY": totalQty,
        "BATCH_STATUS": batchStatus,
        "FLAG_STATUS": flagStatus,
      };
}
