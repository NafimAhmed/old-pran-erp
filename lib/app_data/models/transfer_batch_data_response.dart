// import 'dart:convert';

// class TransferBatchDataResponse {
//   final List<TransferBatchData>? items;
//   final bool? hasMore;
//   final int? limit;
//   final int? offset;
//   final int? count;
//   final List<Link>? links;

//   TransferBatchDataResponse({
//     this.items,
//     this.hasMore,
//     this.limit,
//     this.offset,
//     this.count,
//     this.links,
//   });

//   TransferBatchDataResponse copyWith({
//     List<TransferBatchData>? items,
//     bool? hasMore,
//     int? limit,
//     int? offset,
//     int? count,
//     List<Link>? links,
//   }) =>
//       TransferBatchDataResponse(
//         items: items ?? this.items,
//         hasMore: hasMore ?? this.hasMore,
//         limit: limit ?? this.limit,
//         offset: offset ?? this.offset,
//         count: count ?? this.count,
//         links: links ?? this.links,
//       );

//   factory TransferBatchDataResponse.fromJson(String str) =>
//       TransferBatchDataResponse.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory TransferBatchDataResponse.fromMap(Map<String, dynamic> json) =>
//       TransferBatchDataResponse(
//         items: json["items"] == null
//             ? []
//             : List<TransferBatchData>.from(
//                 json["items"]!.map((x) => TransferBatchData.fromMap(x))),
//         hasMore: json["hasMore"],
//         limit: json["limit"],
//         offset: json["offset"],
//         count: json["count"],
//         links: json["links"] == null
//             ? []
//             : List<Link>.from(json["links"]!.map((x) => Link.fromMap(x))),
//       );

//   Map<String, dynamic> toMap() => {
//         "items": items == null
//             ? []
//             : List<dynamic>.from(items!.map((x) => x.toMap())),
//         "hasMore": hasMore,
//         "limit": limit,
//         "offset": offset,
//         "count": count,
//         "links": links == null
//             ? []
//             : List<dynamic>.from(links!.map((x) => x.toMap())),
//       };
// }

// class TransferBatchData {
//   final String? organizationCode;
//   final String? organizationName;
//   final String? batchNo;
//   final int? batchId;
//   final int? transactId;
//   final String? itemCode;
//   final int? inventoryItemId;
//   final String? itemName;
//   final num? originalQty;
//   final num? totalQty;
//   final String? rackOrg;
//   final String? rackOrgName;
//   final String? rackSubInv;
//   final String? rackLocator;

//   TransferBatchData({
//     this.organizationCode,
//     this.organizationName,
//     this.batchNo,
//     this.batchId,
//     this.transactId,
//     this.itemCode,
//     this.inventoryItemId,
//     this.itemName,
//     this.originalQty,
//     this.totalQty,
//     this.rackOrg,
//     this.rackOrgName,
//     this.rackSubInv,
//     this.rackLocator,
//   });

//   TransferBatchData copyWith({
//     String? organizationCode,
//     String? organizationName,
//     String? batchNo,
//     int? batchId,
//     int? transactId,
//     String? itemCode,
//     int? inventoryItemId,
//     String? itemName,
//     num? originalQty,
//     num? totalQty,
//     String? rackOrg,
//     String? rackOrgName,
//     String? rackSubInv,
//     String? rackLocator,
//   }) =>
//       TransferBatchData(
//         organizationCode: organizationCode ?? this.organizationCode,
//         organizationName: organizationName ?? this.organizationName,
//         batchNo: batchNo ?? this.batchNo,
//         batchId: batchId ?? this.batchId,
//         transactId: transactId ?? this.transactId,
//         itemCode: itemCode ?? this.itemCode,
//         inventoryItemId: inventoryItemId ?? this.inventoryItemId,
//         itemName: itemName ?? this.itemName,
//         originalQty: originalQty ?? this.originalQty,
//         totalQty: totalQty ?? this.totalQty,
//         rackOrg: rackOrg ?? this.rackOrg,
//         rackOrgName: rackOrgName ?? this.rackOrgName,
//         rackSubInv: rackSubInv ?? this.rackSubInv,
//         rackLocator: rackLocator ?? this.rackLocator,
//       );

//   factory TransferBatchData.fromJson(String str) =>
//       TransferBatchData.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory TransferBatchData.fromMap(Map<String, dynamic> json) =>
//       TransferBatchData(
//         organizationCode: json["organization_code"],
//         organizationName: json["organization_name"],
//         batchNo: json["batch_no"],
//         batchId: json["batch_id"],
//         transactId: json["transact_id"],
//         itemCode: json["item_code"],
//         inventoryItemId: json["inventory_item_id"],
//         itemName: json["item_name"],
//         originalQty: json["original_qty"]?.toDouble(),
//         totalQty: json["total_qty"],
//         rackOrg: json["rack_org"],
//         rackOrgName: json["rack_org_name"],
//         rackSubInv: json["rack_sub_inv"],
//         rackLocator: json["rack_locator"],
//       );

//   Map<String, dynamic> toMap() => {
//         "organization_code": organizationCode,
//         "organization_name": organizationName,
//         "batch_no": batchNo,
//         "batch_id": batchId,
//         "transact_id": transactId,
//         "item_code": itemCode,
//         "inventory_item_id": inventoryItemId,
//         "item_name": itemName,
//         "original_qty": originalQty,
//         "total_qty": totalQty,
//         "rack_org": rackOrg,
//         "rack_org_name": rackOrgName,
//         "rack_sub_inv": rackSubInv,
//         "rack_locator": rackLocator,
//       };
// }

// class Link {
//   final String? rel;
//   final String? href;

//   Link({
//     this.rel,
//     this.href,
//   });

//   Link copyWith({
//     String? rel,
//     String? href,
//   }) =>
//       Link(
//         rel: rel ?? this.rel,
//         href: href ?? this.href,
//       );

//   factory Link.fromJson(String str) => Link.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory Link.fromMap(Map<String, dynamic> json) => Link(
//         rel: json["rel"],
//         href: json["href"],
//       );

//   Map<String, dynamic> toMap() => {
//         "rel": rel,
//         "href": href,
//       };
// }
import 'dart:convert';

class TransferBatchDataResponse {
  final int? statusCode;
  final String? message;
  final List<TransferBatchData>? userBatchtrnData;

  TransferBatchDataResponse({
    this.statusCode,
    this.message,
    this.userBatchtrnData,
  });

  TransferBatchDataResponse copyWith({
    int? statusCode,
    String? message,
    List<TransferBatchData>? userBatchtrnData,
  }) =>
      TransferBatchDataResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        userBatchtrnData: userBatchtrnData ?? this.userBatchtrnData,
      );

  factory TransferBatchDataResponse.fromJson(String str) =>
      TransferBatchDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransferBatchDataResponse.fromMap(Map<String, dynamic> json) =>
      TransferBatchDataResponse(
        statusCode: json["status_code"],
        message: json["message"],
        userBatchtrnData: json["user_batchtrn_data"] == null
            ? []
            : List<TransferBatchData>.from(json["user_batchtrn_data"]!
                .map((x) => TransferBatchData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "user_batchtrn_data": userBatchtrnData == null
            ? []
            : List<dynamic>.from(userBatchtrnData!.map((x) => x.toMap())),
      };
}

class TransferBatchData {
  final String? org;
  final String? orgname;
  final int? batchId;
  final String? batchno;
  final int? transactId;
  final String? itemCode;
  final int? inventoryItemId;
  final String? itemName;
  final int? originalQty;
  final int? totalQty;
  final String? rackOrg;
  final String? rackOrgName;
  final String? rackSubInv;
  final String? rackLocator;
  final String? batchStatus;
  final String? buyerName;
  final String? customerName;
  final String? customerPo;
  final String? jobOrderNo;
  final String? expireDate;
  final int? materialDetailId;

  TransferBatchData({
    this.org,
    this.orgname,
    this.batchId,
    this.batchno,
    this.transactId,
    this.itemCode,
    this.inventoryItemId,
    this.itemName,
    this.originalQty,
    this.totalQty,
    this.rackOrg,
    this.rackOrgName,
    this.rackSubInv,
    this.rackLocator,
    this.batchStatus,
    this.buyerName,
    this.customerName,
    this.customerPo,
    this.jobOrderNo,
    this.expireDate,
    this.materialDetailId,
  });

  TransferBatchData copyWith({
    String? org,
    String? orgname,
    int? batchId,
    String? batchno,
    int? transactId,
    String? itemCode,
    int? inventoryItemId,
    String? itemName,
    int? originalQty,
    int? totalQty,
    String? rackOrg,
    String? rackOrgName,
    String? rackSubInv,
    String? rackLocator,
    String? batchStatus,
    String? buyerName,
    String? customerName,
    String? customerPo,
    String? jobOrderNo,
    String? expireDate,
    int? materialDetailId,
  }) =>
      TransferBatchData(
        org: org ?? this.org,
        orgname: orgname ?? this.orgname,
        batchId: batchId ?? this.batchId,
        batchno: batchno ?? this.batchno,
        transactId: transactId ?? this.transactId,
        itemCode: itemCode ?? this.itemCode,
        inventoryItemId: inventoryItemId ?? this.inventoryItemId,
        itemName: itemName ?? this.itemName,
        originalQty: originalQty ?? this.originalQty,
        totalQty: totalQty ?? this.totalQty,
        rackOrg: rackOrg ?? this.rackOrg,
        rackOrgName: rackOrgName ?? this.rackOrgName,
        rackSubInv: rackSubInv ?? this.rackSubInv,
        rackLocator: rackLocator ?? this.rackLocator,
        batchStatus: batchStatus ?? this.batchStatus,
        buyerName: buyerName ?? this.buyerName,
        customerName: customerName ?? this.customerName,
        customerPo: customerPo ?? this.customerPo,
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        expireDate: expireDate ?? this.expireDate,
        materialDetailId: materialDetailId ?? this.materialDetailId,
      );

  factory TransferBatchData.fromJson(String str) =>
      TransferBatchData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransferBatchData.fromMap(Map<String, dynamic> json) =>
      TransferBatchData(
        org: json["ORG"],
        orgname: json["ORGNAME"],
        batchId: json["batch_id"],
        batchno: json["BATCHNO"],
        transactId: json["transact_id"],
        itemCode: json["item_code"],
        inventoryItemId: json["inventory_item_id"],
        itemName: json["item_name"],
        originalQty: json["original_qty"],
        totalQty: json["TOTAL_QTY"],
        rackOrg: json["RACK_ORG"],
        rackOrgName: json["RACK_ORG_NAME"],
        rackSubInv: json["RACK_SUB_INV"],
        rackLocator: json["RACK_LOCATOR"],
        batchStatus: json["batch_status"],
        buyerName: json["BUYER_NAME"],
        customerName: json["CUSTOMER_NAME"],
        customerPo: json["CUSTOMER_PO"],
        jobOrderNo: json["JOB_ORDER_NO"],
        expireDate: json["EXPIRE_DATE"],
        materialDetailId: json["MATERIAL_DETAIL_ID"],
      );

  Map<String, dynamic> toMap() => {
        "ORG": org,
        "ORGNAME": orgname,
        "batch_id": batchId,
        "BATCHNO": batchno,
        "transact_id": transactId,
        "item_code": itemCode,
        "inventory_item_id": inventoryItemId,
        "item_name": itemName,
        "original_qty": originalQty,
        "TOTAL_QTY": totalQty,
        "RACK_ORG": rackOrg,
        "RACK_ORG_NAME": rackOrgName,
        "RACK_SUB_INV": rackSubInv,
        "RACK_LOCATOR": rackLocator,
        "batch_status": batchStatus,
        "BUYER_NAME": buyerName,
        "CUSTOMER_NAME": customerName,
        "CUSTOMER_PO": customerPo,
        "JOB_ORDER_NO": jobOrderNo,
        "EXPIRE_DATE": expireDate,
        "MATERIAL_DETAIL_ID": materialDetailId,
      };
}
