import 'dart:convert';

class SubInvResponse {
  final int? statusCode;
  final String? message;
  final List<SubInvData>? subinvData;

  SubInvResponse({
    this.statusCode,
    this.message,
    this.subinvData,
  });

  SubInvResponse copyWith({
    int? statusCode,
    String? message,
    List<SubInvData>? subinvData,
  }) =>
      SubInvResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        subinvData: subinvData ?? this.subinvData,
      );

  factory SubInvResponse.fromJson(String str) =>
      SubInvResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubInvResponse.fromMap(Map<String, dynamic> json) => SubInvResponse(
        statusCode: json["status_code"],
        message: json["message"],
        subinvData: json["subinv_data"] == null
            ? []
            : List<SubInvData>.from(
                json["subinv_data"]!.map((x) => SubInvData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "subinv_data": subinvData == null
            ? []
            : List<dynamic>.from(subinvData!.map((x) => x.toMap())),
      };
}

class SubInvData {
  final String? secondaryInventoryName;

  SubInvData({
    this.secondaryInventoryName,
  });

  SubInvData copyWith({
    String? secondaryInventoryName,
  }) =>
      SubInvData(
        secondaryInventoryName:
            secondaryInventoryName ?? this.secondaryInventoryName,
      );

  factory SubInvData.fromJson(String str) =>
      SubInvData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubInvData.fromMap(Map<String, dynamic> json) => SubInvData(
        secondaryInventoryName: json["SECONDARY_INVENTORY_NAME"],
      );

  Map<String, dynamic> toMap() => {
        "SECONDARY_INVENTORY_NAME": secondaryInventoryName,
      };

  @override
  String toString() {
    return secondaryInventoryName ?? "";
  }
}
