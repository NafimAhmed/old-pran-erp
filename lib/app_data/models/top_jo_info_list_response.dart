import 'dart:convert';

class TopJoInfoListResponse {
  final int? statusCode;
  final String? message;
  final List<TopJoInfo>? topJoInfo;

  TopJoInfoListResponse({
    this.statusCode,
    this.message,
    this.topJoInfo,
  });

  TopJoInfoListResponse copyWith({
    int? statusCode,
    String? message,
    List<TopJoInfo>? topJoInfo,
  }) =>
      TopJoInfoListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        topJoInfo: topJoInfo ?? this.topJoInfo,
      );

  factory TopJoInfoListResponse.fromJson(String str) =>
      TopJoInfoListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TopJoInfoListResponse.fromMap(Map<String, dynamic> json) =>
      TopJoInfoListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        topJoInfo: json["top_jo_info"] == null
            ? []
            : List<TopJoInfo>.from(
                json["top_jo_info"]!.map((x) => TopJoInfo.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "top_jo_info": topJoInfo == null
            ? []
            : List<dynamic>.from(topJoInfo!.map((x) => x.toMap())),
      };
}

class TopJoInfo {
  final String? buyerName;
  final String? jobOrderNo;
  final String? deliveryDate;
  final int? fpoQty;
  final int? goodQty;
  final int? trnQty;
  final int? rackQty;
  final double? madeP;
  final int? salesQty;

  TopJoInfo({
    this.buyerName,
    this.jobOrderNo,
    this.deliveryDate,
    this.fpoQty,
    this.goodQty,
    this.trnQty,
    this.rackQty,
    this.madeP,
    this.salesQty,
  });

  TopJoInfo copyWith({
    String? buyerName,
    String? jobOrderNo,
    String? deliveryDate,
    int? fpoQty,
    int? goodQty,
    int? trnQty,
    int? rackQty,
    double? madeP,
    int? salesQty,
  }) =>
      TopJoInfo(
        buyerName: buyerName ?? this.buyerName,
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        deliveryDate: deliveryDate ?? this.deliveryDate,
        fpoQty: fpoQty ?? this.fpoQty,
        goodQty: goodQty ?? this.goodQty,
        trnQty: trnQty ?? this.trnQty,
        rackQty: rackQty ?? this.rackQty,
        madeP: madeP ?? this.madeP,
        salesQty: salesQty ?? this.salesQty,
      );

  factory TopJoInfo.fromJson(String str) => TopJoInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TopJoInfo.fromMap(Map<String, dynamic> json) => TopJoInfo(
        buyerName: json["buyer_name"],
        jobOrderNo: json["job_order_no"],
        deliveryDate: json["delivery_date"],
        fpoQty: json["fpo_qty"],
        goodQty: json["good_qty"],
        trnQty: json["trn_qty"],
        rackQty: json["rack_qty"],
        madeP: json["made_p"]?.toDouble(),
        salesQty: json["sales_qty"],
      );

  Map<String, dynamic> toMap() => {
        "buyer_name": buyerName,
        "job_order_no": jobOrderNo,
        "delivery_date": deliveryDate,
        "fpo_qty": fpoQty,
        "good_qty": goodQty,
        "trn_qty": trnQty,
        "rack_qty": rackQty,
        "made_p": madeP,
        "sales_qty": salesQty,
      };
  Map<String, dynamic> toTabMap() => {
        "Job Order No": jobOrderNo,
        "Made P %": madeP,
        "Buyer Name": buyerName,
        "FPO Qty": fpoQty,
        "Good Qty": goodQty,
        "Trn Qty": trnQty,
        "Rack Qty": rackQty,
        "Sales Qty": salesQty,
        "Delivery Date": deliveryDate,
      };
}
