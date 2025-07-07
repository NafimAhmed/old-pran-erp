import 'dart:convert';

class ItemStockListResponse {
  final int? statusCode;
  final String? message;
  final List<ItemStock>? itemStock;

  ItemStockListResponse({this.statusCode, this.message, this.itemStock});

  ItemStockListResponse copyWith({
    int? statusCode,
    String? message,
    List<ItemStock>? itemStock,
  }) => ItemStockListResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    itemStock: itemStock ?? this.itemStock,
  );

  factory ItemStockListResponse.fromJson(String str) =>
      ItemStockListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ItemStockListResponse.fromMap(Map<String, dynamic> json) =>
      ItemStockListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        itemStock: json["itemStock"] == null
            ? []
            : List<ItemStock>.from(
                json["itemStock"]!.map((x) => ItemStock.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "itemStock": itemStock == null
        ? []
        : List<dynamic>.from(itemStock!.map((x) => x.toMap())),
  };
}

class ItemStock {
  final int? inventoryItemId;
  final String? description;
  final int? secondaryLocator;
  final String? subinventoryCode;
  final double? qty;

  ItemStock({
    this.inventoryItemId,
    this.description,
    this.secondaryLocator,
    this.subinventoryCode,
    this.qty,
  });

  ItemStock copyWith({
    int? inventoryItemId,
    String? description,
    int? secondaryLocator,
    String? subinventoryCode,
    double? qty,
  }) => ItemStock(
    inventoryItemId: inventoryItemId ?? this.inventoryItemId,
    description: description ?? this.description,
    secondaryLocator: secondaryLocator ?? this.secondaryLocator,
    subinventoryCode: subinventoryCode ?? this.subinventoryCode,
    qty: qty ?? this.qty,
  );

  factory ItemStock.fromJson(String str) => ItemStock.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ItemStock.fromMap(Map<String, dynamic> json) => ItemStock(
    inventoryItemId: json["INVENTORY_ITEM_ID"],
    description: json["DESCRIPTION"],
    secondaryLocator: json["SECONDARY_LOCATOR"],
    subinventoryCode: json["SUBINVENTORY_CODE"],
    qty: json["qty"]?.toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "INVENTORY_ITEM_ID": inventoryItemId,
    "DESCRIPTION": description,
    "SECONDARY_LOCATOR": secondaryLocator,
    "SUBINVENTORY_CODE": subinventoryCode,
    "qty": qty,
  };
}
