import 'dart:convert';

class JobDtlDrillDwResponse {
  final int? statusCode;
  final String? message;
  final List<JobDetail>? jobDetails;

  JobDtlDrillDwResponse({
    this.statusCode,
    this.message,
    this.jobDetails,
  });

  JobDtlDrillDwResponse copyWith({
    int? statusCode,
    String? message,
    List<JobDetail>? jobDetails,
  }) =>
      JobDtlDrillDwResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        jobDetails: jobDetails ?? this.jobDetails,
      );

  factory JobDtlDrillDwResponse.fromJson(String str) =>
      JobDtlDrillDwResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobDtlDrillDwResponse.fromMap(Map<String, dynamic> json) =>
      JobDtlDrillDwResponse(
        statusCode: json["status_code"],
        message: json["message"],
        jobDetails: json["job_details"] == null
            ? []
            : List<JobDetail>.from(
                json["job_details"]!.map((x) => JobDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "job_details": jobDetails == null
            ? []
            : List<dynamic>.from(jobDetails!.map((x) => x.toMap())),
      };
}

class JobDetail {
  final String? itemName;
  final String? itemCode;
  final int? prodQty;
  final int? goodQty;
  final int? badQty;
  final int? duesQty;
  final String? madeP;
  final String? unit;

  JobDetail({
    this.itemName,
    this.itemCode,
    this.prodQty,
    this.goodQty,
    this.badQty,
    this.duesQty,
    this.madeP,
    this.unit,
  });

  JobDetail copyWith({
    String? itemName,
    String? itemCode,
    int? prodQty,
    int? goodQty,
    int? badQty,
    int? duesQty,
    String? madeP,
    String? unit,
  }) =>
      JobDetail(
        itemName: itemName ?? this.itemName,
        itemCode: itemCode ?? this.itemCode,
        prodQty: prodQty ?? this.prodQty,
        goodQty: goodQty ?? this.goodQty,
        badQty: badQty ?? this.badQty,
        duesQty: duesQty ?? this.duesQty,
        madeP: madeP ?? this.madeP,
        unit: unit ?? this.unit,
      );

  factory JobDetail.fromJson(String str) => JobDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobDetail.fromMap(Map<String, dynamic> json) => JobDetail(
        itemName: json["item_name"],
        itemCode: json["item_code"],
        prodQty: json["prod_qty"],
        goodQty: json["good_qty"],
        badQty: json["bad_qty"],
        duesQty: json["dues_qty"],
        madeP: json["made_p"],
        unit: json["unit"],
      );

  Map<String, dynamic> toMap() => {
        "item_name": itemName,
        "item_code": itemCode,
        "prod_qty": prodQty,
        "good_qty": goodQty,
        "bad_qty": badQty,
        "dues_qty": duesQty,
        "made_p": madeP,
        "unit": unit,
      };
  Map<String, dynamic> toTabMap() => {
        "Item Name": itemName,
        "Item Code": itemCode,
        "Prod Qty": prodQty,
        "Good Qty": goodQty,
        "Bad Qty": badQty,
        "Due Qty": duesQty,
        "Made p": madeP,
        "Unit": unit,
      };
}
