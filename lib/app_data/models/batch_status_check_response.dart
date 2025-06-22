import 'dart:convert';

class BatchStatusCheckResponse {
  final int? statusCode;
  final String? message;
  final String? errmsg;
  final List<BatchStatusCheck>? batchStatusCk;
  final BatchLocation? batchLocation;

  BatchStatusCheckResponse({
    this.statusCode,
    this.message,
    this.errmsg,
    this.batchStatusCk,
    this.batchLocation,
  });

  BatchStatusCheckResponse copyWith({
    int? statusCode,
    String? message,
    String? errmsg,
    List<BatchStatusCheck>? batchStatusCk,
    BatchLocation? batchLocation,
  }) =>
      BatchStatusCheckResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errmsg: errmsg ?? this.errmsg,
        batchStatusCk: batchStatusCk ?? this.batchStatusCk,
        batchLocation: batchLocation ?? this.batchLocation,
      );

  factory BatchStatusCheckResponse.fromJson(String str) =>
      BatchStatusCheckResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchStatusCheckResponse.fromMap(Map<String, dynamic> json) =>
      BatchStatusCheckResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errmsg: json["errmsg"],
        batchStatusCk: json["Batch_Status_ck"] == null
            ? []
            : List<BatchStatusCheck>.from(json["Batch_Status_ck"]!
                .map((x) => BatchStatusCheck.fromMap(x))),
        batchLocation: json["batch_location"] == null
            ? null
            : BatchLocation.fromMap(json["batch_location"]),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "errmsg": errmsg,
        "Batch_Status_ck": batchStatusCk == null
            ? []
            : List<dynamic>.from(batchStatusCk!.map((x) => x.toMap())),
        "batch_location": batchLocation?.toMap(),
      };
}

class BatchLocation {
  final String? subinventoryCode;
  final String? description;
  final int? stock;

  BatchLocation({
    this.subinventoryCode,
    this.description,
    this.stock,
  });

  BatchLocation copyWith({
    String? subinventoryCode,
    String? description,
    int? stock,
  }) =>
      BatchLocation(
        subinventoryCode: subinventoryCode ?? this.subinventoryCode,
        description: description ?? this.description,
        stock: stock ?? this.stock,
      );

  factory BatchLocation.fromJson(String str) =>
      BatchLocation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchLocation.fromMap(Map<String, dynamic> json) => BatchLocation(
        subinventoryCode: json["SUBINVENTORY_CODE"],
        description: json["DESCRIPTION"],
        stock: json["STOCK"],
      );

  Map<String, dynamic> toMap() => {
        "SUBINVENTORY_CODE": subinventoryCode,
        "DESCRIPTION": description,
        "STOCK": stock,
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
