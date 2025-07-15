import 'dart:convert';

class GrnQrOnHandQtyResponse {
  final int? statusCode;
  final String? message;
  final String? errmsg;
  final GrnQrOnhandQty? grnQrOnhandQty;

  GrnQrOnHandQtyResponse({
    this.statusCode,
    this.message,
    this.errmsg,
    this.grnQrOnhandQty,
  });

  GrnQrOnHandQtyResponse copyWith({
    int? statusCode,
    String? message,
    String? errmsg,
    GrnQrOnhandQty? grnQrOnhandQty,
  }) => GrnQrOnHandQtyResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    errmsg: errmsg ?? this.errmsg,
    grnQrOnhandQty: grnQrOnhandQty ?? this.grnQrOnhandQty,
  );

  factory GrnQrOnHandQtyResponse.fromJson(String str) =>
      GrnQrOnHandQtyResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnQrOnHandQtyResponse.fromMap(Map<String, dynamic> json) =>
      GrnQrOnHandQtyResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errmsg: json["errmsg"],
        grnQrOnhandQty: json["GRN_QR_ONHAND_QTY"] == null
            ? null
            : GrnQrOnhandQty.fromMap(json["GRN_QR_ONHAND_QTY"]),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "errmsg": errmsg,
    "GRN_QR_ONHAND_QTY": grnQrOnhandQty?.toMap(),
  };
}

class GrnQrOnhandQty {
  final num? qrOnHandQty;

  GrnQrOnhandQty({this.qrOnHandQty});

  GrnQrOnhandQty copyWith({num? qrOnHandQty}) =>
      GrnQrOnhandQty(qrOnHandQty: qrOnHandQty ?? this.qrOnHandQty);

  factory GrnQrOnhandQty.fromJson(String str) =>
      GrnQrOnhandQty.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnQrOnhandQty.fromMap(Map<String, dynamic> json) =>
      GrnQrOnhandQty(qrOnHandQty: json["QROnHandQty"]);

  Map<String, dynamic> toMap() => {"QROnHandQty": qrOnHandQty};
}
