import 'dart:convert';

class GenericResponse {
  final bool? success;
  final String? warning;
  final String? message;

  GenericResponse({
    this.success,
    this.warning,
    this.message,
  });

  GenericResponse copyWith({
    bool? success,
    String? warning,
    String? message,
  }) =>
      GenericResponse(
        success: success ?? this.success,
        warning: warning ?? this.warning,
        message: message ?? this.message,
      );

  factory GenericResponse.fromJson(String str) =>
      GenericResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GenericResponse.fromMap(Map<String, dynamic> json) => GenericResponse(
        success: json["success"],
        warning: json["warning"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "warning": warning,
        "message": message,
      };
}
