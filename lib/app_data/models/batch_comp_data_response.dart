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
  final String? organizationCode;
  final String? itemCode;
  final String? itemName;
  final num? madeQty;
  final num? batchQty;
  BatchCompData({
    this.batchNo,
    this.batchId,
    this.organizationCode,
    this.itemCode,
    this.itemName,
    this.madeQty,
    this.batchQty,
  });

  BatchCompData copyWith({
    String? batchNo,
    int? batchId,
    String? organizationCode,
    String? itemCode,
    String? itemName,
    num? madeQty,
    num? batchQty,
  }) =>
      BatchCompData(
        batchNo: batchNo ?? this.batchNo,
        batchId: batchId ?? this.batchId,
        organizationCode: organizationCode ?? this.organizationCode,
        itemCode: itemCode ?? this.itemCode,
        itemName: itemName ?? this.itemName,
        madeQty: madeQty ?? this.madeQty,
        batchQty: batchQty ?? this.batchQty,
      );

  factory BatchCompData.fromJson(String str) =>
      BatchCompData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchCompData.fromMap(Map<String, dynamic> json) => BatchCompData(
        batchNo: json["BATCH_NO"],
        batchId: json["BATCH_ID"],
        organizationCode: json["ORGANIZATION_CODE"],
        itemCode: json["ITEM_CODE"],
        itemName: json["item_name"],
        madeQty: json["made_qty"],
        batchQty: json["batch_qty"],
      );

  Map<String, dynamic> toMap() => {
        "BATCH_NO": batchNo,
        "BATCH_ID": batchId,
        "ORGANIZATION_CODE": organizationCode,
        "ITEM_CODE": itemCode,
        "item_name": itemName,
        "made_qty": madeQty,
        "batch_qty": batchQty
      };
}
