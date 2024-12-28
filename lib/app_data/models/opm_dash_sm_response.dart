import 'dart:convert';

class OpmDashSmResponse {
  final int? statusCode;
  final String? message;
  final List<ProdDtlStatus>? prodDtlStatus;
  final List<JobDetailsStatus>? jobDetailsStatus;
  final List<BatchStatus>? batchStatus;
  final List<ExtDtlStatus>? extDtlStatus;

  OpmDashSmResponse({
    this.statusCode,
    this.message,
    this.prodDtlStatus,
    this.jobDetailsStatus,
    this.batchStatus,
    this.extDtlStatus,
  });

  OpmDashSmResponse copyWith({
    int? statusCode,
    String? message,
    List<ProdDtlStatus>? prodDtlStatus,
    List<JobDetailsStatus>? jobDetailsStatus,
    List<BatchStatus>? batchStatus,
    List<ExtDtlStatus>? extDtlStatus,
  }) =>
      OpmDashSmResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        prodDtlStatus: prodDtlStatus ?? this.prodDtlStatus,
        jobDetailsStatus: jobDetailsStatus ?? this.jobDetailsStatus,
        batchStatus: batchStatus ?? this.batchStatus,
        extDtlStatus: extDtlStatus ?? this.extDtlStatus,
      );

  factory OpmDashSmResponse.fromJson(String str) =>
      OpmDashSmResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OpmDashSmResponse.fromMap(Map<String, dynamic> json) =>
      OpmDashSmResponse(
        statusCode: json["status_code"],
        message: json["message"],
        prodDtlStatus: json["prod_dtl_status"] == null
            ? []
            : List<ProdDtlStatus>.from(
                json["prod_dtl_status"]!.map((x) => ProdDtlStatus.fromMap(x))),
        jobDetailsStatus: json["job_details_status"] == null
            ? []
            : List<JobDetailsStatus>.from(json["job_details_status"]!
                .map((x) => JobDetailsStatus.fromMap(x))),
        batchStatus: json["batch_status"] == null
            ? []
            : List<BatchStatus>.from(
                json["batch_status"]!.map((x) => BatchStatus.fromMap(x))),
        extDtlStatus: json["Ext_dtl_status"] == null
            ? []
            : List<ExtDtlStatus>.from(
                json["Ext_dtl_status"]!.map((x) => ExtDtlStatus.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "prod_dtl_status": prodDtlStatus == null
            ? []
            : List<dynamic>.from(prodDtlStatus!.map((x) => x.toMap())),
        "job_details_status": jobDetailsStatus == null
            ? []
            : List<dynamic>.from(jobDetailsStatus!.map((x) => x.toMap())),
        "batch_status": batchStatus == null
            ? []
            : List<dynamic>.from(batchStatus!.map((x) => x.toMap())),
        "Ext_dtl_status": extDtlStatus == null
            ? []
            : List<dynamic>.from(extDtlStatus!.map((x) => x.toMap())),
      };
  Map<String, dynamic> toTabMap() => {
        "prod_dtl_status": prodDtlStatus == null
            ? []
            : List<dynamic>.from(prodDtlStatus!.map((x) => x.toMap())),
        "job_details_status": jobDetailsStatus == null
            ? []
            : List<dynamic>.from(jobDetailsStatus!.map((x) => x.toMap())),
        "batch_status": batchStatus == null
            ? []
            : List<dynamic>.from(batchStatus!.map((x) => x.toMap())),
        "Ext_dtl_status": extDtlStatus == null
            ? []
            : List<dynamic>.from(extDtlStatus!.map((x) => x.toMap())),
      };
}

class JobDetailsStatus {
  final int? totalCustomer;
  final int? totalJo;
  final int? completedJo;
  final double? joMadeP;
  final double? joDueMadeP;

  JobDetailsStatus({
    this.totalCustomer,
    this.totalJo,
    this.completedJo,
    this.joMadeP,
    this.joDueMadeP,
  });

  JobDetailsStatus copyWith({
    int? totalCustomer,
    int? totalJo,
    int? completedJo,
    double? joMadeP,
    double? joDueMadeP,
  }) =>
      JobDetailsStatus(
        totalCustomer: totalCustomer ?? this.totalCustomer,
        totalJo: totalJo ?? this.totalJo,
        completedJo: completedJo ?? this.completedJo,
        joMadeP: joMadeP ?? this.joMadeP,
        joDueMadeP: joDueMadeP ?? this.joDueMadeP,
      );

  factory JobDetailsStatus.fromJson(String str) =>
      JobDetailsStatus.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobDetailsStatus.fromMap(Map<String, dynamic> json) =>
      JobDetailsStatus(
        totalCustomer: json["total_CUSTOMER"],
        totalJo: json["total_JO"],
        completedJo: json["completed_jo"],
        joMadeP: json["jo_made_P"]?.toDouble(),
        joDueMadeP: json["jo_due_made_P"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "total_CUSTOMER": totalCustomer,
        "total_JO": totalJo,
        "completed_jo": completedJo,
        "jo_made_P": joMadeP,
        "jo_due_made_P": joDueMadeP,
      };
  Map<String, dynamic> toTabMap() => {
        "T Cust": totalCustomer,
        "T Jo": totalJo,
        "Completed": completedJo,
        "Made(%)": "$joMadeP %",
        "Due(%)": "$joDueMadeP %",
      };
}

class ProdDtlStatus {
  final int? totalItem;
  final int? itemCompleted;
  final int? totalBatch;
  final double? madeP;
  final double? dueMadeP;

  ProdDtlStatus({
    this.totalItem,
    this.itemCompleted,
    this.totalBatch,
    this.madeP,
    this.dueMadeP,
  });

  ProdDtlStatus copyWith({
    int? totalItem,
    int? itemCompleted,
    int? totalBatch,
    double? madeP,
    double? dueMadeP,
  }) =>
      ProdDtlStatus(
        totalItem: totalItem ?? this.totalItem,
        itemCompleted: itemCompleted ?? this.itemCompleted,
        totalBatch: totalBatch ?? this.totalBatch,
        madeP: madeP ?? this.madeP,
        dueMadeP: dueMadeP ?? this.dueMadeP,
      );

  factory ProdDtlStatus.fromJson(String str) =>
      ProdDtlStatus.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProdDtlStatus.fromMap(Map<String, dynamic> json) => ProdDtlStatus(
        totalItem: json["total_ITEM"],
        itemCompleted: json["item_completed"],
        totalBatch: json["total_batch"],
        madeP: json["made_P"]?.toDouble(),
        dueMadeP: json["due_made_P"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "total_ITEM": totalItem,
        "item_completed": itemCompleted,
        "total_batch": totalBatch,
        "made_P": madeP,
        "due_made_P": dueMadeP,
      };
  Map<String, dynamic> toTabMap() => {
        "T Item": totalItem,
        "Completed": itemCompleted,
        "T Batch": totalBatch,
        "Made(%)": "$madeP %",
        "Due(%)": "$dueMadeP %",
      };
}

class BatchStatus {
  final int? totalBatch;
  final int? completedBatch;
  final int? completedButUnclosedBatch;
  final int? batchCompletionP;
  final double? madeP;
  final double? dueMadeP;

  BatchStatus({
    this.totalBatch,
    this.completedBatch,
    this.completedButUnclosedBatch,
    this.batchCompletionP,
    this.madeP,
    this.dueMadeP,
  });

  BatchStatus copyWith({
    int? totalBatch,
    int? completedBatch,
    int? completedButUnclosedBatch,
    int? batchCompletionP,
    double? madeP,
    double? dueMadeP,
  }) =>
      BatchStatus(
        totalBatch: totalBatch ?? this.totalBatch,
        completedBatch: completedBatch ?? this.completedBatch,
        completedButUnclosedBatch:
            completedButUnclosedBatch ?? this.completedButUnclosedBatch,
        batchCompletionP: batchCompletionP ?? this.batchCompletionP,
        madeP: madeP ?? this.madeP,
        dueMadeP: dueMadeP ?? this.dueMadeP,
      );

  factory BatchStatus.fromJson(String str) =>
      BatchStatus.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchStatus.fromMap(Map<String, dynamic> json) => BatchStatus(
        totalBatch: json["total_batch"],
        completedBatch: json["completed_batch"],
        completedButUnclosedBatch: json["completed_but_unclosed_batch"],
        batchCompletionP: json["batch_completion_p"],
        madeP: json["made_P"]?.toDouble(),
        dueMadeP: json["due_made_P"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "total_batch": totalBatch,
        "completed_batch": completedBatch,
        "completed_but_unclosed_batch": completedButUnclosedBatch,
        "batch_completion_p": batchCompletionP,
        "made_P": madeP,
        "due_made_P": dueMadeP,
      };
  Map<String, dynamic> toTabMap() => {
        "T Batch": totalBatch,
        "Completed": completedBatch,
        "Unclosed": completedButUnclosedBatch,
        // "batch_completion_p": batchCompletionP,
        "Made(%)": "$madeP %",
        "Due(%)": "$dueMadeP %",
      };
}

class ExtDtlStatus {
  final int? totalItem;
  final int? batchCompletionP;
  final int? expCpltdButNotSysCom;
  final int? nearThisWeekExpdtJo;
  final double? madeP;
  final double? dueMadeP;

  ExtDtlStatus({
    this.totalItem,
    this.batchCompletionP,
    this.expCpltdButNotSysCom,
    this.nearThisWeekExpdtJo,
    this.madeP,
    this.dueMadeP,
  });

  ExtDtlStatus copyWith({
    int? totalItem,
    int? batchCompletionP,
    int? expCpltdButNotSysCom,
    int? nearThisWeekExpdtJo,
    double? madeP,
    double? dueMadeP,
  }) =>
      ExtDtlStatus(
        totalItem: totalItem ?? this.totalItem,
        batchCompletionP: batchCompletionP ?? this.batchCompletionP,
        expCpltdButNotSysCom: expCpltdButNotSysCom ?? this.expCpltdButNotSysCom,
        nearThisWeekExpdtJo: nearThisWeekExpdtJo ?? this.nearThisWeekExpdtJo,
        madeP: madeP ?? this.madeP,
        dueMadeP: dueMadeP ?? this.dueMadeP,
      );

  factory ExtDtlStatus.fromJson(String str) =>
      ExtDtlStatus.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExtDtlStatus.fromMap(Map<String, dynamic> json) => ExtDtlStatus(
        totalItem: json["total_ITEM"],
        batchCompletionP: json["batch_completion_p"],
        expCpltdButNotSysCom: json["exp_cpltd_but_not_sys_com"],
        nearThisWeekExpdtJo: json["near_this_week_expdt_JO"],
        madeP: json["made_P"]?.toDouble(),
        dueMadeP: json["due_made_P"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "total_ITEM": totalItem,
        "batch_completion_p": batchCompletionP,
        "exp_cpltd_but_not_sys_com": expCpltdButNotSysCom,
        "near_this_week_expdt_JO": nearThisWeekExpdtJo,
        "made_P": madeP,
        "due_made_P": dueMadeP,
      };
  Map<String, dynamic> toTabMap() => {
        "T Item": totalItem,
        "CompletionP": batchCompletionP,
        "Exp Comp": expCpltdButNotSysCom,
        // "near_this_week_expdt_JO": nearThisWeekExpdtJo,
        "Made(%)": "$madeP %",
        "Due(%)": "$dueMadeP %",
      };
}
