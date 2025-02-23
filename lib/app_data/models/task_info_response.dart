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
  final String? parentTaskName;
  final String? jobOrderNo;
  final String? taskStartDate;
  final String? taskCreactionDate;
  final String? taskCompletionDate;
  final String? taskStatus;
  final String? projectName;
  final int? refNo;

  TaskInfo({
    this.tasksid,
    this.taskName,
    this.taskDept,
    this.parentTaskName,
    this.jobOrderNo,
    this.taskStartDate,
    this.taskCreactionDate,
    this.taskCompletionDate,
    this.taskStatus,
    this.projectName,
    this.refNo,
  });

  TaskInfo copyWith({
    int? tasksid,
    String? taskName,
    String? taskDept,
    String? parentTaskName,
    String? jobOrderNo,
    String? taskStartDate,
    String? taskCreactionDate,
    String? taskCompletionDate,
    String? taskStatus,
    String? projectName,
    int? refNo,
  }) =>
      TaskInfo(
        tasksid: tasksid ?? this.tasksid,
        taskName: taskName ?? this.taskName,
        taskDept: taskDept ?? this.taskDept,
        parentTaskName: parentTaskName ?? this.parentTaskName,
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        taskStartDate: taskStartDate ?? this.taskStartDate,
        taskCreactionDate: taskCreactionDate ?? this.taskCreactionDate,
        taskCompletionDate: taskCompletionDate ?? this.taskCompletionDate,
        taskStatus: taskStatus ?? this.taskStatus,
        projectName: projectName ?? this.projectName,
        refNo: refNo ?? this.refNo,
      );

  factory TaskInfo.fromJson(String str) => TaskInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaskInfo.fromMap(Map<String, dynamic> json) => TaskInfo(
        tasksid: json["TASKSID"],
        taskName: json["TASK_NAME"],
        taskDept: json["TASK_DEPT"],
        parentTaskName: json["PARENT_TASK_NAME"],
        jobOrderNo: json["JOB_ORDER_NO"],
        taskStartDate: json["TASK_START_DATE"],
        taskCreactionDate: json["TASK_CREACTION_DATE"],
        taskCompletionDate: json["TASK_COMPLETION_DATE"],
        taskStatus: json["TASK_STATUS"],
        projectName: json["PROJECT_NAME"],
        refNo: json["REF_NO"],
      );

  Map<String, dynamic> toMap() => {
        "TASKSID": tasksid,
        "TASK_NAME": taskName,
        "TASK_DEPT": taskDept,
        "PARENT_TASK_NAME": parentTaskName,
        "JOB_ORDER_NO": jobOrderNo,
        "TASK_START_DATE": taskStartDate,
        "TASK_CREACTION_DATE": taskCreactionDate,
        "TASK_COMPLETION_DATE": taskCompletionDate,
        "TASK_STATUS": taskStatus,
        "PROJECT_NAME": projectName,
        "REF_NO": refNo,
      };
  @override
  String toString() {
    return taskName ?? "";
  }
}
