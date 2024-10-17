import 'dart:convert';

class TransferBatchDataResponse {
  final List<TransferBatchData>? items;
  final bool? hasMore;
  final int? limit;
  final int? offset;
  final int? count;
  final List<Link>? links;

  TransferBatchDataResponse({
    this.items,
    this.hasMore,
    this.limit,
    this.offset,
    this.count,
    this.links,
  });

  TransferBatchDataResponse copyWith({
    List<TransferBatchData>? items,
    bool? hasMore,
    int? limit,
    int? offset,
    int? count,
    List<Link>? links,
  }) =>
      TransferBatchDataResponse(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        count: count ?? this.count,
        links: links ?? this.links,
      );

  factory TransferBatchDataResponse.fromJson(String str) =>
      TransferBatchDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransferBatchDataResponse.fromMap(Map<String, dynamic> json) =>
      TransferBatchDataResponse(
        items: json["items"] == null
            ? []
            : List<TransferBatchData>.from(
                json["items"]!.map((x) => TransferBatchData.fromMap(x))),
        hasMore: json["hasMore"],
        limit: json["limit"],
        offset: json["offset"],
        count: json["count"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toMap())),
        "hasMore": hasMore,
        "limit": limit,
        "offset": offset,
        "count": count,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toMap())),
      };
}

class TransferBatchData {
  final String? organizationCode;
  final String? organizationName;
  final String? batchNo;
  final int? batchId;
  final String? itemCode;
  final int? inventoryItemId;
  final String? itemName;
  final double? originalQty;
  final int? totalQty;
  final String? rackOrg;
  final String? rackOrgName;
  final String? rackSubInv;
  final String? rackLocator;

  TransferBatchData({
    this.organizationCode,
    this.organizationName,
    this.batchNo,
    this.batchId,
    this.itemCode,
    this.inventoryItemId,
    this.itemName,
    this.originalQty,
    this.totalQty,
    this.rackOrg,
    this.rackOrgName,
    this.rackSubInv,
    this.rackLocator,
  });

  TransferBatchData copyWith({
    String? organizationCode,
    String? organizationName,
    String? batchNo,
    int? batchId,
    String? itemCode,
    int? inventoryItemId,
    String? itemName,
    double? originalQty,
    int? totalQty,
    String? rackOrg,
    String? rackOrgName,
    String? rackSubInv,
    String? rackLocator,
  }) =>
      TransferBatchData(
        organizationCode: organizationCode ?? this.organizationCode,
        organizationName: organizationName ?? this.organizationName,
        batchNo: batchNo ?? this.batchNo,
        batchId: batchId ?? this.batchId,
        itemCode: itemCode ?? this.itemCode,
        inventoryItemId: inventoryItemId ?? this.inventoryItemId,
        itemName: itemName ?? this.itemName,
        originalQty: originalQty ?? this.originalQty,
        totalQty: totalQty ?? this.totalQty,
        rackOrg: rackOrg ?? this.rackOrg,
        rackOrgName: rackOrgName ?? this.rackOrgName,
        rackSubInv: rackSubInv ?? this.rackSubInv,
        rackLocator: rackLocator ?? this.rackLocator,
      );

  factory TransferBatchData.fromJson(String str) =>
      TransferBatchData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransferBatchData.fromMap(Map<String, dynamic> json) =>
      TransferBatchData(
        organizationCode: json["organization_code"],
        organizationName: json["organization_name"],
        batchNo: json["batch_no"],
        batchId: json["batch_id"],
        itemCode: json["item_code"],
        inventoryItemId: json["inventory_item_id"],
        itemName: json["item_name"],
        originalQty: json["original_qty"]?.toDouble(),
        totalQty: json["total_qty"],
        rackOrg: json["rack_org"],
        rackOrgName: json["rack_org_name"],
        rackSubInv: json["rack_sub_inv"],
        rackLocator: json["rack_locator"],
      );

  Map<String, dynamic> toMap() => {
        "organization_code": organizationCode,
        "organization_name": organizationName,
        "batch_no": batchNo,
        "batch_id": batchId,
        "item_code": itemCode,
        "inventory_item_id": inventoryItemId,
        "item_name": itemName,
        "original_qty": originalQty,
        "total_qty": totalQty,
        "rack_org": rackOrg,
        "rack_org_name": rackOrgName,
        "rack_sub_inv": rackSubInv,
        "rack_locator": rackLocator,
      };
}

class Link {
  final String? rel;
  final String? href;

  Link({
    this.rel,
    this.href,
  });

  Link copyWith({
    String? rel,
    String? href,
  }) =>
      Link(
        rel: rel ?? this.rel,
        href: href ?? this.href,
      );

  factory Link.fromJson(String str) => Link.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Link.fromMap(Map<String, dynamic> json) => Link(
        rel: json["rel"],
        href: json["href"],
      );

  Map<String, dynamic> toMap() => {
        "rel": rel,
        "href": href,
      };
}
