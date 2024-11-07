import 'dart:convert';

class GenericResponse {
  final int? statusCode;
  final String? message;

  GenericResponse({
    this.statusCode,
    this.message,
  });

  GenericResponse copyWith({
    int? statusCode,
    String? message,
  }) =>
      GenericResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
      );

  factory GenericResponse.fromJson(String str) =>
      GenericResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GenericResponse.fromMap(Map<String, dynamic> json) => GenericResponse(
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
      };
}
