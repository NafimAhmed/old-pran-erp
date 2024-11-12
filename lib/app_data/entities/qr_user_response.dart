import 'dart:convert';

class QrUserResponse {
  final int? statusCode;
  final String? message;
  final List<QrUserData>? userData;

  QrUserResponse({
    this.statusCode,
    this.message,
    this.userData,
  });

  QrUserResponse copyWith({
    int? statusCode,
    String? message,
    List<QrUserData>? userData,
  }) =>
      QrUserResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        userData: userData ?? this.userData,
      );

  factory QrUserResponse.fromJson(String str) =>
      QrUserResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QrUserResponse.fromMap(Map<String, dynamic> json) => QrUserResponse(
        statusCode: json["status_code"],
        message: json["message"],
        userData: json["user_data"] == null
            ? []
            : List<QrUserData>.from(
                json["user_data"]!.map((x) => QrUserData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "user_data": userData == null
            ? []
            : List<dynamic>.from(userData!.map((x) => x.toMap())),
      };
}

class QrUserData {
  final String? userId;
  final String? userName;

  QrUserData({
    this.userId,
    this.userName,
  });

  QrUserData copyWith({
    String? userId,
    String? userName,
  }) =>
      QrUserData(
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
      );

  factory QrUserData.fromJson(String str) =>
      QrUserData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QrUserData.fromMap(Map<String, dynamic> json) => QrUserData(
        userId: json["USER_ID"],
        userName: json["USER_NAME"],
      );

  Map<String, dynamic> toMap() => {
        "USER_ID": userId,
        "USER_NAME": userName,
      };
  @override
  String toString() {
    return userName ?? "";
  }
}
