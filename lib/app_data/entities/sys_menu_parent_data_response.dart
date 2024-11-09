import 'dart:convert';

class SystemMenuParentDataResponse {
  final int? statusCode;
  final String? message;
  final List<SysMenuparentData>? sysMenuparentData;

  SystemMenuParentDataResponse({
    this.statusCode,
    this.message,
    this.sysMenuparentData,
  });

  SystemMenuParentDataResponse copyWith({
    int? statusCode,
    String? message,
    List<SysMenuparentData>? sysMenuparentData,
  }) =>
      SystemMenuParentDataResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        sysMenuparentData: sysMenuparentData ?? this.sysMenuparentData,
      );

  factory SystemMenuParentDataResponse.fromJson(String str) =>
      SystemMenuParentDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SystemMenuParentDataResponse.fromMap(Map<String, dynamic> json) =>
      SystemMenuParentDataResponse(
        statusCode: json["status_code"],
        message: json["message"],
        sysMenuparentData: json["sys_menuparent_data"] == null
            ? []
            : List<SysMenuparentData>.from(json["sys_menuparent_data"]!
                .map((x) => SysMenuparentData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "sys_menuparent_data": sysMenuparentData == null
            ? []
            : List<dynamic>.from(sysMenuparentData!.map((x) => x.toMap())),
      };
}

class SysMenuparentData {
  final String? parentName;

  SysMenuparentData({
    this.parentName,
  });

  SysMenuparentData copyWith({
    String? parentName,
  }) =>
      SysMenuparentData(
        parentName: parentName ?? this.parentName,
      );

  factory SysMenuparentData.fromJson(String str) =>
      SysMenuparentData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SysMenuparentData.fromMap(Map<String, dynamic> json) =>
      SysMenuparentData(
        parentName: json["PARENT_NAME"],
      );

  Map<String, dynamic> toMap() => {
        "PARENT_NAME": parentName,
      };

  @override
  String toString() {
    return parentName ?? "";
  }
}
