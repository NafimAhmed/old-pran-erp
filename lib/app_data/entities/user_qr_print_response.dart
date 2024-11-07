import 'dart:convert';

class UserQrPrintResponse {
  final int? statusCode;
  final String? message;
  final List<UserBatchQrData>? userBatchData;

  UserQrPrintResponse({
    this.statusCode,
    this.message,
    this.userBatchData,
  });

  UserQrPrintResponse copyWith({
    int? statusCode,
    String? message,
    List<UserBatchQrData>? userBatchData,
  }) =>
      UserQrPrintResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        userBatchData: userBatchData ?? this.userBatchData,
      );

  factory UserQrPrintResponse.fromJson(String str) =>
      UserQrPrintResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserQrPrintResponse.fromMap(Map<String, dynamic> json) =>
      UserQrPrintResponse(
        statusCode: json["status_code"],
        message: json["message"],
        userBatchData: json["user_batch_data"] == null
            ? []
            : List<UserBatchQrData>.from(json["user_batch_data"]!
                .map((x) => UserBatchQrData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "user_batch_data": userBatchData == null
            ? []
            : List<dynamic>.from(userBatchData!.map((x) => x.toMap())),
      };
}

class UserBatchQrData {
  final String? itemname;
  final String? custname;
  final String? buyername;
  final String? custpo;
  final String? lotno;
  final int? goodQty;
  final String? expdate;
  final String? fpono;
  final String? jobno;
  final String? createdDate;
  final String? locLocator;
  final String? batchNo;

  UserBatchQrData({
    this.itemname,
    this.custname,
    this.buyername,
    this.custpo,
    this.lotno,
    this.goodQty,
    this.expdate,
    this.fpono,
    this.jobno,
    this.createdDate,
    this.locLocator,
    this.batchNo,
  });

  UserBatchQrData copyWith({
    String? itemname,
    String? custname,
    String? buyername,
    String? custpo,
    String? lotno,
    int? goodQty,
    String? expdate,
    String? fpono,
    String? jobno,
    String? createdDate,
    String? locLocator,
    String? batchNo,
  }) =>
      UserBatchQrData(
        itemname: itemname ?? this.itemname,
        custname: custname ?? this.custname,
        buyername: buyername ?? this.buyername,
        custpo: custpo ?? this.custpo,
        lotno: lotno ?? this.lotno,
        goodQty: goodQty ?? this.goodQty,
        expdate: expdate ?? this.expdate,
        fpono: fpono ?? this.fpono,
        jobno: jobno ?? this.jobno,
        createdDate: createdDate ?? this.createdDate,
        locLocator: locLocator ?? this.locLocator,
        batchNo: batchNo ?? this.batchNo,
      );

  factory UserBatchQrData.fromJson(String str) =>
      UserBatchQrData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserBatchQrData.fromMap(Map<String, dynamic> json) => UserBatchQrData(
        itemname: json["ITEMNAME"],
        custname: json["CUSTNAME"],
        buyername: json["BUYERNAME"],
        custpo: json["CUSTPO"],
        lotno: json["LOTNO"],
        goodQty: json["GOOD_QTY"],
        expdate: json["EXPDATE"],
        fpono: json["FPONO"],
        jobno: json["JOBNO"],
        createdDate: json["CREATED_DATE"],
        locLocator: json["LOC_LOCATOR"],
        batchNo: json["BATCHNO"],
      );

  Map<String, dynamic> toMap() => {
        "ITEMNAME": itemname,
        "CUSTNAME": custname,
        "BUYERNAME": buyername,
        "CUSTPO": custpo,
        "LOTNO": lotno,
        "GOOD_QTY": goodQty,
        "EXPDATE": expdate,
        "FPONO": fpono,
        "JOBNO": jobno,
        "CREATED_DATE": createdDate,
        "LOC_LOCATOR": locLocator,
        "BATCHNO": batchNo,
      };
}
