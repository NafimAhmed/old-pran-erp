import 'dart:convert';

import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';

class GrnOrgListResponse {
  final int? statusCode;
  final String? message;
  final List<UserOrg>? grnOrg;

  GrnOrgListResponse({
    this.statusCode,
    this.message,
    this.grnOrg,
  });

  GrnOrgListResponse copyWith({
    int? statusCode,
    String? message,
    List<UserOrg>? grnOrg,
  }) =>
      GrnOrgListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        grnOrg: grnOrg ?? this.grnOrg,
      );

  factory GrnOrgListResponse.fromJson(String str) =>
      GrnOrgListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnOrgListResponse.fromMap(Map<String, dynamic> json) =>
      GrnOrgListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        grnOrg: json["Grn_Org_list"] == null
            ? []
            : List<UserOrg>.from(
                json["Grn_Org_list"]!.map((x) => UserOrg.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "Grn_Org_list": grnOrg == null
            ? []
            : List<dynamic>.from(grnOrg!.map((x) => x.toMap())),
      };
}
