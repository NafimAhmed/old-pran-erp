import 'dart:convert';

import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';

class OrgsResponse {
  final int? statusCode;
  final String? message;
  final String? errmsg;
  final List<UserOrg>? orgData;

  OrgsResponse({
    this.statusCode,
    this.message,
    this.errmsg,
    this.orgData,
  });

  OrgsResponse copyWith({
    int? statusCode,
    String? message,
    String? errmsg,
    List<UserOrg>? userOrgs,
  }) =>
      OrgsResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errmsg: errmsg ?? this.errmsg,
        orgData: userOrgs ?? this.orgData,
      );

  factory OrgsResponse.fromJson(String str) =>
      OrgsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrgsResponse.fromMap(Map<String, dynamic> json) => OrgsResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errmsg: json["errmsg"],
        orgData: json["ORG_DATA"] == null
            ? []
            : List<UserOrg>.from(
                json["ORG_DATA"]!.map((x) => UserOrg.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "errmsg": errmsg,
        "ORG_DATA": orgData == null
            ? []
            : List<dynamic>.from(orgData!.map((x) => x.toMap())),
      };
}
