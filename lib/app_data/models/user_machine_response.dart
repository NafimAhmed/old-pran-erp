import 'dart:convert';

import 'package:pran_rfl_erp/app_data/models/user_basic_data_response.dart';

class UserMachineResponse {
  final int? statusCode;
  final String? message;
  final List<UserMachine>? userMachineData;

  UserMachineResponse({
    this.statusCode,
    this.message,
    this.userMachineData,
  });

  UserMachineResponse copyWith({
    int? statusCode,
    String? message,
    List<UserMachine>? userMachineData,
  }) =>
      UserMachineResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        userMachineData: userMachineData ?? this.userMachineData,
      );

  factory UserMachineResponse.fromJson(String str) =>
      UserMachineResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserMachineResponse.fromMap(Map<String, dynamic> json) =>
      UserMachineResponse(
        statusCode: json["status_code"],
        message: json["message"],
        userMachineData: json["user_machine_data"] == null
            ? []
            : List<UserMachine>.from(
                json["user_machine_data"]!.map((x) => UserMachine.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "user_machine_data": userMachineData == null
            ? []
            : List<dynamic>.from(userMachineData!.map((x) => x.toMap())),
      };
}

// class UserMachine {
//   final int? orgId;
//   final String? orgCode;
//   final String? machineName;
//   final String? machineDesc;

//   UserMachine({
//     this.orgId,
//     this.orgCode,
//     this.machineName,
//     this.machineDesc,
//   });

//   UserMachine copyWith({
//     int? orgId,
//     String? orgCode,
//     String? machineName,
//     String? machineDesc,
//   }) =>
//       UserMachine(
//         orgId: orgId ?? this.orgId,
//         orgCode: orgCode ?? this.orgCode,
//         machineName: machineName ?? this.machineName,
//         machineDesc: machineDesc ?? this.machineDesc,
//       );

//   factory UserMachine.fromJson(String str) =>
//       UserMachine.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory UserMachine.fromMap(Map<String, dynamic> json) => UserMachine(
//         orgId: json["ORG_ID"],
//         orgCode: json["ORG_CODE"],
//         machineName: json["MACHINE_NAME"],
//         machineDesc: json["MACHINE_DESC"],
//       );

//   Map<String, dynamic> toMap() => {
//         "ORG_ID": orgId,
//         "ORG_CODE": orgCode,
//         "MACHINE_NAME": machineName,
//         "MACHINE_DESC": machineDesc,
//       };
// }
