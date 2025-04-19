import 'dart:convert';

class GrnJoListResponse {
  final int? statusCode;
  final String? message;
  final List<GrnJO>? grnJoList;

  GrnJoListResponse({
    this.statusCode,
    this.message,
    this.grnJoList,
  });

  GrnJoListResponse copyWith({
    int? statusCode,
    String? message,
    List<GrnJO>? grnJoList,
  }) =>
      GrnJoListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        grnJoList: grnJoList ?? this.grnJoList,
      );

  factory GrnJoListResponse.fromJson(String str) =>
      GrnJoListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnJoListResponse.fromMap(Map<String, dynamic> json) =>
      GrnJoListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        grnJoList: json["Grn_JO_list"] == null
            ? []
            : List<GrnJO>.from(
                json["Grn_JO_list"]!.map((x) => GrnJO.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "Grn_JO_list": grnJoList == null
            ? []
            : List<dynamic>.from(grnJoList!.map((x) => x.toMap())),
      };
}

class GrnJO {
  final String? jobOrderNo;

  GrnJO({
    this.jobOrderNo,
  });

  GrnJO copyWith({
    String? jobOrderNo,
  }) =>
      GrnJO(
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
      );

  factory GrnJO.fromJson(String str) => GrnJO.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnJO.fromMap(Map<String, dynamic> json) => GrnJO(
        jobOrderNo: json["JOB_ORDER_NO"],
      );

  Map<String, dynamic> toMap() => {
        "JOB_ORDER_NO": jobOrderNo,
      };
  @override
  String toString() {
    return jobOrderNo ?? "";
  }
}
