import 'dart:convert';

class GenericResponse {
  final int? statusCode;
  final String? message;
  final String? info;
  final String? errorMessage;
  GenericResponse(
      {this.statusCode, this.message, this.errorMessage, this.info});

  GenericResponse copyWith({
    int? statusCode,
    String? message,
    String? errorMessage,
  }) =>
      GenericResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  factory GenericResponse.fromJson(String str) =>
      GenericResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GenericResponse.fromMap(Map<String, dynamic> json) => GenericResponse(
        statusCode: json["status_code"],
        message: json["message"],
        info: json['info'],
        errorMessage: json["error_message"],
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "info": info,
        "error_message": errorMessage,
      };
}
