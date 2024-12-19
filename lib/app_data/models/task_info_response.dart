import 'dart:convert';

class TaskInfoResponse {
  final int? statusCode;
  final String? message;
  final List<TaskInfo>? taskInfo;

  TaskInfoResponse({
    this.statusCode,
    this.message,
    this.taskInfo,
  });

  TaskInfoResponse copyWith({
    int? statusCode,
    String? message,
    List<TaskInfo>? taskInfo,
  }) =>
      TaskInfoResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        taskInfo: taskInfo ?? this.taskInfo,
      );

  factory TaskInfoResponse.fromJson(String str) =>
      TaskInfoResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaskInfoResponse.fromMap(Map<String, dynamic> json) =>
      TaskInfoResponse(
        statusCode: json["status_code"],
        message: json["message"],
        taskInfo: json["task_info"] == null
            ? []
            : List<TaskInfo>.from(
                json["task_info"]!.map((x) => TaskInfo.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "task_info": taskInfo == null
            ? []
            : List<dynamic>.from(taskInfo!.map((x) => x.toMap())),
      };
}

class TaskInfo {
  final int? tasksid;
  final String? taskName;
  final String? taskDept;
  final String? custPoNo;
  final String? invoiceNo;
  final String? jobOrderNo;
  final String? taskStartDate;
  final String? taskCreactionDate;
  final String? taskCompletionDate;
  final String? taskStatus;

  TaskInfo({
    this.tasksid,
    this.taskName,
    this.taskDept,
    this.custPoNo,
    this.invoiceNo,
    this.jobOrderNo,
    this.taskStartDate,
    this.taskCreactionDate,
    this.taskCompletionDate,
    this.taskStatus,
  });

  TaskInfo copyWith({
    int? tasksid,
    String? taskName,
    String? taskDept,
    String? custPoNo,
    String? invoiceNo,
    String? jobOrderNo,
    String? taskStartDate,
    String? taskCreactionDate,
    String? taskCompletionDate,
    String? taskStatus,
  }) =>
      TaskInfo(
        tasksid: tasksid ?? this.tasksid,
        taskName: taskName ?? this.taskName,
        taskDept: taskDept ?? this.taskDept,
        custPoNo: custPoNo ?? this.custPoNo,
        invoiceNo: invoiceNo ?? this.invoiceNo,
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        taskStartDate: taskStartDate ?? this.taskStartDate,
        taskCreactionDate: taskCreactionDate ?? this.taskCreactionDate,
        taskCompletionDate: taskCompletionDate ?? this.taskCompletionDate,
        taskStatus: taskStatus ?? this.taskStatus,
      );

  factory TaskInfo.fromJson(String str) => TaskInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaskInfo.fromMap(Map<String, dynamic> json) => TaskInfo(
        tasksid: json["TASKSID"],
        taskName: json["TASK_NAME"],
        taskDept: json["TASK_DEPT"],
        custPoNo: json["CUST_PO_NO"],
        invoiceNo: json["INVOICE_NO"],
        jobOrderNo: json["JOB_ORDER_NO"],
        taskStartDate: json["TASK_START_DATE"],
        taskCreactionDate: json["TASK_CREACTION_DATE"],
        taskCompletionDate: json["TASK_COMPLETION_DATE"],
        taskStatus: json["TASK_STATUS"],
      );

  Map<String, dynamic> toMap() => {
        "TASKSID": tasksid,
        "TASK_NAME": taskName,
        "TASK_DEPT": taskDept,
        "CUST_PO_NO": custPoNo,
        "INVOICE_NO": invoiceNo,
        "JOB_ORDER_NO": jobOrderNo,
        "TASK_START_DATE": taskStartDate,
        "TASK_CREACTION_DATE": taskCreactionDate,
        "TASK_COMPLETION_DATE": taskCompletionDate,
        "TASK_STATUS": taskStatus,
      };
  @override
  String toString() {
    return taskName ?? "";
  }
}
