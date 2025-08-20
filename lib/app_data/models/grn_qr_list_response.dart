import 'dart:convert';

class GrnQrListResponse {
  final int? statusCode;
  final String? message;
  final String? errmsg;
  final List<GrnQr>? grnQr;

  GrnQrListResponse({this.statusCode, this.message, this.errmsg, this.grnQr});

  GrnQrListResponse copyWith({
    int? statusCode,
    String? message,
    String? errmsg,
    List<GrnQr>? grnQr,
  }) => GrnQrListResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    errmsg: errmsg ?? this.errmsg,
    grnQr: grnQr ?? this.grnQr,
  );

  factory GrnQrListResponse.fromJson(String str) =>
      GrnQrListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnQrListResponse.fromMap(Map<String, dynamic> json) =>
      GrnQrListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errmsg: json["errmsg"],
        grnQr: json["GRN_QR"] == null
            ? []
            : List<GrnQr>.from(json["GRN_QR"]!.map((x) => GrnQr.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "errmsg": errmsg,
    "GRN_QR": grnQr == null
        ? []
        : List<dynamic>.from(grnQr!.map((x) => x.toMap())),
  };
}

class GrnQr {
  final int? organizationId;
  final String? organizationCode;
  final String? organizationName;
  final String? itemName;
  final String? itemCode;
  final int? inventoryItemId;
  final String? subInventoryCode;
  final int? locatorId;
  final String? locatorDesc;
  final String? lotNumber;
  final num? qty;
  final String? qrType;
  final String? jobOrderNo;
  GrnQr({
    this.organizationId,
    this.organizationCode,
    this.organizationName,
    this.itemName,
    this.itemCode,
    this.inventoryItemId,
    this.subInventoryCode,
    this.locatorId,
    this.locatorDesc,
    this.lotNumber,
    this.qty,
    this.qrType,
    this.jobOrderNo,
  });

  GrnQr copyWith({
    int? organizationId,
    String? organizationCode,
    String? organizationName,
    String? itemName,
    String? itemCode,
    int? inventoryItemId,
    String? subInventoryCode,
    int? locatorId,
    String? locatorDesc,
    String? lotNumber,
    num? qty,
    String? qrType,
    String? jobOrderNo,
  }) => GrnQr(
    organizationId: organizationId ?? this.organizationId,
    organizationCode: organizationCode ?? this.organizationCode,
    organizationName: organizationName ?? this.organizationName,
    itemName: itemName ?? this.itemName,
    itemCode: itemCode ?? this.itemCode,
    inventoryItemId: inventoryItemId ?? this.inventoryItemId,
    subInventoryCode: subInventoryCode ?? this.subInventoryCode,
    locatorId: locatorId ?? this.locatorId,
    locatorDesc: locatorDesc ?? this.locatorDesc,
    lotNumber: lotNumber ?? this.lotNumber,
    qty: qty ?? this.qty,
    qrType: qrType ?? this.qrType,
    jobOrderNo: jobOrderNo ?? this.jobOrderNo,
  );

  factory GrnQr.fromJson(String str) => GrnQr.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnQr.fromMap(Map<String, dynamic> json) => GrnQr(
    organizationId: json["ORGANIZATION_ID"],
    organizationCode: json["ORGANIZATION_CODE"],
    organizationName: json["ORGANIZATION_NAME"],
    itemName: json["Item_Name"],
    itemCode: json["Item_code"],
    inventoryItemId: json["INVENTORY_ITEM_ID"],
    subInventoryCode: json["SUBINVENTORY_CODE"],
    locatorId: json["locator_Id"],
    locatorDesc: json["Locator_desc"],
    lotNumber: json["LOT_NUMBER"],
    qty: json["qty"],
    qrType: json["QR_TYPE"],
    jobOrderNo: json["JOB_ORDER_NO"],
  );

  Map<String, dynamic> toMap() => {
    "ORG_ID": organizationId,
    "ORGANIZATION_CODE": organizationCode,
    "ORGANIZATION_NAME": organizationName,
    "Item_Name": itemName,
    "Item_code": itemCode,
    "INVENTORY_ITEM_ID": inventoryItemId,
    "SUBINVENTORY_CODE": subInventoryCode,
    "locator_Id": locatorId,
    "Locator_desc": locatorDesc,
    "LOT_NUMBER": lotNumber,
    "qty": qty,
    "QR_TYPE": qrType,
    "JOB_ORDER_NO": jobOrderNo,
  };
}
