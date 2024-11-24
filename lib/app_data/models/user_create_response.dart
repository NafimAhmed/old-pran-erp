import 'dart:convert';

class UserCreateResponse {
  final int? statusCode;
  final String? message;
  final List<NewUserInfo>? newUserInfo;

  UserCreateResponse({
    this.statusCode,
    this.message,
    this.newUserInfo,
  });

  UserCreateResponse copyWith({
    int? statusCode,
    String? message,
    List<NewUserInfo>? newUserInfo,
  }) =>
      UserCreateResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        newUserInfo: newUserInfo ?? this.newUserInfo,
      );

  factory UserCreateResponse.fromJson(String str) =>
      UserCreateResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserCreateResponse.fromMap(Map<String, dynamic> json) =>
      UserCreateResponse(
        statusCode: json["status_code"],
        message: json["message"],
        newUserInfo: json["new_user_info"] == null
            ? []
            : List<NewUserInfo>.from(
                json["new_user_info"]!.map((x) => NewUserInfo.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "new_user_info": newUserInfo == null
            ? []
            : List<dynamic>.from(newUserInfo!.map((x) => x.toMap())),
      };
}

class NewUserInfo {
  final String? userId;
  final String? userName;
  final String? appUserId;
  final String? mobileNo;

  NewUserInfo({
    this.userId,
    this.userName,
    this.appUserId,
    this.mobileNo,
  });

  NewUserInfo copyWith({
    String? userId,
    String? userName,
    String? appUserId,
    String? mobileNo,
  }) =>
      NewUserInfo(
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        appUserId: appUserId ?? this.appUserId,
        mobileNo: mobileNo ?? this.mobileNo,
      );

  factory NewUserInfo.fromJson(String str) =>
      NewUserInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NewUserInfo.fromMap(Map<String, dynamic> json) => NewUserInfo(
        userId: json["USER_ID"],
        userName: json["USER_NAME"],
        appUserId: json["APP_USER_ID"],
        mobileNo: json["MOBILE_NO"],
      );

  Map<String, dynamic> toMap() => {
        "USER_ID": userId,
        "USER_NAME": userName,
        "APP_USER_ID": appUserId,
        "MOBILE_NO": mobileNo,
      };
}
