import 'dart:convert';

class BatchStatusCheckResponse {
  final int? statusCode;
  final String? message;
  final List<BatchStatusCheck>? batchStatusCk;

  BatchStatusCheckResponse({
    this.statusCode,
    this.message,
    this.batchStatusCk,
  });

  BatchStatusCheckResponse copyWith({
    int? statusCode,
    String? message,
    List<BatchStatusCheck>? batchStatusCk,
  }) =>
      BatchStatusCheckResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        batchStatusCk: batchStatusCk ?? this.batchStatusCk,
      );

  factory BatchStatusCheckResponse.fromJson(String str) =>
      BatchStatusCheckResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchStatusCheckResponse.fromMap(Map<String, dynamic> json) =>
      BatchStatusCheckResponse(
        statusCode: json["status_code"],
        message: json["message"],
        batchStatusCk: json["Batch_Status_ck"] == null
            ? []
            : List<BatchStatusCheck>.from(json["Batch_Status_ck"]!
                .map((x) => BatchStatusCheck.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "Batch_Status_ck": batchStatusCk == null
            ? []
            : List<dynamic>.from(batchStatusCk!.map((x) => x.toMap())),
      };
}

class BatchStatusCheck {
  final String? userName;
  final String? batchNo;
  final String? organizationCode;
  final String? organizationName;
  final String? batchStatus;

  BatchStatusCheck({
    this.userName,
    this.batchNo,
    this.organizationCode,
    this.organizationName,
    this.batchStatus,
  });

  BatchStatusCheck copyWith({
    String? userName,
    String? batchNo,
    String? organizationCode,
    String? organizationName,
    String? batchStatus,
  }) =>
      BatchStatusCheck(
        userName: userName ?? this.userName,
        batchNo: batchNo ?? this.batchNo,
        organizationCode: organizationCode ?? this.organizationCode,
        organizationName: organizationName ?? this.organizationName,
        batchStatus: batchStatus ?? this.batchStatus,
      );

  factory BatchStatusCheck.fromJson(String str) =>
      BatchStatusCheck.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchStatusCheck.fromMap(Map<String, dynamic> json) =>
      BatchStatusCheck(
        userName: json["user_name"],
        batchNo: json["BATCH_NO"],
        organizationCode: json["organization_code"],
        organizationName: json["organization_name"],
        batchStatus: json["batch_status"],
      );

  Map<String, dynamic> toMap() => {
        "user_name": userName,
        "BATCH_NO": batchNo,
        "organization_code": organizationCode,
        "organization_name": organizationName,
        "batch_status": batchStatus,
      };
}
