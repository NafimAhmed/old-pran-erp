import 'dart:convert';

class ShiftDataResponse {
  final int? statusCode;
  final String? message;
  final List<ShiftData>? shiftData;

  ShiftDataResponse({
    this.statusCode,
    this.message,
    this.shiftData,
  });

  ShiftDataResponse copyWith({
    int? statusCode,
    String? message,
    List<ShiftData>? shiftData,
  }) =>
      ShiftDataResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        shiftData: shiftData ?? this.shiftData,
      );

  factory ShiftDataResponse.fromJson(String str) =>
      ShiftDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShiftDataResponse.fromMap(Map<String, dynamic> json) =>
      ShiftDataResponse(
        statusCode: json["status_code"],
        message: json["message"],
        shiftData: json["shift_data"] == null
            ? []
            : List<ShiftData>.from(
                json["shift_data"]!.map((x) => ShiftData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "shift_data": shiftData == null
            ? []
            : List<dynamic>.from(shiftData!.map((x) => x.toMap())),
      };
}

class ShiftData {
  final String? shiftName;
  final String? fromShift;
  final String? toShift;
  final String? shiftDesc;
  final int? totalShiftHr;

  ShiftData({
    this.shiftName,
    this.fromShift,
    this.toShift,
    this.shiftDesc,
    this.totalShiftHr,
  });

  ShiftData copyWith({
    String? shiftName,
    String? fromShift,
    String? toShift,
    String? shiftDesc,
    int? totalShiftHr,
  }) =>
      ShiftData(
        shiftName: shiftName ?? this.shiftName,
        fromShift: fromShift ?? this.fromShift,
        toShift: toShift ?? this.toShift,
        shiftDesc: shiftDesc ?? this.shiftDesc,
        totalShiftHr: totalShiftHr ?? this.totalShiftHr,
      );

  factory ShiftData.fromJson(String str) => ShiftData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShiftData.fromMap(Map<String, dynamic> json) => ShiftData(
        shiftName: json["SHIFT_NAME"],
        fromShift: json["FROM_SHIFT"],
        toShift: json["TO_SHIFT"],
        shiftDesc: json["SHIFT_DESC"],
        totalShiftHr: json["TOTAL_SHIFT_HR"],
      );

  Map<String, dynamic> toMap() => {
        "SHIFT_NAME": shiftName,
        "FROM_SHIFT": fromShift,
        "TO_SHIFT": toShift,
        "SHIFT_DESC": shiftDesc,
        "TOTAL_SHIFT_HR": totalShiftHr,
      };

  @override
  String toString() {
    return shiftName ?? "";
  }
}
