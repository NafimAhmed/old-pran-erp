import 'dart:convert';

class GrnQrListResponse {
  final int? statusCode;
  final String? message;
  final List<GrnQr>? grnQrList;

  GrnQrListResponse({
    this.statusCode,
    this.message,
    this.grnQrList,
  });

  GrnQrListResponse copyWith({
    int? statusCode,
    String? message,
    List<GrnQr>? grnQrList,
  }) =>
      GrnQrListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        grnQrList: grnQrList ?? this.grnQrList,
      );

  factory GrnQrListResponse.fromJson(String str) =>
      GrnQrListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnQrListResponse.fromMap(Map<String, dynamic> json) =>
      GrnQrListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        grnQrList: json["GRN_QR_List"] == null
            ? []
            : List<GrnQr>.from(
                json["GRN_QR_List"]!.map((x) => GrnQr.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "GRN_QR_List": grnQrList == null
            ? []
            : List<dynamic>.from(grnQrList!.map((x) => x.toMap())),
      };
}

class GrnQr {
  final int? orgId;
  final String? organizationCode;
  final String? organizationName;
  final String? itemName;
  final int? inventoryItemId;
  final String? batchId;
  final String? jobOrderNo;
  final String? trnId;

  GrnQr({
    this.orgId,
    this.organizationCode,
    this.organizationName,
    this.itemName,
    this.inventoryItemId,
    this.batchId,
    this.jobOrderNo,
    this.trnId,
  });

  GrnQr copyWith({
    int? orgId,
    String? organizationCode,
    String? organizationName,
    String? itemName,
    int? inventoryItemId,
    String? batchId,
    String? jobOrderNo,
    String? trnId,
  }) =>
      GrnQr(
        orgId: orgId ?? this.orgId,
        organizationCode: organizationCode ?? this.organizationCode,
        organizationName: organizationName ?? this.organizationName,
        itemName: itemName ?? this.itemName,
        inventoryItemId: inventoryItemId ?? this.inventoryItemId,
        batchId: batchId ?? this.batchId,
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        trnId: trnId ?? this.trnId,
      );

  factory GrnQr.fromJson(String str) => GrnQr.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnQr.fromMap(Map<String, dynamic> json) => GrnQr(
      orgId: json["ORG_ID"],
      itemName: json["Item_Name"],
      organizationCode: json["ORGANIZATION_CODE"],
      organizationName: json["ORGANIZATION_NAME"],
      inventoryItemId: json["INVENTORY_ITEM_ID"],
      batchId: json["BATCH_ID"],
      jobOrderNo: json["JOB_ORDER_NO"],
      trnId: json["TRNID"]);

  Map<String, dynamic> toMap() => {
        "ORG_ID": orgId,
        "ITEM_NAME": itemName,
        "ORGANIZATION_CODE": organizationCode,
        "ORGANIZATION_NAME": organizationName,
        "INVENTORY_ITEM_ID": inventoryItemId,
        "BATCH_ID": batchId,
        "JOB_ORDER_NO": jobOrderNo,
        "TRNID": trnId,
      };
}
