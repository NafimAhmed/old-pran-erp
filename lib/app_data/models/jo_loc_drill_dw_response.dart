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
  final String? lotno;
  final String? rcvFromLocator;
  final int? rcvQty;
  final int? transferedQty;
  final int? balanceQty;
  final String? transferedToLocator;

  JobLocatorInfo({
    this.jobOrderNo,
    this.lotno,
    this.rcvFromLocator,
    this.rcvQty,
    this.transferedQty,
    this.balanceQty,
    this.transferedToLocator,
  });

  JobLocatorInfo copyWith({
    String? jobOrderNo,
    String? lotno,
    String? rcvFromLocator,
    int? rcvQty,
    int? transferedQty,
    int? balanceQty,
    String? transferedToLocator,
  }) =>
      JobLocatorInfo(
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        lotno: lotno ?? this.lotno,
        rcvFromLocator: rcvFromLocator ?? this.rcvFromLocator,
        rcvQty: rcvQty ?? this.rcvQty,
        transferedQty: transferedQty ?? this.transferedQty,
        balanceQty: balanceQty ?? this.balanceQty,
        transferedToLocator: transferedToLocator ?? this.transferedToLocator,
      );

  factory JobLocatorInfo.fromJson(String str) =>
      JobLocatorInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobLocatorInfo.fromMap(Map<String, dynamic> json) => JobLocatorInfo(
        jobOrderNo: json["JOB_ORDER_NO"],
        lotno: json["LOTNO"],
        rcvFromLocator: json["RCV_FROM_LOCATOR"],
        rcvQty: json["RCV_QTY"],
        transferedQty: json["TRANSFERED_QTY"],
        balanceQty: json["BALANCE_QTY"],
        transferedToLocator: json["TRANSFERED_TO_LOCATOR"],
      );

  Map<String, dynamic> toMap() => {
        "JOB_ORDER_NO": jobOrderNo,
        "LOTNO": lotno,
        "RCV_FROM_LOCATOR": rcvFromLocator,
        "RCV_QTY": rcvQty,
        "TRANSFERED_QTY": transferedQty,
        "BALANCE_QTY": balanceQty,
        "TRANSFERED_TO_LOCATOR": transferedToLocator,
      };
  Map<String, dynamic> toTabMap() => {
        "RCV_QTY": rcvQty,
        "Transfer Qty": transferedQty,
        "Balance Qty": balanceQty,
        "Rcv From Locator": rcvFromLocator,
        "Transfer To Locator": transferedToLocator,
      };
}
