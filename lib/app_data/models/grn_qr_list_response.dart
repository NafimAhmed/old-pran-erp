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
  final int? orgId;
  final String? organizationCode;
  final String? organizationName;
  final String? itemName;
  final String? itemCode;
  final int? inventoryItemId;
  final String? subInv;
  final int? locatorId;
  final String? locatorDesc;
  final String? trnid;
  final num? qty;

  GrnQr({
    this.orgId,
    this.organizationCode,
    this.organizationName,
    this.itemName,
    this.itemCode,
    this.inventoryItemId,
    this.subInv,
    this.locatorId,
    this.locatorDesc,
    this.trnid,
    this.qty,
  });

  GrnQr copyWith({
    int? orgId,
    String? organizationCode,
    String? organizationName,
    String? itemName,
    String? itemCode,
    int? inventoryItemId,
    String? subInv,
    int? locatorId,
    String? locatorDesc,
    String? trnid,
    num? qty,
  }) => GrnQr(
    orgId: orgId ?? this.orgId,
    organizationCode: organizationCode ?? this.organizationCode,
    organizationName: organizationName ?? this.organizationName,
    itemName: itemName ?? this.itemName,
    itemCode: itemCode ?? this.itemCode,
    inventoryItemId: inventoryItemId ?? this.inventoryItemId,
    subInv: subInv ?? this.subInv,
    locatorId: locatorId ?? this.locatorId,
    locatorDesc: locatorDesc ?? this.locatorDesc,
    trnid: trnid ?? this.trnid,
    qty: qty ?? this.qty,
  );

  factory GrnQr.fromJson(String str) => GrnQr.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnQr.fromMap(Map<String, dynamic> json) => GrnQr(
    orgId: json["ORG_ID"],
    organizationCode: json["ORGANIZATION_CODE"],
    organizationName: json["ORGANIZATION_NAME"],
    itemName: json["Item_Name"],
    itemCode: json["Item_code"],
    inventoryItemId: json["INVENTORY_ITEM_ID"],
    subInv: json["SUB_INV"],
    locatorId: json["locator_Id"],
    locatorDesc: json["Locator_desc"],
    trnid: json["TRNID"],
    qty: json["qty"],
  );

  Map<String, dynamic> toMap() => {
    "ORG_ID": orgId,
    "ORGANIZATION_CODE": organizationCode,
    "ORGANIZATION_NAME": organizationName,
    "Item_Name": itemName,
    "Item_code": itemCode,
    "INVENTORY_ITEM_ID": inventoryItemId,
    "SUB_INV": subInv,
    "locator_Id": locatorId,
    "Locator_desc": locatorDesc,
    "TRNID": trnid,
    "qty": qty,
  };
}
