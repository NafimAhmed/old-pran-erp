import 'dart:convert';

class OperationUnitListResponse {
  final int? statusCode;
  final String? message;
  final List<OperationUnit>? operationUnitList;

  OperationUnitListResponse({
    this.statusCode,
    this.message,
    this.operationUnitList,
  });

  OperationUnitListResponse copyWith({
    int? statusCode,
    String? message,
    List<OperationUnit>? operationUnitList,
  }) =>
      OperationUnitListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        operationUnitList: operationUnitList ?? this.operationUnitList,
      );

  factory OperationUnitListResponse.fromJson(String str) =>
      OperationUnitListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OperationUnitListResponse.fromMap(Map<String, dynamic> json) =>
      OperationUnitListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        operationUnitList: json["Operation_Unit_list"] == null
            ? []
            : List<OperationUnit>.from(json["Operation_Unit_list"]!
                .map((x) => OperationUnit.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "Operation_Unit_list": operationUnitList == null
            ? []
            : List<dynamic>.from(operationUnitList!.map((x) => x.toMap())),
      };
}

class OperationUnit {
  final String? operationUnit;
  final String? shortCode;
  final int? organizationId;

  OperationUnit({
    this.operationUnit,
    this.shortCode,
    this.organizationId,
  });

  OperationUnit copyWith({
    String? operationUnit,
    String? shortCode,
    int? organizationId,
  }) =>
      OperationUnit(
        operationUnit: operationUnit ?? this.operationUnit,
        shortCode: shortCode ?? this.shortCode,
        organizationId: organizationId ?? this.organizationId,
      );

  factory OperationUnit.fromJson(String str) =>
      OperationUnit.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OperationUnit.fromMap(Map<String, dynamic> json) => OperationUnit(
        operationUnit: json["Operation_Unit"],
        shortCode: json["SHORT_CODE"],
        organizationId: json["ORGANIZATION_ID"],
      );

  Map<String, dynamic> toMap() => {
        "Operation_Unit": operationUnit,
        "SHORT_CODE": shortCode,
        "ORGANIZATION_ID": organizationId,
      };
  @override
  String toString() {
    return operationUnit ?? "";
  }
}
