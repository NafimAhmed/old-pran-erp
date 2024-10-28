import 'dart:convert';

class AuthenticationResponse {
  final int? statusCode;
  final String? message;
  final String? errmsg;
  final List<UserInfo>? userInfo;

  AuthenticationResponse({
    this.statusCode,
    this.message,
    this.errmsg,
    this.userInfo,
  });

  AuthenticationResponse copyWith({
    int? statusCode,
    String? message,
    String? errmsg,
    List<UserInfo>? userInfo,
  }) =>
      AuthenticationResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errmsg: errmsg ?? this.errmsg,
        userInfo: userInfo ?? this.userInfo,
      );

  factory AuthenticationResponse.fromJson(String str) => AuthenticationResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthenticationResponse.fromMap(Map<String, dynamic> json) => AuthenticationResponse(
    statusCode: json["status_code"],
    message: json["message"],
    errmsg: json["errmsg"],
    userInfo: json["user_info"] == null ? [] : List<UserInfo>.from(json["user_info"]!.map((x) => UserInfo.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "errmsg": errmsg,
    "user_info": userInfo == null ? [] : List<dynamic>.from(userInfo!.map((x) => x.toMap())),
  };
}

class UserInfo {
  final String? userId;
  final String? userName;
  final String? mobileNo;
  final String? userDesg;
  final String? userDept;

  UserInfo({
    this.userId,
    this.userName,
    this.mobileNo,
    this.userDesg,
    this.userDept,
  });

  UserInfo copyWith({
    String? userId,
    String? userName,
    String? mobileNo,
    String? userDesg,
    String? userDept,
  }) =>
      UserInfo(
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        mobileNo: mobileNo ?? this.mobileNo,
        userDesg: userDesg ?? this.userDesg,
        userDept: userDept ?? this.userDept,
      );

  factory UserInfo.fromJson(String str) => UserInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserInfo.fromMap(Map<String, dynamic> json) => UserInfo(
    userId: json["USER_ID"],
    userName: json["USER_NAME"],
    mobileNo: json["MOBILE_NO"],
    userDesg: json["USER_DESG"],
    userDept: json["USER_DEPT"],
  );

  Map<String, dynamic> toMap() => {
    "USER_ID": userId,
    "USER_NAME": userName,
    "MOBILE_NO": mobileNo,
    "USER_DESG": userDesg,
    "USER_DEPT": userDept,
  };
}
