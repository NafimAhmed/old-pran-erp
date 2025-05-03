import 'dart:convert';

class SmplQrListResponse {
  final int? statusCode;
  final String? message;
  final List<SampleColQr>? sampleColQr;

  SmplQrListResponse({
    this.statusCode,
    this.message,
    this.sampleColQr,
  });

  SmplQrListResponse copyWith({
    int? statusCode,
    String? message,
    List<SampleColQr>? sampleColQr,
  }) =>
      SmplQrListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        sampleColQr: sampleColQr ?? this.sampleColQr,
      );

  factory SmplQrListResponse.fromJson(String str) =>
      SmplQrListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SmplQrListResponse.fromMap(Map<String, dynamic> json) =>
      SmplQrListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        sampleColQr: json["sample_col_qr"] == null
            ? []
            : List<SampleColQr>.from(
                json["sample_col_qr"]!.map((x) => SampleColQr.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "sample_col_qr": sampleColQr == null
            ? []
            : List<dynamic>.from(sampleColQr!.map((x) => x.toMap())),
      };
}

class SampleColQr {
  final int? id;
  final int? headerId;
  final String? itemName;
  final String? itemCode;
  final int? qty;
  final String? unit;
  final String? picture;

  SampleColQr({
    this.id,
    this.headerId,
    this.itemName,
    this.itemCode,
    this.qty,
    this.unit,
    this.picture,
  });

  SampleColQr copyWith({
    int? id,
    int? headerId,
    String? itemName,
    String? itemCode,
    int? qty,
    String? unit,
    String? picture,
  }) =>
      SampleColQr(
          id: id ?? this.id,
          headerId: headerId ?? this.headerId,
          itemName: itemName ?? this.itemName,
          itemCode: itemCode ?? this.itemCode,
          qty: qty ?? this.qty,
          unit: unit ?? this.unit,
          picture: picture ?? this.picture);

  factory SampleColQr.fromJson(String str) =>
      SampleColQr.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SampleColQr.fromMap(Map<String, dynamic> json) => SampleColQr(
        id: json["ID"],
        headerId: json["HEADER_ID"],
        itemName: json["ITEM_NAME"],
        itemCode: json["ITEM_CODE"],
        qty: json["QTY"],
        unit: json["UNIT"],
        picture: json["PICTURE"],
      );

  Map<String, dynamic> toMap() => {
        "ID": id,
        "HEADER_ID": headerId,
        "ITEM_NAME": itemName,
        "ITEM_CODE": itemCode,
        "QTY": qty,
        "UNIT": unit,
        "PICTURE": picture
      };
}
