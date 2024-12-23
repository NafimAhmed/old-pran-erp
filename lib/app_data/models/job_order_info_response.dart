import 'dart:convert';

class JobOrderInfoResponse {
  final int? statusCode;
  final String? message;
  final List<JobOrderInfo>? jobOrderInfo;

  JobOrderInfoResponse({
    this.statusCode,
    this.message,
    this.jobOrderInfo,
  });

  JobOrderInfoResponse copyWith({
    int? statusCode,
    String? message,
    List<JobOrderInfo>? jobOrderInfo,
  }) =>
      JobOrderInfoResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        jobOrderInfo: jobOrderInfo ?? this.jobOrderInfo,
      );

  factory JobOrderInfoResponse.fromJson(String str) =>
      JobOrderInfoResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobOrderInfoResponse.fromMap(Map<String, dynamic> json) =>
      JobOrderInfoResponse(
        statusCode: json["status_code"],
        message: json["message"],
        jobOrderInfo: json["job_order_info"] == null
            ? []
            : List<JobOrderInfo>.from(
                json["job_order_info"]!.map((x) => JobOrderInfo.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "job_order_info": jobOrderInfo == null
            ? []
            : List<dynamic>.from(jobOrderInfo!.map((x) => x.toMap())),
      };
}

class JobOrderInfo {
  final String? jobOrderNo;
  final String? item;
  final String? buyerName;
  final int? fpoQty;
  final int? batchQty;
  final int? madeQty;
  final int? dueQty;
  final int? madeP;
  final int? perDayAvgProd;
  final String? inspectionDate;
  final int? possibleDays;
  final int? possibleHours;
  final String? nearDays;
  final int? nearHours;
  final int? salesQty;

  JobOrderInfo({
    this.jobOrderNo,
    this.item,
    this.buyerName,
    this.fpoQty,
    this.batchQty,
    this.madeQty,
    this.dueQty,
    this.madeP,
    this.perDayAvgProd,
    this.inspectionDate,
    this.possibleDays,
    this.possibleHours,
    this.nearDays,
    this.nearHours,
    this.salesQty,
  });

  JobOrderInfo copyWith({
    String? jobOrderNo,
    String? item,
    String? buyerName,
    int? fpoQty,
    int? batchQty,
    int? madeQty,
    int? dueQty,
    int? madeP,
    int? perDayAvgProd,
    String? inspectionDate,
    int? possibleDays,
    int? possibleHours,
    String? nearDays,
    int? nearHours,
    int? salesQty,
  }) =>
      JobOrderInfo(
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        item: item ?? this.item,
        buyerName: buyerName ?? this.buyerName,
        fpoQty: fpoQty ?? this.fpoQty,
        batchQty: batchQty ?? this.batchQty,
        madeQty: madeQty ?? this.madeQty,
        dueQty: dueQty ?? this.dueQty,
        madeP: madeP ?? this.madeP,
        perDayAvgProd: perDayAvgProd ?? this.perDayAvgProd,
        inspectionDate: inspectionDate ?? this.inspectionDate,
        possibleDays: possibleDays ?? this.possibleDays,
        possibleHours: possibleHours ?? this.possibleHours,
        nearDays: nearDays ?? this.nearDays,
        nearHours: nearHours ?? this.nearHours,
        salesQty: salesQty ?? this.salesQty,
      );

  factory JobOrderInfo.fromJson(String str) =>
      JobOrderInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobOrderInfo.fromMap(Map<String, dynamic> json) => JobOrderInfo(
        jobOrderNo: json["job_order_no"],
        item: json["item"],
        buyerName: json["BUYER_NAME"],
        fpoQty: json["FPO_QTY"],
        batchQty: json["BATCH_QTY"],
        madeQty: json["MADE_QTY"],
        dueQty: json["DUE_QTY"],
        madeP: json["MADE_P"],
        perDayAvgProd: json["PER_DAY_AVG_PROD"],
        inspectionDate: json["INSPECTION_DATE"],
        possibleDays: json["POSSIBLE_DAYS"],
        possibleHours: json["POSSIBLE_HOURS"],
        nearDays: json["NEAR_DAYS"],
        nearHours: json["NEAR_HOURS"],
        salesQty: json["sales_qty"],
      );

  Map<String, dynamic> toMap() => {
        "job_order_no": jobOrderNo,
        "item": item,
        "BUYER_NAME": buyerName,
        "FPO_QTY": fpoQty,
        "BATCH_QTY": batchQty,
        "MADE_QTY": madeQty,
        "DUE_QTY": dueQty,
        "MADE_P": madeP,
        "PER_DAY_AVG_PROD": perDayAvgProd,
        "INSPECTION_DATE": inspectionDate,
        "POSSIBLE_DAYS": possibleDays,
        "POSSIBLE_HOURS": possibleHours,
        "NEAR_DAYS": nearDays,
        "NEAR_HOURS": nearHours,
        "sales_qty": salesQty,
      };
  Map<String, dynamic> toTabMap() => {
        "Buyer Name": buyerName,
        "JO/FPO Qty": fpoQty,
        "Batch Qty": batchQty,
        "Due Qty": madeQty,
        "DUE_QTY": dueQty,
        "Sales Qty": salesQty,
        "Per Day Avg Prod": perDayAvgProd,
        "Inspection Date": inspectionDate,
        "Possible Days": possibleDays,
        "Possible Hours": possibleHours,
        "Near Days": nearDays,
        "Near Hours": nearHours,
      };
}
