import 'dart:convert';

class DepartmentListResponse {
  final int? statusCode;
  final String? message;
  final List<Department>? deptList;

  DepartmentListResponse({
    this.statusCode,
    this.message,
    this.deptList,
  });

  DepartmentListResponse copyWith({
    int? statusCode,
    String? message,
    List<Department>? deptList,
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
            : List<Department>.from(
                json["Dept_list"]!.map((x) => Department.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "Dept_list": deptList == null
            ? []
            : List<dynamic>.from(deptList!.map((x) => x.toMap())),
      };
}

class Department {
  final String? taskDept;

  Department({
    this.taskDept,
  });

  Department copyWith({
    String? taskDept,
  }) =>
      Department(
        taskDept: taskDept ?? this.taskDept,
      );

  factory Department.fromJson(String str) =>
      Department.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Department.fromMap(Map<String, dynamic> json) => Department(
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
