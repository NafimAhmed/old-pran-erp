import 'dart:convert';

class AppsUserResponse {
  final int? statusCode;
  final String? message;
  final List<AppsUserData>? appsUserData;

  AppsUserResponse({
    this.statusCode,
    this.message,
    this.appsUserData,
  });

  AppsUserResponse copyWith({
    int? statusCode,
    String? message,
    List<AppsUserData>? appsUserData,
  }) =>
      AppsUserResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        appsUserData: appsUserData ?? this.appsUserData,
      );

  factory AppsUserResponse.fromJson(String str) =>
      AppsUserResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppsUserResponse.fromMap(Map<String, dynamic> json) =>
      AppsUserResponse(
        statusCode: json["status_code"],
        message: json["message"],
        appsUserData: json["apps_user_data"] == null
            ? []
            : List<AppsUserData>.from(
                json["apps_user_data"]!.map((x) => AppsUserData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "apps_user_data": appsUserData == null
            ? []
            : List<dynamic>.from(appsUserData!.map((x) => x.toMap())),
      };
}

class AppsUserData {
  final int? userId;
  final String? userName;
  final String? description;

  AppsUserData({
    this.userId,
    this.userName,
    this.description,
  });

  AppsUserData copyWith({
    int? userId,
    String? userName,
    String? description,
  }) =>
      AppsUserData(
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        description: description ?? this.description,
      );

  factory AppsUserData.fromJson(String str) =>
      AppsUserData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppsUserData.fromMap(Map<String, dynamic> json) => AppsUserData(
        userId: json["USER_ID"],
        userName: json["USER_NAME"],
        description: json["DESCRIPTION"],
      );

  Map<String, dynamic> toMap() => {
        "USER_ID": userId,
        "USER_NAME": userName,
        "DESCRIPTION": description,
      };
  @override
  String toString() {
    return userName ?? "";
  }
}
