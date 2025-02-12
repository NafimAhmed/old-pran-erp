import 'dart:convert';

class ProjectListResponse {
  final int? statusCode;
  final String? message;
  final List<Project>? projectList;

  ProjectListResponse({
    this.statusCode,
    this.message,
    this.projectList,
  });

  ProjectListResponse copyWith({
    int? statusCode,
    String? message,
    List<Project>? projectList,
  }) =>
      ProjectListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        projectList: projectList ?? this.projectList,
      );

  factory ProjectListResponse.fromJson(String str) =>
      ProjectListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProjectListResponse.fromMap(Map<String, dynamic> json) =>
      ProjectListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        projectList: json["project_list"] == null
            ? []
            : List<Project>.from(
                json["project_list"]!.map((x) => Project.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "project_list": projectList == null
            ? []
            : List<dynamic>.from(projectList!.map((x) => x.toMap())),
      };
}

class Project {
  final int? projectId;
  final String? projectName;
  final String? projectManager;

  Project({
    this.projectId,
    this.projectName,
    this.projectManager,
  });

  Project copyWith({
    int? projectId,
    String? projectName,
    String? projectManager,
  }) =>
      Project(
        projectId: projectId ?? this.projectId,
        projectName: projectName ?? this.projectName,
        projectManager: projectManager ?? this.projectManager,
      );

  factory Project.fromJson(String str) => Project.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Project.fromMap(Map<String, dynamic> json) => Project(
        projectId: json["PROJECT_ID"],
        projectName: json["PROJECT_NAME"],
        projectManager: json["PROJECT_MANAGER"],
      );

  Map<String, dynamic> toMap() => {
        "PROJECT_ID": projectId,
        "PROJECT_NAME": projectName,
        "PROJECT_MANAGER": projectManager,
      };
  @override
  String toString() {
    return projectName ?? "";
  }
}
