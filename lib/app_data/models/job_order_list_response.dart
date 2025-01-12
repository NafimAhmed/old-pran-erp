import 'dart:convert';

class JobOrderListResponse {
  final int? statusCode;
  final String? message;
  final List<JoInfo>? taskJoInfo;

  JobOrderListResponse({
    this.statusCode,
    this.message,
    this.taskJoInfo,
  });

  JobOrderListResponse copyWith({
    int? statusCode,
    String? message,
    List<JoInfo>? taskJoInfo,
  }) =>
      JobOrderListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        taskJoInfo: taskJoInfo ?? this.taskJoInfo,
      );

  factory JobOrderListResponse.fromJson(String str) =>
      JobOrderListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobOrderListResponse.fromMap(Map<String, dynamic> json) =>
      JobOrderListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        taskJoInfo: json["task_JO_info"] == null
            ? []
            : List<JoInfo>.from(
                json["task_JO_info"]!.map((x) => JoInfo.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "task_JO_info": taskJoInfo == null
            ? []
            : List<dynamic>.from(taskJoInfo!.map((x) => x.toMap())),
      };
}

class JoInfo {
  final String? jobOrderNo;
  final String? processStatus;

  JoInfo({
    this.jobOrderNo,
    this.processStatus,
  });

  JoInfo copyWith({
    String? jobOrderNo,
    String? processStatus,
  }) =>
      JoInfo(
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        processStatus: processStatus ?? this.processStatus,
      );

  factory JoInfo.fromJson(String str) => JoInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JoInfo.fromMap(Map<String, dynamic> json) => JoInfo(
        jobOrderNo: json["JOB_ORDER_NO"],
        processStatus: json["PROCESS_STATUS"],
      );

  Map<String, dynamic> toMap() => {
        "JOB_ORDER_NO": jobOrderNo,
        "PROCESS_STATUS": processStatus,
      };
  @override
  String toString() {
    return jobOrderNo ?? "";
  }
}
