import 'dart:convert';

class ItemStockListResponse {
  final int? statusCode;
  final String? message;
  final String? errmsg;
  final List<ItemStock>? itemStock;

  ItemStockListResponse({
    this.statusCode,
    this.message,
    this.errmsg,
    this.itemStock,
  });

  ItemStockListResponse copyWith({
    int? statusCode,
    String? message,
    String? errmsg,
    List<ItemStock>? itemStock,
  }) => ItemStockListResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    errmsg: errmsg ?? this.errmsg,
    itemStock: itemStock ?? this.itemStock,
  );

  factory ItemStockListResponse.fromJson(String str) =>
      ItemStockListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ItemStockListResponse.fromMap(Map<String, dynamic> json) =>
      ItemStockListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errmsg: json["errmsg"],
        itemStock: json["itemStock"] == null
            ? []
            : List<ItemStock>.from(
                json["itemStock"]!.map((x) => ItemStock.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "errmsg": errmsg,
    "itemStock": itemStock == null
        ? []
        : List<dynamic>.from(itemStock!.map((x) => x.toMap())),
  };
}

class ItemStock {
  final int? inventoryItemId;
  final String? itemCode;
  final String? itemName;
  final int? locatorId;
  final String? subinventoryCode;
  final String? locatorDesc;
  final double? qty;

  ItemStock({
    this.inventoryItemId,
    this.itemCode,
    this.itemName,
    this.locatorId,
    this.subinventoryCode,
    this.locatorDesc,
    this.qty,
  });

  ItemStock copyWith({
    int? inventoryItemId,
    String? itemCode,
    String? itemName,
    int? secondaryLocator,
    String? subinventoryCode,
    String? locatorDesc,
    double? qty,
  }) => ItemStock(
    inventoryItemId: inventoryItemId ?? this.inventoryItemId,
    itemCode: itemCode ?? this.itemCode,
    itemName: itemName ?? this.itemName,
    locatorId: secondaryLocator ?? locatorId,
    subinventoryCode: subinventoryCode ?? this.subinventoryCode,
    locatorDesc: locatorDesc ?? this.locatorDesc,
    qty: qty ?? this.qty,
  );

  factory ItemStock.fromJson(String str) => ItemStock.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ItemStock.fromMap(Map<String, dynamic> json) => ItemStock(
    inventoryItemId: json["INVENTORY_ITEM_ID"],
    itemCode: json["Item_Code"],
    itemName: json["Item_Name"],
    locatorId: json["Locator_Id"],
    subinventoryCode: json["SUBINVENTORY_CODE"],
    locatorDesc: json["Locator_desc"],
    qty: json["qty"]?.toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "INVENTORY_ITEM_ID": inventoryItemId,
    "Item_Code": itemCode,
    "Item_Name": itemName,
    "Locator_Id": locatorId,
    "SUBINVENTORY_CODE": subinventoryCode,
    "Locator_desc": locatorDesc,
    "qty": qty,
  };
  @override
  String toString() {
    return ' $itemCode-$itemName-$subinventoryCode';
  }
}
