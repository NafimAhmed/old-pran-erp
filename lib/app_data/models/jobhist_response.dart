import 'dart:convert';

class JobHistoryResponse {
  final int? statusCode;
  final String? message;
  final List<JobHistory>? jobOrderInfo;

  JobHistoryResponse({
    this.statusCode,
    this.message,
    this.jobOrderInfo,
  });

  JobHistoryResponse copyWith({
    int? statusCode,
    String? message,
    List<JobHistory>? jobOrderInfo,
  }) =>
      JobHistoryResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        jobOrderInfo: jobOrderInfo ?? this.jobOrderInfo,
      );

  factory JobHistoryResponse.fromJson(String str) =>
      JobHistoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobHistoryResponse.fromMap(Map<String, dynamic> json) =>
      JobHistoryResponse(
        statusCode: json["status_code"],
        message: json["message"],
        jobOrderInfo: json["job_order_info"] == null
            ? []
            : List<JobHistory>.from(
                json["job_order_info"]!.map((x) => JobHistory.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "job_order_info": jobOrderInfo == null
            ? []
            : List<dynamic>.from(jobOrderInfo!.map((x) => x.toMap())),
      };
}

class JobHistory {
  final String? jobOrderNo;
  final String? fpoNo;
  final String? item;
  final String? creationDate;
  final String? planStartDate;
  final String? planCmplDate;
  final double? fpoQty;
  final int? goodQty;
  final int? badQty;
  final int? trnQty;
  final int? rackQty;
  final double? madeP;
  final double? dueMadeP;
  final String? customerName;
  final String? customerPo;
  final String? buyerName;

  JobHistory({
    this.jobOrderNo,
    this.fpoNo,
    this.item,
    this.creationDate,
    this.planStartDate,
    this.planCmplDate,
    this.fpoQty,
    this.goodQty,
    this.badQty,
    this.trnQty,
    this.rackQty,
    this.madeP,
    this.dueMadeP,
    this.customerName,
    this.customerPo,
    this.buyerName,
  });

  JobHistory copyWith({
    String? jobOrderNo,
    String? fpoNo,
    String? item,
    String? creationDate,
    String? planStartDate,
    String? planCmplDate,
    double? fpoQty,
    int? goodQty,
    int? badQty,
    int? trnQty,
    int? rackQty,
    double? madeP,
    double? dueMadeP,
    String? customerName,
    String? customerPo,
    String? buyerName,
  }) =>
      JobHistory(
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        fpoNo: fpoNo ?? this.fpoNo,
        item: item ?? this.item,
        creationDate: creationDate ?? this.creationDate,
        planStartDate: planStartDate ?? this.planStartDate,
        planCmplDate: planCmplDate ?? this.planCmplDate,
        fpoQty: fpoQty ?? this.fpoQty,
        goodQty: goodQty ?? this.goodQty,
        badQty: badQty ?? this.badQty,
        trnQty: trnQty ?? this.trnQty,
        rackQty: rackQty ?? this.rackQty,
        madeP: madeP ?? this.madeP,
        dueMadeP: dueMadeP ?? this.dueMadeP,
        customerName: customerName ?? this.customerName,
        customerPo: customerPo ?? this.customerPo,
        buyerName: buyerName ?? this.buyerName,
      );

  factory JobHistory.fromJson(String str) =>
      JobHistory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobHistory.fromMap(Map<String, dynamic> json) => JobHistory(
        jobOrderNo: json["job_order_no"],
        fpoNo: json["fpo_no"],
        item: json["item"],
        creationDate: json["creation_date"],
        planStartDate: json["plan_start_date"],
        planCmplDate: json["plan_cmpl_date"],
        fpoQty: json["fpo_qty"]?.toDouble(),
        goodQty: json["good_qty"],
        badQty: json["bad_qty"],
        trnQty: json["trn_qty"],
        rackQty: json["rack_qty"],
        madeP: json["made_p"]?.toDouble(),
        dueMadeP: json["due_made_p"]?.toDouble(),
        customerName: json["customer_name"],
        customerPo: json["customer_po"],
        buyerName: json["buyer_name"],
      );

  Map<String, dynamic> toMap() => {
        "job_order_no": jobOrderNo,
        "fpo_no": fpoNo,
        "item": item,
        "creation_date": creationDate,
        "plan_start_date": planStartDate,
        "plan_cmpl_date": planCmplDate,
        "fpo_qty": fpoQty,
        "good_qty": goodQty,
        "bad_qty": badQty,
        "trn_qty": trnQty,
        "rack_qty": rackQty,
        "made_p": madeP,
        "due_made_p": dueMadeP,
        "customer_name": customerName,
        "customer_po": customerPo,
        "buyer_name": buyerName,
      };

  Map<String, dynamic> toMapForTab() => {
        "Job Order No": jobOrderNo,
        "Made P %": "$madeP %",
        "Item": item,
        "FPO Qty": fpoQty,
        "Good Qty": goodQty,
        "Bad Qty": badQty,
        "Trn Qty": trnQty,
        "Rack Qty": rackQty,
        "Due Made P %": "$dueMadeP %",
      };
}
