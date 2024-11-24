import 'dart:convert';

class MachineAssignResponse {
  final int? statusCode;
  final String? message;
  final List<OrgMachineInfo>? orgMachineInfo;

  MachineAssignResponse({
    this.statusCode,
    this.message,
    this.orgMachineInfo,
  });

  MachineAssignResponse copyWith({
    int? statusCode,
    String? message,
    List<OrgMachineInfo>? orgMachineInfo,
  }) =>
      MachineAssignResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        orgMachineInfo: orgMachineInfo ?? this.orgMachineInfo,
      );

  factory MachineAssignResponse.fromJson(String str) =>
      MachineAssignResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MachineAssignResponse.fromMap(Map<String, dynamic> json) =>
      MachineAssignResponse(
        statusCode: json["status_code"],
        message: json["message"],
        orgMachineInfo: json["org_machine_info"] == null
            ? []
            : List<OrgMachineInfo>.from(json["org_machine_info"]!
                .map((x) => OrgMachineInfo.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "org_machine_info": orgMachineInfo == null
            ? []
            : List<dynamic>.from(orgMachineInfo!.map((x) => x.toMap())),
      };
}

class OrgMachineInfo {
  final String? orgCode;
  final String? machineName;

  OrgMachineInfo({
    this.orgCode,
    this.machineName,
  });

  OrgMachineInfo copyWith({
    String? orgCode,
    String? machineName,
  }) =>
      OrgMachineInfo(
        orgCode: orgCode ?? this.orgCode,
        machineName: machineName ?? this.machineName,
      );

  factory OrgMachineInfo.fromJson(String str) =>
      OrgMachineInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrgMachineInfo.fromMap(Map<String, dynamic> json) => OrgMachineInfo(
        orgCode: json["ORG_CODE"],
        machineName: json["MACHINE_NAME"],
      );

  Map<String, dynamic> toMap() => {
        "ORG_CODE": orgCode,
        "MACHINE_NAME": machineName,
      };
}
