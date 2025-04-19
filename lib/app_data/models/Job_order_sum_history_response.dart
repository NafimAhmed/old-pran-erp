import 'dart:convert';

class JobOrderSumHistoryResponse {
  final int? statusCode;
  final String? message;
  final List<JobOrderData>? jobLocatorInfo;

  JobOrderSumHistoryResponse({
    this.statusCode,
    this.message,
    this.jobLocatorInfo,
  });

  JobOrderSumHistoryResponse copyWith({
    int? statusCode,
    String? message,
    List<JobOrderData>? jobLocatorInfo,
  }) =>
      JobOrderSumHistoryResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        jobLocatorInfo: jobLocatorInfo ?? this.jobLocatorInfo,
      );

  factory JobOrderSumHistoryResponse.fromJson(String str) =>
      JobOrderSumHistoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobOrderSumHistoryResponse.fromMap(Map<String, dynamic> json) =>
      JobOrderSumHistoryResponse(
        statusCode: json["status_code"],
        message: json["message"],
        jobLocatorInfo: json["job_locator_info"] == null
            ? []
            : List<JobOrderData>.from(
                json["job_locator_info"]!.map((x) => JobOrderData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "job_locator_info": jobLocatorInfo == null
            ? []
            : List<dynamic>.from(jobLocatorInfo!.map((x) => x.toMap())),
      };
}

class JobOrderData {
  final String? jobOrderNo;
  final String? itemName;
  final num? fpoQty;
  final num? madeQty;
  final num? transferedQty;
  final num? intQty;
  final num? onhandQty;
  final String? locLocator;

  JobOrderData({
    this.jobOrderNo,
    this.itemName,
    this.fpoQty,
    this.madeQty,
    this.transferedQty,
    this.intQty,
    this.onhandQty,
    this.locLocator,
  });

  JobOrderData copyWith({
    String? jobOrderNo,
    String? itemName,
    num? fpoQty,
    num? madeQty,
    num? transferedQty,
    num? intQty,
    num? onhandQty,
    String? locLocator,
  }) =>
      JobOrderData(
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        itemName: itemName ?? this.itemName,
        fpoQty: fpoQty ?? this.fpoQty,
        madeQty: madeQty ?? this.madeQty,
        transferedQty: transferedQty ?? this.transferedQty,
        intQty: intQty ?? this.intQty,
        onhandQty: onhandQty ?? this.onhandQty,
        locLocator: locLocator ?? this.locLocator,
      );

  factory JobOrderData.fromJson(String str) =>
      JobOrderData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobOrderData.fromMap(Map<String, dynamic> json) => JobOrderData(
        jobOrderNo: json["JOB_ORDER_NO"],
        itemName: json["ITEM_NAME"],
        fpoQty: json["FPO_QTY"],
        madeQty: json["MADE_QTY"],
        transferedQty: json["TRANSFERED_QTY"],
        intQty: json["INT_QTY"],
        onhandQty: json["ONHAND_QTY"],
        locLocator: json["LOT_LOCATOR"],
      );

  Map<String, dynamic> toMap() => {
        "JOB_ORDER_NO": jobOrderNo,
        "ITEM_NAME": itemName,
        "FPO_QTY": fpoQty,
        "MADE_QTY": madeQty,
        "TRANSFERED_QTY": transferedQty,
        "INT_QTY": intQty,
        "ONHAND_QTY": onhandQty,
        "LOT_LOCATOR": locLocator,
      };

  Map<String, dynamic> toTabMap() => {
        "Job Order No": jobOrderNo,
        "Item Name": itemName,
        "Lot Locator": locLocator,
        "FPO Qty": fpoQty,
        "Made Qty": madeQty,
        "Int Qty": intQty,
        "Transfered Qty": transferedQty,
        "OnHand Qty": onhandQty,
      };
}
