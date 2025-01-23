import 'dart:convert';

class BuyerListResponse {
  final int? statusCode;
  final String? message;
  final List<BuyerList>? buyerList;

  BuyerListResponse({
    this.statusCode,
    this.message,
    this.buyerList,
  });

  BuyerListResponse copyWith({
    int? statusCode,
    String? message,
    List<BuyerList>? buyerList,
  }) =>
      BuyerListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        buyerList: buyerList ?? this.buyerList,
      );

  factory BuyerListResponse.fromJson(String str) =>
      BuyerListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BuyerListResponse.fromMap(Map<String, dynamic> json) =>
      BuyerListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        buyerList: json["Buyer_list"] == null
            ? []
            : List<BuyerList>.from(
                json["Buyer_list"]!.map((x) => BuyerList.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "Buyer_list": buyerList == null
            ? []
            : List<dynamic>.from(buyerList!.map((x) => x.toMap())),
      };
}

class BuyerList {
  final String? buyerName;

  BuyerList({
    this.buyerName,
  });

  BuyerList copyWith({
    String? buyerName,
  }) =>
      BuyerList(
        buyerName: buyerName ?? this.buyerName,
      );

  factory BuyerList.fromJson(String str) => BuyerList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BuyerList.fromMap(Map<String, dynamic> json) => BuyerList(
        buyerName: json["BUYER_NAME"],
      );

  Map<String, dynamic> toMap() => {
        "BUYER_NAME": buyerName,
      };
  @override
  String toString() {
    return buyerName ?? "";
  }
}
