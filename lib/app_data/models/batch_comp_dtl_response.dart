import 'dart:convert';

class BatchComDtlDataResponse {
  final int? statusCode;
  final String? message;
  final List<SkuDtlData>? skuDtlData;

  BatchComDtlDataResponse({
    this.statusCode,
    this.message,
    this.skuDtlData,
  });

  BatchComDtlDataResponse copyWith({
    int? statusCode,
    String? message,
    List<SkuDtlData>? skuDtlData,
  }) =>
      BatchComDtlDataResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        skuDtlData: skuDtlData ?? this.skuDtlData,
      );

  factory BatchComDtlDataResponse.fromJson(String str) =>
      BatchComDtlDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchComDtlDataResponse.fromMap(Map<String, dynamic> json) =>
      BatchComDtlDataResponse(
        statusCode: json["status_code"],
        message: json["message"],
        skuDtlData: json["sku_dtl_data"] == null
            ? []
            : List<SkuDtlData>.from(
                json["sku_dtl_data"]!.map((x) => SkuDtlData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "sku_dtl_data": skuDtlData == null
            ? []
            : List<dynamic>.from(skuDtlData!.map((x) => x.toMap())),
      };
}

class SkuDtlData {
  final String? orgCode;
  final int? batchId;
  final int? materialDetailId;
  final String? batchNo;
  final String? itemName;
  final num? batchQty;
  final num? madeQty;
  final num? costAlloc;
  final num? editEnable;

  SkuDtlData({
    this.orgCode,
    this.batchId,
    this.materialDetailId,
    this.batchNo,
    this.itemName,
    this.batchQty,
    this.madeQty,
    this.costAlloc,
    this.editEnable,
  });

  SkuDtlData copyWith({
    String? orgCode,
    int? batchId,
    int? materialDetailId,
    String? batchNo,
    String? itemName,
    num? batchQty,
    num? madeQty,
    num? costAlloc,
    num? editEnable,
  }) =>
      SkuDtlData(
        orgCode: orgCode ?? this.orgCode,
        batchId: batchId ?? this.batchId,
        materialDetailId: materialDetailId ?? this.materialDetailId,
        batchNo: batchNo ?? this.batchNo,
        itemName: itemName ?? this.itemName,
        batchQty: batchQty ?? this.batchQty,
        madeQty: madeQty ?? this.madeQty,
        costAlloc: costAlloc ?? this.costAlloc,
        editEnable: editEnable ?? this.editEnable,
      );

  factory SkuDtlData.fromJson(String str) =>
      SkuDtlData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SkuDtlData.fromMap(Map<String, dynamic> json) => SkuDtlData(
        orgCode: json["org_code"],
        batchId: json["batch_id"],
        materialDetailId: json["MATERIAL_DETAIL_ID"],
        batchNo: json["batch_no"],
        itemName: json["item_name"],
        batchQty: json["batch_qty"],
        madeQty: json["made_qty"],
        costAlloc: json["COST_ALLOC"],
        editEnable: json["EDIT_ENABLE"],
      );

  Map<String, dynamic> toMap() => {
        "org_code": orgCode,
        "batch_id": batchId,
        "MATERIAL_DETAIL_ID": materialDetailId,
        "batch_no": batchNo,
        "item_name": itemName,
        "batch_qty": batchQty,
        "made_qty": madeQty,
        "COST_ALLOC": costAlloc,
        "EDIT_ENABLE": editEnable,
      };
  Map<String, dynamic> toTabMap() => {
        "Batch Id": batchId,
        "Material Dtl Id": materialDetailId,
        "Item": itemName,
        "Batch Qty": batchQty,
        "Made Qty": madeQty,
        "Cost Alloc": costAlloc,
        "Edit Enable": editEnable,
        "Action": "Save"
      };
  @override
  String toString() {
    return "$batchQty-$madeQty-$costAlloc";
  }
}
