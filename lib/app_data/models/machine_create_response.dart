import 'dart:convert';

import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';

class MachineCreateResponse {
  final int? statusCode;
  final String? message;
  final List<MachineInfo>? machineInfo;
  final List<UserOrg>? orgInfo;

  MachineCreateResponse({
    this.statusCode,
    this.message,
    this.machineInfo,
    this.orgInfo,
  });

  MachineCreateResponse copyWith({
    int? statusCode,
    String? message,
    List<MachineInfo>? machineInfo,
    List<UserOrg>? orgInfo,
  }) =>
      MachineCreateResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        machineInfo: machineInfo ?? this.machineInfo,
        orgInfo: orgInfo ?? this.orgInfo,
      );

  factory MachineCreateResponse.fromJson(String str) =>
      MachineCreateResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MachineCreateResponse.fromMap(Map<String, dynamic> json) =>
      MachineCreateResponse(
        statusCode: json["status_code"],
        message: json["message"],
        machineInfo: json["machine_info"] == null
            ? []
            : List<MachineInfo>.from(
                json["machine_info"]!.map((x) => MachineInfo.fromMap(x))),
        orgInfo: json["org_info"] == null
            ? []
            : List<UserOrg>.from(
                json["org_info"]!.map((x) => UserOrg.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "machine_info": machineInfo == null
            ? []
            : List<dynamic>.from(machineInfo!.map((x) => x.toMap())),
        "org_info": orgInfo == null
            ? []
            : List<dynamic>.from(orgInfo!.map((x) => x.toMap())),
      };
}

class MachineInfo {
  final String? machineName;

  MachineInfo({
    this.machineName,
  });

  MachineInfo copyWith({
    String? machineName,
  }) =>
      MachineInfo(
        machineName: machineName ?? this.machineName,
      );

  factory MachineInfo.fromJson(String str) =>
      MachineInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MachineInfo.fromMap(Map<String, dynamic> json) => MachineInfo(
        machineName: json["MACHINE_NAME"],
      );

  Map<String, dynamic> toMap() => {
        "MACHINE_NAME": machineName,
      };
  @override
  String toString() {
    return machineName ?? "";
  }
}
