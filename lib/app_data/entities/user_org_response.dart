import 'dart:convert';

class UserOrgsResponse {
  final int? statusCode;
  final String? message;
  final String? errmsg;
  final List<UserOrg>? userOrgs;

  UserOrgsResponse({
    this.statusCode,
    this.message,
    this.errmsg,
    this.userOrgs,
  });

  UserOrgsResponse copyWith({
    int? statusCode,
    String? message,
    String? errmsg,
    List<UserOrg>? userOrgs,
  }) =>
      UserOrgsResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errmsg: errmsg ?? this.errmsg,
        userOrgs: userOrgs ?? this.userOrgs,
      );

  factory UserOrgsResponse.fromJson(String str) =>
      UserOrgsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserOrgsResponse.fromMap(Map<String, dynamic> json) =>
      UserOrgsResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errmsg: json["errmsg"],
        userOrgs: json["user_orgs"] == null
            ? []
            : List<UserOrg>.from(
                json["user_orgs"]!.map((x) => UserOrg.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "errmsg": errmsg,
        "user_orgs": userOrgs == null
            ? []
            : List<dynamic>.from(userOrgs!.map((x) => x.toMap())),
      };
}

class UserOrg {
  final int? organizationId;
  final String? organizationCode;
  final String? organizationName;

  UserOrg({
    this.organizationId,
    this.organizationCode,
    this.organizationName,
  });

  UserOrg copyWith({
    int? organizationId,
    String? organizationCode,
    String? organizationName,
  }) =>
      UserOrg(
        organizationId: organizationId ?? this.organizationId,
        organizationCode: organizationCode ?? this.organizationCode,
        organizationName: organizationName ?? this.organizationName,
      );

  factory UserOrg.fromJson(String str) => UserOrg.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserOrg.fromMap(Map<String, dynamic> json) => UserOrg(
        organizationId: json["ORGANIZATION_ID"],
        organizationCode: json["ORGANIZATION_CODE"],
        organizationName: json["ORGANIZATION_NAME"],
      );

  Map<String, dynamic> toMap() => {
        "ORGANIZATION_ID": organizationId,
        "ORGANIZATION_CODE": organizationCode,
        "ORGANIZATION_NAME": organizationName,
      };
  @override
  String toString() {
    return organizationCode ?? "";
  }
}
