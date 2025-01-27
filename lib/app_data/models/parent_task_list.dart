import 'dart:convert';

class ParentTaskListResponse {
  final int? statusCode;
  final String? message;
  final List<ParentTask>? parentTaskList;

  ParentTaskListResponse({
    this.statusCode,
    this.message,
    this.parentTaskList,
  });

  ParentTaskListResponse copyWith({
    int? statusCode,
    String? message,
    List<ParentTask>? parentTaskList,
  }) =>
      ParentTaskListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        parentTaskList: parentTaskList ?? this.parentTaskList,
      );

  factory ParentTaskListResponse.fromJson(String str) =>
      ParentTaskListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ParentTaskListResponse.fromMap(Map<String, dynamic> json) =>
      ParentTaskListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        parentTaskList: json["parent_task_list"] == null
            ? []
            : List<ParentTask>.from(
                json["parent_task_list"]!.map((x) => ParentTask.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "parent_task_list": parentTaskList == null
            ? []
            : List<dynamic>.from(parentTaskList!.map((x) => x.toMap())),
      };
}

class ParentTask {
  final int? taskId;
  final String? taskName;

  ParentTask({
    this.taskId,
    this.taskName,
  });

  ParentTask copyWith({
    int? taskId,
    String? taskName,
  }) =>
      ParentTask(
        taskId: taskId ?? this.taskId,
        taskName: taskName ?? this.taskName,
      );

  factory ParentTask.fromJson(String str) =>
      ParentTask.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ParentTask.fromMap(Map<String, dynamic> json) => ParentTask(
        taskId: json["TASK_ID"],
        taskName: json["TASK_NAME"],
      );

  Map<String, dynamic> toMap() => {
        "TASK_ID": taskId,
        "TASK_NAME": taskName,
      };
  @override
  String toString() {
    return taskName ?? "";
  }
}
