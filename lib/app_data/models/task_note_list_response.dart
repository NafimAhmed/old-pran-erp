import 'dart:convert';

class TaskNoteListResponse {
  final int? statusCode;
  final String? message;
  final List<TaskNote>? taskNoteList;

  TaskNoteListResponse({
    this.statusCode,
    this.message,
    this.taskNoteList,
  });

  TaskNoteListResponse copyWith({
    int? statusCode,
    String? message,
    List<TaskNote>? taskNoteList,
  }) =>
      TaskNoteListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        taskNoteList: taskNoteList ?? this.taskNoteList,
      );

  factory TaskNoteListResponse.fromJson(String str) =>
      TaskNoteListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaskNoteListResponse.fromMap(Map<String, dynamic> json) =>
      TaskNoteListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        taskNoteList: json["task_note_list"] == null
            ? []
            : List<TaskNote>.from(
                json["task_note_list"]!.map((x) => TaskNote.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "task_note_list": taskNoteList == null
            ? []
            : List<dynamic>.from(taskNoteList!.map((x) => x.toMap())),
      };
}

class TaskNote {
  final int? taskId;
  final int? noteId;
  final String? noteContent;
  final String? createdBy;
  final String? createdAt;

  TaskNote({
    this.taskId,
    this.noteId,
    this.noteContent,
    this.createdBy,
    this.createdAt,
  });

  TaskNote copyWith({
    int? taskId,
    int? noteId,
    String? noteContent,
    String? createdBy,
    String? createdAt,
  }) =>
      TaskNote(
        taskId: taskId ?? this.taskId,
        noteId: noteId ?? this.noteId,
        noteContent: noteContent ?? this.noteContent,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
      );

  factory TaskNote.fromJson(String str) => TaskNote.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaskNote.fromMap(Map<String, dynamic> json) => TaskNote(
        taskId: json["TASK_ID"],
        noteId: json["NOTE_ID"],
        noteContent: json["NOTE_CONTENT"],
        createdBy: json["CREATED_BY"],
        createdAt: json["CREATED_AT"],
      );

  Map<String, dynamic> toMap() => {
        "TASK_ID": taskId,
        "NOTE_ID": noteId,
        "NOTE_CONTENT": noteContent,
        "CREATED_BY": createdBy,
        "CREATED_AT": createdAt,
      };
}
