import 'dart:convert';

class ImageUploadResponse {
  final String? fileName;
  final String? status;
  final bool? upstatus;

  ImageUploadResponse({
    this.fileName,
    this.status,
    this.upstatus,
  });

  ImageUploadResponse copyWith({
    String? fileName,
    String? status,
    bool? upstatus,
  }) =>
      ImageUploadResponse(
        fileName: fileName ?? this.fileName,
        status: status ?? this.status,
        upstatus: upstatus ?? this.upstatus,
      );

  factory ImageUploadResponse.fromJson(String str) =>
      ImageUploadResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ImageUploadResponse.fromMap(Map<String, dynamic> json) =>
      ImageUploadResponse(
        fileName: json["FileName"],
        status: json["status"],
        upstatus: json["upstatus"],
      );

  Map<String, dynamic> toMap() => {
        "FileName": fileName,
        "status": status,
        "upstatus": upstatus,
      };
}
