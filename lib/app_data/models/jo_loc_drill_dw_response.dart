import 'dart:convert';

class JoLocDrillDwResponse {
  final int? statusCode;
  final String? message;
  final List<JobLocatorInfo>? jobLocatorInfo;

  JoLocDrillDwResponse({
    this.statusCode,
    this.message,
    this.jobLocatorInfo,
  });

  JoLocDrillDwResponse copyWith({
    int? statusCode,
    String? message,
    List<JobLocatorInfo>? jobLocatorInfo,
  }) =>
      JoLocDrillDwResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        jobLocatorInfo: jobLocatorInfo ?? this.jobLocatorInfo,
      );

  factory JoLocDrillDwResponse.fromJson(String str) =>
      JoLocDrillDwResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JoLocDrillDwResponse.fromMap(Map<String, dynamic> json) =>
      JoLocDrillDwResponse(
        statusCode: json["status_code"],
        message: json["message"],
        jobLocatorInfo: json["job_locator_info"] == null
            ? []
            : List<JobLocatorInfo>.from(json["job_locator_info"]!
                .map((x) => JobLocatorInfo.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "job_locator_info": jobLocatorInfo == null
            ? []
            : List<dynamic>.from(jobLocatorInfo!.map((x) => x.toMap())),
      };
}

class JobLocatorInfo {
  final String? jobOrderNo;
  final String? itemName;
  final int? fpoQty;
  final int? madeQty;
  final int? transferedQty;
  final int? intQty;
  final int? onhandQty;
  final String? lotLocator;

  JobLocatorInfo({
    this.jobOrderNo,
    this.itemName,
    this.fpoQty,
    this.madeQty,
    this.transferedQty,
    this.intQty,
    this.onhandQty,
    this.lotLocator,
  });

  JobLocatorInfo copyWith({
    String? jobOrderNo,
    String? itemName,
    int? fpoQty,
    int? madeQty,
    int? transferedQty,
    int? intQty,
    int? onhandQty,
    String? lotLocator,
  }) =>
      JobLocatorInfo(
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        itemName: itemName ?? this.itemName,
        fpoQty: fpoQty ?? this.fpoQty,
        madeQty: madeQty ?? this.madeQty,
        transferedQty: transferedQty ?? this.transferedQty,
        intQty: intQty ?? this.intQty,
        onhandQty: onhandQty ?? this.onhandQty,
        lotLocator: lotLocator ?? this.lotLocator,
      );

  factory JobLocatorInfo.fromJson(String str) =>
      JobLocatorInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobLocatorInfo.fromMap(Map<String, dynamic> json) => JobLocatorInfo(
        jobOrderNo: json["JOB_ORDER_NO"],
        itemName: json["ITEM_NAME"],
        fpoQty: json["FPO_QTY"],
        madeQty: json["MADE_QTY"],
        transferedQty: json["TRANSFERED_QTY"],
        intQty: json["INT_QTY"],
        onhandQty: json["ONHAND_QTY"],
        lotLocator: json["LOT_LOCATOR"],
      );

  Map<String, dynamic> toMap() => {
        "JOB_ORDER_NO": jobOrderNo,
        "ITEM_NAME": itemName,
        "FPO_QTY": fpoQty,
        "MADE_QTY": madeQty,
        "TRANSFERED_QTY": transferedQty,
        "INT_QTY": intQty,
        "ONHAND_QTY": onhandQty,
        "LOT_LOCATOR": lotLocator,
      };
  Map<String, dynamic> toTabMap() => {
        // "Job Order No": jobOrderNo,
        // "Item Name": itemName,
        // "FPO Qty": fpoQty,
        // "Made Qty": madeQty,
        // "Transfer Qty": transferedQty,
        // "Int Qty": intQty,
        "Lot Locator": lotLocator,
        "OnHand Qty": onhandQty,
      };
}
