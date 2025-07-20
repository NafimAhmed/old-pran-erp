import 'dart:convert';

class QrTypeResponse {
  final int? statusCode;
  final String? message;
  final String? errorMessage;
  final List<Qrtype>? qrtype;

  QrTypeResponse({
    this.statusCode,
    this.message,
    this.errorMessage,
    this.qrtype,
  });

  QrTypeResponse copyWith({
    int? statusCode,
    String? message,
    String? errorMessage,
    List<Qrtype>? qrtype,
  }) => QrTypeResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    errorMessage: errorMessage ?? this.errorMessage,
    qrtype: qrtype ?? this.qrtype,
  );

  factory QrTypeResponse.fromJson(String str) =>
      QrTypeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QrTypeResponse.fromMap(Map<String, dynamic> json) => QrTypeResponse(
    statusCode: json["status_code"],
    message: json["message"],
    errorMessage: json["error_message"],
    qrtype: json["QRTYPE"] == null
        ? []
        : List<Qrtype>.from(json["QRTYPE"]!.map((x) => Qrtype.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "error_message": errorMessage,
    "QRTYPE": qrtype == null
        ? []
        : List<dynamic>.from(qrtype!.map((x) => x.toMap())),
  };
}

class Qrtype {
  final int? id;
  final String? type;

  Qrtype({this.id, this.type});

  Qrtype copyWith({int? id, String? type}) =>
      Qrtype(id: id ?? this.id, type: type ?? this.type);

  factory Qrtype.fromJson(String str) => Qrtype.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Qrtype.fromMap(Map<String, dynamic> json) =>
      Qrtype(id: json["id"], type: json["type"]);

  Map<String, dynamic> toMap() => {"id": id, "type": type};
  @override
  String toString() {
    return '$type';
  }
}
