import 'dart:convert';

class DepartmentListResponse {
  final int? statusCode;
  final String? message;
  final List<DeptList>? deptList;

  DepartmentListResponse({
    this.statusCode,
    this.message,
    this.deptList,
  });

  DepartmentListResponse copyWith({
    int? statusCode,
    String? message,
    List<DeptList>? deptList,
  }) =>
      DepartmentListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        deptList: deptList ?? this.deptList,
      );

  factory DepartmentListResponse.fromJson(String str) =>
      DepartmentListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DepartmentListResponse.fromMap(Map<String, dynamic> json) =>
      DepartmentListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        deptList: json["Dept_list"] == null
            ? []
            : List<DeptList>.from(
                json["Dept_list"]!.map((x) => DeptList.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "Dept_list": deptList == null
            ? []
            : List<dynamic>.from(deptList!.map((x) => x.toMap())),
      };
}

class DeptList {
  final String? taskDept;

  DeptList({
    this.taskDept,
  });

  DeptList copyWith({
    String? taskDept,
  }) =>
      DeptList(
        taskDept: taskDept ?? this.taskDept,
      );

  factory DeptList.fromJson(String str) => DeptList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeptList.fromMap(Map<String, dynamic> json) => DeptList(
        taskDept: json["TASK_DEPT"],
      );

  Map<String, dynamic> toMap() => {
        "TASK_DEPT": taskDept,
      };
  @override
  String toString() {
    return taskDept ?? "";
  }
}
