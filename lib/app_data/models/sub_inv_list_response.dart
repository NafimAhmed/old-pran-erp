import 'dart:convert';

class SubInvListResponse {
  final int? statusCode;
  final String? message;
  final String? errorMessage;
  final List<SubInventory>? subInventory;

  SubInvListResponse({
    this.statusCode,
    this.message,
    this.errorMessage,
    this.subInventory,
  });

  SubInvListResponse copyWith({
    int? statusCode,
    String? message,
    String? errorMessage,
    List<SubInventory>? subInventory,
  }) => SubInvListResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    errorMessage: errorMessage ?? this.errorMessage,
    subInventory: subInventory ?? this.subInventory,
  );

  factory SubInvListResponse.fromJson(String str) =>
      SubInvListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubInvListResponse.fromMap(Map<String, dynamic> json) =>
      SubInvListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errorMessage: json["error_message"],
        subInventory: json["subInventory"] == null
            ? []
            : List<SubInventory>.from(
                json["subInventory"]!.map((x) => SubInventory.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "error_message": errorMessage,
    "subInventory": subInventory == null
        ? []
        : List<dynamic>.from(subInventory!.map((x) => x.toMap())),
  };
}

class SubInventory {
  final String? secondaryInventory;
  final int? inventoryItemId;
  final int? organizationId;

  SubInventory({
    this.secondaryInventory,
    this.inventoryItemId,
    this.organizationId,
  });

  SubInventory copyWith({
    String? secondaryInventory,
    int? inventoryItemId,
    int? organizationId,
  }) => SubInventory(
    secondaryInventory: secondaryInventory ?? this.secondaryInventory,
    inventoryItemId: inventoryItemId ?? this.inventoryItemId,
    organizationId: organizationId ?? this.organizationId,
  );

  factory SubInventory.fromJson(String str) =>
      SubInventory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubInventory.fromMap(Map<String, dynamic> json) => SubInventory(
    secondaryInventory: json["SECONDARY_INVENTORY"],
    inventoryItemId: json["INVENTORY_ITEM_ID"],
    organizationId: json["ORGANIZATION_ID"],
  );

  Map<String, dynamic> toMap() => {
    "SECONDARY_INVENTORY": secondaryInventory,
    "INVENTORY_ITEM_ID": inventoryItemId,
    "ORGANIZATION_ID": organizationId,
  };
  @override
  toString() {
    return '$secondaryInventory';
  }
}
