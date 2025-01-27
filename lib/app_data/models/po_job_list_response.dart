import 'dart:convert';

class PoJobListResponse {
  final int? statusCode;
  final String? message;
  final List<PoJob>? poJobList;

  PoJobListResponse({
    this.statusCode,
    this.message,
    this.poJobList,
  });

  PoJobListResponse copyWith({
    int? statusCode,
    String? message,
    List<PoJob>? poJobList,
  }) =>
      PoJobListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        poJobList: poJobList ?? this.poJobList,
      );

  factory PoJobListResponse.fromJson(String str) =>
      PoJobListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PoJobListResponse.fromMap(Map<String, dynamic> json) =>
      PoJobListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        poJobList: json["po_job_list"] == null
            ? []
            : List<PoJob>.from(
                json["po_job_list"]!.map((x) => PoJob.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "po_job_list": poJobList == null
            ? []
            : List<dynamic>.from(poJobList!.map((x) => x.toMap())),
      };
}

class PoJob {
  final String? jobOrderNo;
  final String? buyerName;

  PoJob({
    this.jobOrderNo,
    this.buyerName,
  });

  PoJob copyWith({
    String? jobOrderNo,
    String? buyerName,
  }) =>
      PoJob(
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        buyerName: buyerName ?? this.buyerName,
      );

  factory PoJob.fromJson(String str) => PoJob.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PoJob.fromMap(Map<String, dynamic> json) => PoJob(
        jobOrderNo: json["JOB_ORDER_NO"],
        buyerName: json["BUYER_NAME"],
      );

  Map<String, dynamic> toMap() => {
        "JOB_ORDER_NO": jobOrderNo,
        "BUYER_NAME": buyerName,
      };
}
