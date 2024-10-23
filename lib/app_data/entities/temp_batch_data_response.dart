import 'dart:convert';

class TempBatchDataResponse {
  final List<TempBatchData>? items;
  final bool? hasMore;
  final int? limit;
  final int? offset;
  final int? count;
  final List<Link>? links;

  TempBatchDataResponse({
    this.items,
    this.hasMore,
    this.limit,
    this.offset,
    this.count,
    this.links,
  });

  TempBatchDataResponse copyWith({
    List<TempBatchData>? items,
    bool? hasMore,
    int? limit,
    int? offset,
    int? count,
    List<Link>? links,
  }) =>
      TempBatchDataResponse(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        count: count ?? this.count,
        links: links ?? this.links,
      );

  factory TempBatchDataResponse.fromJson(String str) =>
      TempBatchDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TempBatchDataResponse.fromMap(Map<String, dynamic> json) =>
      TempBatchDataResponse(
        items: json["items"] == null
            ? []
            : List<TempBatchData>.from(
                json["items"]!.map((x) => TempBatchData.fromMap(x))),
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

class TempBatchData {
  final String? organizationCode;
  final String? organizationName;
  final String? batchNo;
  final String? itemCode;
  final String? itemName;
  final num? originalQty;
  final int? totalQty;

  TempBatchData({
    this.organizationCode,
    this.organizationName,
    this.batchNo,
    this.itemCode,
    this.itemName,
    this.originalQty,
    this.totalQty,
  });

  TempBatchData copyWith({
    String? organizationCode,
    String? organizationName,
    String? batchNo,
    String? itemCode,
    String? itemName,
    double? originalQty,
    int? totalQty,
  }) =>
      TempBatchData(
        organizationCode: organizationCode ?? this.organizationCode,
        organizationName: organizationName ?? this.organizationName,
        batchNo: batchNo ?? this.batchNo,
        itemCode: itemCode ?? this.itemCode,
        itemName: itemName ?? this.itemName,
        originalQty: originalQty ?? this.originalQty,
        totalQty: totalQty ?? this.totalQty,
      );

  factory TempBatchData.fromJson(String str) =>
      TempBatchData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TempBatchData.fromMap(Map<String, dynamic> json) => TempBatchData(
        organizationCode: json["organization_code"],
        organizationName: json["organization_name"],
        batchNo: json["batch_no"],
        itemCode: json["item_code"],
        itemName: json["item_name"],
        originalQty: json["original_qty"]?.toDouble(),
        totalQty: json["total_qty"],
      );

  Map<String, dynamic> toMap() => {
        "organization_code": organizationCode,
        "organization_name": organizationName,
        "batch_no": batchNo,
        "item_code": itemCode,
        "item_name": itemName,
        "original_qty": originalQty,
        "total_qty": totalQty,
      };
  Map<String, dynamic> toTabMap() => {
        // "organization_code": organizationCode,
        // "organization_name": organizationName,
        "Batch No": batchNo,
        "Item Code": itemCode,
        "Item Name": itemName,
        "Original Qty": originalQty,
        "Total Qty": totalQty,
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
