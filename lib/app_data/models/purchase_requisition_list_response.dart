import 'dart:convert';

class PurchaseReqListResponse {
  final int? statusCode;
  final String? message;
  final String? errmsg;
  final List<PurchaseRequisition>? purchaseRequisition;

  PurchaseReqListResponse({
    this.statusCode,
    this.message,
    this.errmsg,
    this.purchaseRequisition,
  });

  PurchaseReqListResponse copyWith({
    int? statusCode,
    String? message,
    String? errmsg,
    List<PurchaseRequisition>? purchaseRequisition,
  }) =>
      PurchaseReqListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        purchaseRequisition: purchaseRequisition ?? this.purchaseRequisition,
      );

  factory PurchaseReqListResponse.fromJson(String str) =>
      PurchaseReqListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PurchaseReqListResponse.fromMap(Map<String, dynamic> json) =>
      PurchaseReqListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errmsg: json['errmsg'],
        purchaseRequisition: json["purchase_requisition"] == null
            ? []
            : List<PurchaseRequisition>.from(json["purchase_requisition"]!
                .map((x) => PurchaseRequisition.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "errmsg": errmsg,
        "purchase_requisition": purchaseRequisition == null
            ? []
            : List<dynamic>.from(purchaseRequisition!.map((x) => x.toMap())),
      };
}

class PurchaseRequisition {
  final int? hdrId;
  final String? orgCode;
  final String? orgName;
  final String? transactionTypeName;
  final String? requisitionNo;

  PurchaseRequisition({
    this.hdrId,
    this.orgCode,
    this.orgName,
    this.transactionTypeName,
    this.requisitionNo,
  });

  PurchaseRequisition copyWith({
    int? hdrId,
    String? orgCode,
    String? orgName,
    String? transactionTypeName,
    String? requisitionNo,
  }) =>
      PurchaseRequisition(
        hdrId: hdrId ?? this.hdrId,
        orgCode: orgCode ?? this.orgCode,
        orgName: orgName ?? this.orgName,
        transactionTypeName: transactionTypeName ?? this.transactionTypeName,
        requisitionNo: requisitionNo ?? this.requisitionNo,
      );

  factory PurchaseRequisition.fromJson(String str) =>
      PurchaseRequisition.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PurchaseRequisition.fromMap(Map<String, dynamic> json) =>
      PurchaseRequisition(
        hdrId: json["HDR_ID"],
        orgCode: json["ORG_CODE"],
        orgName: json["ORG_NAME"],
        transactionTypeName: json["TRANSACTION_TYPE_NAME"],
        requisitionNo: json["REQUISITION_NO"],
      );

  Map<String, dynamic> toMap() => {
        "HDR_ID": hdrId,
        "ORG_CODE": orgCode,
        "ORG_NAME": orgName,
        "TRANSACTION_TYPE_NAME": transactionTypeName,
        "REQUISITION_NO": requisitionNo,
      };
}
