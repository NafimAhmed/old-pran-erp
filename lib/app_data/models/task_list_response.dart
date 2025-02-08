import 'dart:convert';

class TaskListResponse {
  final int? statusCode;
  final String? message;
  final List<Task>? allTaskList;

  TaskListResponse({
    this.statusCode,
    this.message,
    this.allTaskList,
  });

  TaskListResponse copyWith({
    int? statusCode,
    String? message,
    List<Task>? allTaskList,
  }) =>
      TaskListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        allTaskList: allTaskList ?? this.allTaskList,
      );

  factory TaskListResponse.fromJson(String str) =>
      TaskListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaskListResponse.fromMap(Map<String, dynamic> json) =>
      TaskListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        allTaskList: json["all_task_list"] == null
            ? []
            : List<Task>.from(
                json["all_task_list"]!.map((x) => Task.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "all_task_list": allTaskList == null
            ? []
            : List<dynamic>.from(allTaskList!.map((x) => x.toMap())),
      };
}

class Task {
  final int? taskNo;
  final String? taskName;
  final String? taskDept;
  final String? sdate;
  final String? tdate;
  final int? pId;
  final String? jobOrderNo;
  final int? tskTp;
  final int? projectId;

  Task({
    this.taskNo,
    this.taskName,
    this.taskDept,
    this.sdate,
    this.tdate,
    this.pId,
    this.jobOrderNo,
    this.tskTp,
    this.projectId,
  });

  Task copyWith({
    int? taskNo,
    String? taskName,
    String? taskDept,
    String? sdate,
    String? tdate,
    int? pId,
    String? jobOrderNo,
    int? tskTp,
    int? projectId,
  }) =>
      Task(
        taskNo: taskNo ?? this.taskNo,
        taskName: taskName ?? this.taskName,
        taskDept: taskDept ?? this.taskDept,
        sdate: sdate ?? this.sdate,
        tdate: tdate ?? this.tdate,
        pId: pId ?? this.pId,
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        tskTp: tskTp ?? this.tskTp,
        projectId: projectId ?? this.projectId,
      );

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        taskNo: json["task_no"],
        taskName: json["task_name"],
        taskDept: json["task_dept"],
        sdate: json["sdate"],
        tdate: json["tdate"],
        pId: json["p_id"],
        jobOrderNo: json["Job_order_no"],
        tskTp: json["tsk_tp"],
        projectId: json["project_id"],
      );

  Map<String, dynamic> toMap() => {
        "task_no": taskNo,
        "task_name": taskName,
        "task_dept": taskDept,
        "sdate": sdate,
        "tdate": tdate,
        "p_id": pId,
        "Job_order_no": jobOrderNo,
        "tsk_tp": tskTp,
        "project_id": projectId,
      };
}
