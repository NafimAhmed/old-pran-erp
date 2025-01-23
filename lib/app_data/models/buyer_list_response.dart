import 'dart:convert';

class BuyerListResponse {
  final int? statusCode;
  final String? message;
  final List<Buyer>? buyerList;

  BuyerListResponse({
    this.statusCode,
    this.message,
    this.buyerList,
  });

  BuyerListResponse copyWith({
    int? statusCode,
    String? message,
    List<Buyer>? buyerList,
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
            : List<Buyer>.from(
                json["Buyer_list"]!.map((x) => Buyer.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "Buyer_list": buyerList == null
            ? []
            : List<dynamic>.from(buyerList!.map((x) => x.toMap())),
      };
}

class Buyer {
  final String? buyerName;

  Buyer({
    this.buyerName,
  });

  Buyer copyWith({
    String? buyerName,
  }) =>
      Buyer(
        buyerName: buyerName ?? this.buyerName,
      );

  factory Buyer.fromJson(String str) => Buyer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Buyer.fromMap(Map<String, dynamic> json) => Buyer(
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
