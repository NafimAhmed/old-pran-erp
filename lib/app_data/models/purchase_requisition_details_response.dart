import 'dart:convert';

class PurchaseRequDtlsResponse {
  final int? statusCode;
  final String? message;
  final String? errmsg;
  final List<PurchaseRequisitionDetail>? purchaseRequisitionDetails;

  PurchaseRequDtlsResponse({
    this.statusCode,
    this.message,
    this.errmsg,
    this.purchaseRequisitionDetails,
  });

  PurchaseRequDtlsResponse copyWith({
    int? statusCode,
    String? message,
    String? errmsg,
    List<PurchaseRequisitionDetail>? purchaseRequisitionDetails,
  }) =>
      PurchaseRequDtlsResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errmsg: errmsg ?? this.errmsg,
        purchaseRequisitionDetails:
            purchaseRequisitionDetails ?? this.purchaseRequisitionDetails,
      );

  factory PurchaseRequDtlsResponse.fromJson(String str) =>
      PurchaseRequDtlsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PurchaseRequDtlsResponse.fromMap(Map<String, dynamic> json) =>
      PurchaseRequDtlsResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errmsg: json["errmsg"],
        purchaseRequisitionDetails: json["purchase_requisition_details"] == null
            ? []
            : List<PurchaseRequisitionDetail>.from(
                json["purchase_requisition_details"]!
                    .map((x) => PurchaseRequisitionDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "errmsg": errmsg,
        "purchase_requisition_details": purchaseRequisitionDetails == null
            ? []
            : List<dynamic>.from(
                purchaseRequisitionDetails!.map((x) => x.toMap())),
      };
}

class PurchaseRequisitionDetail {
  final int? headerId;
  final String? requisitionNo;
  final int? itemId;
  final String? itemName;
  final String? unit;
  final int? qty;

  PurchaseRequisitionDetail({
    this.headerId,
    this.requisitionNo,
    this.itemId,
    this.itemName,
    this.unit,
    this.qty,
  });

  PurchaseRequisitionDetail copyWith({
    int? headerId,
    String? requisitionNo,
    int? itemId,
    String? itemName,
    String? unit,
    int? qty,
  }) =>
      PurchaseRequisitionDetail(
        headerId: headerId ?? this.headerId,
        requisitionNo: requisitionNo ?? this.requisitionNo,
        itemId: itemId ?? this.itemId,
        itemName: itemName ?? this.itemName,
        unit: unit ?? this.unit,
        qty: qty ?? this.qty,
      );

  factory PurchaseRequisitionDetail.fromJson(String str) =>
      PurchaseRequisitionDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PurchaseRequisitionDetail.fromMap(Map<String, dynamic> json) =>
      PurchaseRequisitionDetail(
        headerId: json["HEADER_ID"],
        requisitionNo: json["REQUISITION_NO"],
        itemId: json["ITEM_ID"],
        itemName: json["ITEM_NAME"],
        unit: json["UNIT"],
        qty: json["QTY"],
      );

  Map<String, dynamic> toMap() => {
        "HEADER_ID": headerId,
        "REQUISITION_NO": requisitionNo,
        "ITEM_ID": itemId,
        "ITEM_NAME": itemName,
        "UNIT": unit,
        "QTY": qty,
      };
  Map<String, dynamic> toTabMap() => {
        "Header Id": headerId,
        //"Requisition No": requisitionNo,
        "Item Id": itemId,
        "Item Name": itemName,
        "Unit": unit,
        "Quantity": qty,
        "Action": "Save"
      };
}
