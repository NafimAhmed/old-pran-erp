import 'dart:convert';

class ProdBasicDataResponse {
  final int? statusCode;
  final String? errmsg;
  final String? message;
  final List<UserMachine>? userMachineData;
  final List<PendingJo>? pendingJoList;

  ProdBasicDataResponse({
    this.statusCode,
    this.errmsg,
    this.message,
    this.userMachineData,
    this.pendingJoList,
  });

  ProdBasicDataResponse copyWith({
    int? statusCode,
    String? errmsg,
    String? message,
    List<UserMachine>? userMachineData,
    List<PendingJo>? pendingJoList,
  }) =>
      ProdBasicDataResponse(
        statusCode: statusCode ?? this.statusCode,
        errmsg: errmsg ?? this.errmsg,
        message: message ?? this.message,
        userMachineData: userMachineData ?? this.userMachineData,
        pendingJoList: pendingJoList ?? this.pendingJoList,
      );

  factory ProdBasicDataResponse.fromJson(String str) =>
      ProdBasicDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProdBasicDataResponse.fromMap(Map<String, dynamic> json) =>
      ProdBasicDataResponse(
        statusCode: json["status_code"],
        errmsg: json["errmsg"],
        message: json["message"],
        userMachineData: json["user_machine_data"] == null
            ? []
            : List<UserMachine>.from(
                json["user_machine_data"]!.map((x) => UserMachine.fromMap(x))),
        pendingJoList: json["pending_JO_list"] == null
            ? []
            : List<PendingJo>.from(
                json["pending_JO_list"]!.map((x) => PendingJo.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "errmsg": errmsg,
        "message": message,
        "user_machine_data": userMachineData == null
            ? []
            : List<dynamic>.from(userMachineData!.map((x) => x.toMap())),
        "pending_JO_list": pendingJoList == null
            ? []
            : List<dynamic>.from(pendingJoList!.map((x) => x.toMap())),
      };
}

class PendingJo {
  final String? jobOrderNo;

  PendingJo({
    this.jobOrderNo,
  });

  PendingJo copyWith({
    String? jobOrderNo,
  }) =>
      PendingJo(
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
      );

  factory PendingJo.fromJson(String str) => PendingJo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PendingJo.fromMap(Map<String, dynamic> json) => PendingJo(
        jobOrderNo: json["job_order_no"],
      );

  Map<String, dynamic> toMap() => {
        "job_order_no": jobOrderNo,
      };

  @override
  String toString() {
    return jobOrderNo ?? "";
  }
}

class UserMachine {
  final int? orgId;
  final String? orgCode;
  final String? machineName;
  final String? machineDesc;

  UserMachine({
    this.orgId,
    this.orgCode,
    this.machineName,
    this.machineDesc,
  });

  UserMachine copyWith({
    int? orgId,
    String? orgCode,
    String? machineName,
    String? machineDesc,
  }) =>
      UserMachine(
        orgId: orgId ?? this.orgId,
        orgCode: orgCode ?? this.orgCode,
        machineName: machineName ?? this.machineName,
        machineDesc: machineDesc ?? this.machineDesc,
      );

  factory UserMachine.fromJson(String str) =>
      UserMachine.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
  @override
  String toString() {
    return machineName ?? "";
  }

  factory UserMachine.fromMap(Map<String, dynamic> json) => UserMachine(
        orgId: json["ORG_ID"],
        orgCode: json["ORG_CODE"],
        machineName: json["MACHINE_NAME"],
        machineDesc: json["MACHINE_DESC"],
      );

  Map<String, dynamic> toMap() => {
        "ORG_ID": orgId,
        "ORG_CODE": orgCode,
        "MACHINE_NAME": machineName,
        "MACHINE_DESC": machineDesc,
      };
}
