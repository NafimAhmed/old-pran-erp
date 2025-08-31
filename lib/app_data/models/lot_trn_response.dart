import 'dart:convert';

class LotTrnResponse {
  final int? statusCode;
  final String? message;
  final List<LotTrnData>? lotTrnData;

  LotTrnResponse({this.statusCode, this.message, this.lotTrnData});

  LotTrnResponse copyWith({
    int? statusCode,
    String? message,
    List<LotTrnData>? lotTrnData,
  }) => LotTrnResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    lotTrnData: lotTrnData ?? this.lotTrnData,
  );

  factory LotTrnResponse.fromJson(String str) =>
      LotTrnResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LotTrnResponse.fromMap(Map<String, dynamic> json) => LotTrnResponse(
    statusCode: json["status_code"],
    message: json["message"],
    lotTrnData: json["lot_trn_data"] == null
        ? []
        : List<LotTrnData>.from(
            json["lot_trn_data"]!.map((x) => LotTrnData.fromMap(x)),
          ),
  );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "lot_trn_data": lotTrnData == null
        ? []
        : List<dynamic>.from(lotTrnData!.map((x) => x.toMap())),
  };
}

class LotTrnData {
  final String? batchNo;
  final int? trnid;
  final String? itemCode;
  final String? itemName;
  final String? lotno;
  final num? rackQty;
  final String? subinventory;
  final int? rackLocatorId;
  final String? joborder;
  final String? racklocator;
  final String? batchStatus;
  final int? orgId;
  final int? invItemId;

  LotTrnData({
    this.batchNo,
    this.trnid,
    this.itemCode,
    this.itemName,
    this.lotno,
    this.rackQty,
    this.subinventory,
    this.rackLocatorId,
    this.joborder,
    this.racklocator,
    this.batchStatus,
    this.orgId,
    this.invItemId,
  });

  LotTrnData copyWith({
    String? batchNo,
    int? trnid,
    String? itemCode,
    String? itemName,
    String? lotno,
    int? rackQty,
    String? subinventory,
    int? rackLocatorId,
    String? joborder,
    String? racklocator,
    String? batchStatus,
    int? orgId,
    int? invItemId,
  }) => LotTrnData(
    batchNo: batchNo ?? this.batchNo,
    trnid: trnid ?? this.trnid,
    itemCode: itemCode ?? this.itemCode,
    itemName: itemName ?? this.itemName,
    lotno: lotno ?? this.lotno,
    rackQty: rackQty ?? this.rackQty,
    subinventory: subinventory ?? this.subinventory,
    rackLocatorId: rackLocatorId ?? this.rackLocatorId,
    joborder: joborder ?? this.joborder,
    racklocator: racklocator ?? this.racklocator,
    batchStatus: batchStatus ?? this.batchStatus,
    orgId: orgId ?? this.orgId,
    invItemId: invItemId ?? this.invItemId,
  );

  factory LotTrnData.fromJson(String str) =>
      LotTrnData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LotTrnData.fromMap(Map<String, dynamic> json) => LotTrnData(
    batchNo: json["BATCH_NO"],
    trnid: json["TRNID"],
    itemCode: json["ITEM_CODE"],
    itemName: json["ITEM_NAME"],
    lotno: json["LOTNO"],
    rackQty: json["RACK_QTY"],
    subinventory: json["SUBINVENTORY"],
    rackLocatorId: json["RACK_LOCATOR_ID"],
    joborder: json["JOBORDER"],
    racklocator: json["RACKLOCATOR"],
    batchStatus: json["BATCH_STATUS"],
    orgId: json["ORGANIZATION_ID"],
    invItemId: json["INVENTORY_ITEM_ID"],
  );

  Map<String, dynamic> toMap() => {
    "BATCH_NO": batchNo,
    "TRNID": trnid,
    "ITEM_CODE": itemCode,
    "ITEM_NAME": itemName,
    "LOTNO": lotno,
    "RACK_QTY": rackQty,
    "SUBINVENTORY": subinventory,
    "RACK_LOCATOR_ID": rackLocatorId,
    "JOBORDER": joborder,
    "RACKLOCATOR": racklocator,
    "BATCH_STATUS": batchStatus,
    "ORGANIZATION_ID": orgId,
    "INVENTORY_ITEM_ID": invItemId,
  };
}
