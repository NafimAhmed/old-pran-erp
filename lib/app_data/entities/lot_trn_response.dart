import 'dart:convert';

class LotTrnResponse {
  final int? statusCode;
  final String? message;
  final List<LotTrnData>? lotTrnData;

  LotTrnResponse({
    this.statusCode,
    this.message,
    this.lotTrnData,
  });

  LotTrnResponse copyWith({
    int? statusCode,
    String? message,
    List<LotTrnData>? lotTrnData,
  }) =>
      LotTrnResponse(
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
                json["lot_trn_data"]!.map((x) => LotTrnData.fromMap(x))),
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
  final int? itemName;
  final String? lotno;
  final int? rackQty;
  final int? subinventory;
  final String? rackLocatorId;
  final int? joborder;
  final int? racklocator;

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
  });

  LotTrnData copyWith({
    String? batchNo,
    int? trnid,
    String? itemCode,
    int? itemName,
    String? lotno,
    int? rackQty,
    int? subinventory,
    String? rackLocatorId,
    int? joborder,
    int? racklocator,
  }) =>
      LotTrnData(
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
      };
  Map<String, dynamic> toTabMap() => {
        "Batch No": batchNo,
        "TenId": trnid,
        "Item Code": itemCode,
        "Item Name": itemName,
        "Lot No": lotno,
        "Rack Qty": rackQty,
        "Sub Inventory": subinventory,
        "Rack Loc Id": rackLocatorId,
        "Job Order": joborder,
        "Rack Locator": racklocator,
      };
}
