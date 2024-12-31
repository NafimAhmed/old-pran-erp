import 'dart:convert';

import 'package:pran_rfl_erp/app_data/models/user_basic_data_response.dart';

class BatchShiftChangeResponse {
  final int? statusCode;
  final String? message;
  final List<UserMachine>? shiftMachineData;
  final List<UserBatch>? shiftBatchData;

  BatchShiftChangeResponse({
    this.statusCode,
    this.message,
    this.shiftMachineData,
    this.shiftBatchData,
  });

  BatchShiftChangeResponse copyWith({
    int? statusCode,
    String? message,
    List<UserMachine>? shiftMachineData,
    List<UserBatch>? shiftBatchData,
  }) =>
      BatchShiftChangeResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        shiftMachineData: shiftMachineData ?? this.shiftMachineData,
        shiftBatchData: shiftBatchData ?? this.shiftBatchData,
      );

  factory BatchShiftChangeResponse.fromJson(String str) =>
      BatchShiftChangeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchShiftChangeResponse.fromMap(Map<String, dynamic> json) =>
      BatchShiftChangeResponse(
        statusCode: json["status_code"],
        message: json["message"],
        shiftMachineData: json["shift_machine_data"] == null
            ? []
            : List<UserMachine>.from(
                json["shift_machine_data"]!.map((x) => UserMachine.fromMap(x))),
        shiftBatchData: json["shift_batch_data"] == null
            ? []
            : List<UserBatch>.from(
                json["shift_batch_data"]!.map((x) => UserBatch.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "shift_machine_data": shiftMachineData == null
            ? []
            : List<dynamic>.from(shiftMachineData!.map((x) => x.toMap())),
        "shift_batch_data": shiftBatchData == null
            ? []
            : List<dynamic>.from(shiftBatchData!.map((x) => x.toMap())),
      };
}
