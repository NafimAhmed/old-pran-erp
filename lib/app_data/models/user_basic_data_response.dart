import 'dart:convert';

class UserBasicDataResponse {
  final int? statusCode;
  final String? message;
  final String? errmsg;
  final List<UserMachine>? userMachineData;
  final List<UserBatch>? userBatchData;

  UserBasicDataResponse({
    this.statusCode,
    this.message,
    this.errmsg,
    this.userMachineData,
    this.userBatchData,
  });

  UserBasicDataResponse copyWith({
    int? statusCode,
    String? message,
    String? errmsg,
    List<UserMachine>? userMachineData,
    List<UserBatch>? userBatchData,
  }) =>
      UserBasicDataResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errmsg: errmsg ?? this.errmsg,
        userMachineData: userMachineData ?? this.userMachineData,
        userBatchData: userBatchData ?? this.userBatchData,
      );

  factory UserBasicDataResponse.fromJson(String str) =>
      UserBasicDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserBasicDataResponse.fromMap(Map<String, dynamic> json) =>
      UserBasicDataResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errmsg: json["errmsg"],
        userMachineData: json["user_machine_data"] == null
            ? []
            : List<UserMachine>.from(
                json["user_machine_data"]!.map((x) => UserMachine.fromMap(x))),
        userBatchData: json["user_batch_data"] == null
            ? []
            : List<UserBatch>.from(
                json["user_batch_data"]!.map((x) => UserBatch.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "errmsg": errmsg,
        "user_machine_data": userMachineData == null
            ? []
            : List<dynamic>.from(userMachineData!.map((x) => x.toMap())),
        "user_batch_data": userBatchData == null
            ? []
            : List<dynamic>.from(userBatchData!.map((x) => x.toMap())),
      };
}

class UserBatch {
  final String? organizationCode;
  final String? organizationName;
  final int? batchId;
  final int? inventoryItemId;
  final int? materialDetailId;
  final String? batchNo;
  final String? itemCode;
  final String? itemName;
  final num? originalQty;
  final num? totalQty;
  final String? jobOrderNo;
  final String? batchStatus;
  final int? flagStatus;
  final String? shiftName;
  final int? shiftManPower;
  final String? lotNo;
  final String? machineName;

  UserBatch({
    this.organizationCode,
    this.organizationName,
    this.batchId,
    this.inventoryItemId,
    this.materialDetailId,
    this.batchNo,
    this.itemCode,
    this.itemName,
    this.originalQty,
    this.totalQty,
    this.jobOrderNo,
    this.batchStatus,
    this.flagStatus,
    this.shiftName,
    this.shiftManPower,
    this.lotNo,
    this.machineName,
  });

  UserBatch copyWith({
    String? organizationCode,
    String? organizationName,
    int? batchId,
    int? inventoryItemId,
    int? materialDetailId,
    String? batchNo,
    String? itemCode,
    String? itemName,
    num? originalQty,
    num? totalQty,
    String? jobOrderNo,
    String? batchStatus,
    int? flagStatus,
    String? shiftName,
    int? shiftManPower,
    String? lotNo,
    String? machineName,
  }) =>
      UserBatch(
        organizationCode: organizationCode ?? this.organizationCode,
        organizationName: organizationName ?? this.organizationName,
        batchId: batchId ?? this.batchId,
        inventoryItemId: inventoryItemId ?? this.inventoryItemId,
        materialDetailId: materialDetailId ?? this.materialDetailId,
        batchNo: batchNo ?? this.batchNo,
        itemCode: itemCode ?? this.itemCode,
        itemName: itemName ?? this.itemName,
        originalQty: originalQty ?? this.originalQty,
        totalQty: totalQty ?? this.totalQty,
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        batchStatus: batchStatus ?? this.batchStatus,
        flagStatus: flagStatus ?? this.flagStatus,
        shiftName: shiftName ?? this.shiftName,
        shiftManPower: shiftManPower ?? this.shiftManPower,
        lotNo: lotNo ?? this.lotNo,
        machineName: machineName ?? this.machineName,
      );

  factory UserBatch.fromJson(String str) => UserBatch.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
  @override
  String toString() {
    return "$batchNo-$itemCode-$itemName";
  }

  factory UserBatch.fromMap(Map<String, dynamic> json) => UserBatch(
        organizationCode: json["ORGANIZATION_CODE"],
        organizationName: json["ORGANIZATION_NAME"],
        batchId: json["batch_id"],
        inventoryItemId: json["inventory_item_id"],
        materialDetailId: json["material_detail_id"],
        batchNo: json["BATCH_NO"],
        itemCode: json["ITEM_CODE"],
        itemName: json["ITEM_NAME"],
        originalQty: json["ORIGINAL_QTY"],
        totalQty: json["TOTAL_QTY"],
        jobOrderNo: json["JOB_ORDER_NO"],
        batchStatus: json["BATCH_STATUS"],
        flagStatus: json["FLAG_STATUS"],
        shiftName: json["SHIFT_NAME"],
        shiftManPower: json["SHIFT_MAN_POWER"],
        lotNo: json["LOTNO"],
        machineName: json["MACHINE_NAME"],
      );

  Map<String, dynamic> toMap() => {
        "ORGANIZATION_CODE": organizationCode,
        "ORGANIZATION_NAME": organizationName,
        "batch_id": batchId,
        "inventory_item_id": inventoryItemId,
        "material_detail_id": materialDetailId,
        "BATCH_NO": batchNo,
        "ITEM_CODE": itemCode,
        "ITEM_NAME": itemName,
        "ORIGINAL_QTY": originalQty,
        "TOTAL_QTY": totalQty,
        "JOB_ORDER_NO": jobOrderNo,
        "BATCH_STATUS": batchStatus,
        "FLAG_STATUS": flagStatus,
        "SHIFT_NAME": shiftName,
        "SHIFT_MAN_POWER": shiftManPower,
        "LOTNO": lotNo,
        "MACHINE_NAME": machineName,
      };
}

class UserMachine {
  final int? orgId;
  final String? orgCode;
  final String? machineName;
  final String? machineDesc;

  UserMachine({
    this.orgId,
    this.orgCode,
    this.machineName,
    this.machineDesc,
  });

  UserMachine copyWith({
    int? orgId,
    String? orgCode,
    String? machineName,
    String? machineDesc,
  }) =>
      UserMachine(
        orgId: orgId ?? this.orgId,
        orgCode: orgCode ?? this.orgCode,
        machineName: machineName ?? this.machineName,
        machineDesc: machineDesc ?? this.machineDesc,
      );

  factory UserMachine.fromJson(String str) =>
      UserMachine.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
  @override
  String toString() {
    return machineName ?? "";
  }

  factory UserMachine.fromMap(Map<String, dynamic> json) => UserMachine(
        orgId: json["ORG_ID"],
        orgCode: json["ORG_CODE"],
        machineName: json["MACHINE_NAME"],
        machineDesc: json["MACHINE_DESC"],
      );

  Map<String, dynamic> toMap() => {
        "ORG_ID": orgId,
        "ORG_CODE": orgCode,
        "MACHINE_NAME": machineName,
        "MACHINE_DESC": machineDesc,
      };
}
