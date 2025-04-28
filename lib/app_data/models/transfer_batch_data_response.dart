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
