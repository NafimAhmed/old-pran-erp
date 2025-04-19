import 'dart:convert';

class GrnPurchaseReqListResponse {
  final int? statusCode;
  final String? message;
  final List<GrnPurchaseReqNumber>? purchaseReqList;

  GrnPurchaseReqListResponse({
    this.statusCode,
    this.message,
    this.purchaseReqList,
  });

  GrnPurchaseReqListResponse copyWith({
    int? statusCode,
    String? message,
    List<GrnPurchaseReqNumber>? purchaseReqList,
  }) =>
      GrnPurchaseReqListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        purchaseReqList: purchaseReqList ?? this.purchaseReqList,
      );

  factory GrnPurchaseReqListResponse.fromJson(String str) =>
      GrnPurchaseReqListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnPurchaseReqListResponse.fromMap(Map<String, dynamic> json) =>
      GrnPurchaseReqListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        purchaseReqList: json["purchase_req_list"] == null
            ? []
            : List<GrnPurchaseReqNumber>.from(json["purchase_req_list"]!
                .map((x) => GrnPurchaseReqNumber.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "purchase_req_list": purchaseReqList == null
            ? []
            : List<dynamic>.from(purchaseReqList!.map((x) => x.toMap())),
      };
}

class GrnPurchaseReqNumber {
  final String? purchaseReqNumber;

  GrnPurchaseReqNumber({
    this.purchaseReqNumber,
  });

  GrnPurchaseReqNumber copyWith({
    String? purchaseReqNumber,
  }) =>
      GrnPurchaseReqNumber(
        purchaseReqNumber: purchaseReqNumber ?? this.purchaseReqNumber,
      );

  factory GrnPurchaseReqNumber.fromJson(String str) =>
      GrnPurchaseReqNumber.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnPurchaseReqNumber.fromMap(Map<String, dynamic> json) =>
      GrnPurchaseReqNumber(
        purchaseReqNumber: json["Purchase Req Number"],
      );

  Map<String, dynamic> toMap() => {
        "Purchase Req Number": purchaseReqNumber,
      };
  @override
  String toString() {
    return purchaseReqNumber ?? "";
  }
}
