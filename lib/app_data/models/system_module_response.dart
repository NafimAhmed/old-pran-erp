import 'dart:convert';

class SystemModuleResponse {
  final int? statusCode;
  final String? message;
  final List<SysModuleData>? sysModuleData;

  SystemModuleResponse({
    this.statusCode,
    this.message,
    this.sysModuleData,
  });

  SystemModuleResponse copyWith({
    int? statusCode,
    String? message,
    List<SysModuleData>? sysModuleData,
  }) =>
      SystemModuleResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        sysModuleData: sysModuleData ?? this.sysModuleData,
      );

  factory SystemModuleResponse.fromJson(String str) =>
      SystemModuleResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SystemModuleResponse.fromMap(Map<String, dynamic> json) =>
      SystemModuleResponse(
        statusCode: json["status_code"],
        message: json["message"],
        sysModuleData: json["sys_module_data"] == null
            ? []
            : List<SysModuleData>.from(
                json["sys_module_data"]!.map((x) => SysModuleData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "sys_module_data": sysModuleData == null
            ? []
            : List<dynamic>.from(sysModuleData!.map((x) => x.toMap())),
      };
}

class SysModuleData {
  final String? moduleName;

  SysModuleData({
    this.moduleName,
  });

  SysModuleData copyWith({
    String? moduleName,
  }) =>
      SysModuleData(
        moduleName: moduleName ?? this.moduleName,
      );

  factory SysModuleData.fromJson(String str) =>
      SysModuleData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SysModuleData.fromMap(Map<String, dynamic> json) => SysModuleData(
        moduleName: json["Module_name"],
      );

  Map<String, dynamic> toMap() => {
        "Module_name": moduleName,
      };
  @override
  String toString() {
    return moduleName ?? "";
  }
}
