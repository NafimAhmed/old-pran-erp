import 'dart:convert';

class GrnPoListResponse {
  final int? statusCode;
  final String? message;
  final List<GrnPO>? poList;

  GrnPoListResponse({this.statusCode, this.message, this.poList});

  GrnPoListResponse copyWith({
    int? statusCode,
    String? message,
    List<GrnPO>? poList,
  }) => GrnPoListResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    poList: poList ?? this.poList,
  );

  factory GrnPoListResponse.fromJson(String str) =>
      GrnPoListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnPoListResponse.fromMap(Map<String, dynamic> json) =>
      GrnPoListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        poList: json["PO_list"] == null
            ? []
            : List<GrnPO>.from(json["PO_list"]!.map((x) => GrnPO.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "PO_list": poList == null
        ? []
        : List<dynamic>.from(poList!.map((x) => x.toMap())),
  };
}

class GrnPO {
  final String? operationUnit;
  final String? requisitionNumber;
  final String? jobOrderNo;
  final String? reqNo;
  final int? reqLineNo;
  final String? poNo;
  final int? poHeaderId;
  final int? itemId;
  final String? itemDescription;
  final num? quantity;
  final String? unitMeasLookupCode;
  final String? needByDate;

  GrnPO({
    this.operationUnit,
    this.requisitionNumber,
    this.jobOrderNo,
    this.reqNo,
    this.reqLineNo,
    this.poNo,
    this.poHeaderId,
    this.itemId,
    this.itemDescription,
    this.quantity,
    this.unitMeasLookupCode,
    this.needByDate,
  });

  GrnPO copyWith({
    String? operationUnit,
    String? requisitionNumber,
    String? jobOrderNo,
    String? reqNo,
    int? reqLineNo,
    String? poNo,
    int? poHeaderId,
    int? itemId,
    String? itemDescription,
    double? quantity,
    String? unitMeasLookupCode,
    String? needByDate,
  }) => GrnPO(
    operationUnit: operationUnit ?? this.operationUnit,
    requisitionNumber: requisitionNumber ?? this.requisitionNumber,
    jobOrderNo: jobOrderNo ?? this.jobOrderNo,
    reqNo: reqNo ?? this.reqNo,
    reqLineNo: reqLineNo ?? this.reqLineNo,
    poNo: poNo ?? this.poNo,
    poHeaderId: poHeaderId ?? this.poHeaderId,
    itemId: itemId ?? this.itemId,
    itemDescription: itemDescription ?? this.itemDescription,
    quantity: quantity ?? this.quantity,
    unitMeasLookupCode: unitMeasLookupCode ?? this.unitMeasLookupCode,
    needByDate: needByDate ?? this.needByDate,
  );

  factory GrnPO.fromJson(String str) => GrnPO.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GrnPO.fromMap(Map<String, dynamic> json) => GrnPO(
    operationUnit: json["Operation_Unit"],
    requisitionNumber: json["Requisition_Number"],
    jobOrderNo: json["JOB_ORDER_NO"],
    reqNo: json["req_no"],
    reqLineNo: json["req_line_no"],
    poNo: json["po_no"],
    poHeaderId: json["po_header_id"],
    itemId: json["ITEM_ID"],
    itemDescription: json["ITEM_DESCRIPTION"],
    quantity: json["QUANTITY"]?.toDouble(),
    unitMeasLookupCode: json["UNIT_MEAS_LOOKUP_CODE"],
    needByDate: json["NEED_BY_DATE"],
  );

  Map<String, dynamic> toMap() => {
    "Operation_Unit": operationUnit,
    "Requisition_Number": requisitionNumber,
    "JOB_ORDER_NO": jobOrderNo,
    "req_no": reqNo,
    "req_line_no": reqLineNo,
    "po_no": poNo,
    "po_header_id": poHeaderId,
    "ITEM_ID": itemId,
    "ITEM_DESCRIPTION": itemDescription,
    "QUANTITY": quantity,
    "UNIT_MEAS_LOOKUP_CODE": unitMeasLookupCode,
    "NEED_BY_DATE": needByDate,
  };
  @override
  String toString() {
    return 'PoNo: $poNo, Item: $itemId-$itemDescription, Qty: $quantity';
  }
}
