import 'dart:convert';

class TestListResponse {
  final int? statusCode;
  final String? message;
  final List<TestList>? testList;

  TestListResponse({this.statusCode, this.message, this.testList});

  TestListResponse copyWith({
    int? statusCode,
    String? message,
    List<TestList>? testList,
  }) => TestListResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    testList: testList ?? this.testList,
  );

  factory TestListResponse.fromJson(String str) =>
      TestListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TestListResponse.fromMap(Map<String, dynamic> json) =>
      TestListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        testList: json["testList"] == null
            ? []
            : List<TestList>.from(
                json["testList"]!.map((x) => TestList.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "testList": testList == null
        ? []
        : List<dynamic>.from(testList!.map((x) => x.toMap())),
  };
}

class TestList {
  final int? sl;
  final String? testName;
  final String? remarks;
  final List<TestParam>? testParams;

  TestList({this.sl, this.testName, this.remarks, this.testParams});

  TestList copyWith({
    int? sl,
    String? testName,
    String? remarks,
    List<TestParam>? testParams,
  }) => TestList(
    sl: sl ?? this.sl,
    testName: testName ?? this.testName,
    remarks: remarks ?? this.remarks,
    testParams: testParams ?? this.testParams,
  );

  factory TestList.fromJson(String str) => TestList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TestList.fromMap(Map<String, dynamic> json) => TestList(
    sl: json["SL"],
    testName: json["TEST_NAME"],
    remarks: json["REMARKS"],
    testParams: json["testParams"] == null
        ? []
        : List<TestParam>.from(
            json["testParams"]!.map((x) => TestParam.fromMap(x)),
          ),
  );

  Map<String, dynamic> toMap() => {
    "SL": sl,
    "TEST_NAME": testName,
    "REMARKS": remarks,
    "testParams": testParams == null
        ? []
        : List<dynamic>.from(testParams!.map((x) => x.toMap())),
  };
}

class TestParam {
  final String? paramName;
  final String? testId;
  final String? remarks;

  TestParam({this.paramName, this.testId, this.remarks});

  TestParam copyWith({String? paramName, String? testId, String? remarks}) =>
      TestParam(
        paramName: paramName ?? this.paramName,
        testId: testId ?? this.testId,
        remarks: remarks ?? this.remarks,
      );

  factory TestParam.fromJson(String str) => TestParam.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TestParam.fromMap(Map<String, dynamic> json) => TestParam(
    paramName: json["PARAM_NAME"],
    testId: json["TEST_ID"],
    remarks: json["REMARKS"],
  );

  Map<String, dynamic> toMap() => {
    "PARAM_NAME": paramName,
    "TEST_ID": testId,
    "REMARKS": remarks,
  };
  @override
  String toString() {
    return paramName ?? "-";
  }
}
