import 'dart:convert';

class JobOrderCompletionListResponse {
  final int? statusCode;
  final String? message;
  final List<JobOrderCompletion>? jobData;

  JobOrderCompletionListResponse({
    this.statusCode,
    this.message,
    this.jobData,
  });

  JobOrderCompletionListResponse copyWith({
    int? statusCode,
    String? message,
    List<JobOrderCompletion>? jobData,
  }) =>
      JobOrderCompletionListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        jobData: jobData ?? this.jobData,
      );

  factory JobOrderCompletionListResponse.fromJson(String str) =>
      JobOrderCompletionListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobOrderCompletionListResponse.fromMap(Map<String, dynamic> json) =>
      JobOrderCompletionListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        jobData: json["Job_data"] == null
            ? []
            : List<JobOrderCompletion>.from(
                json["Job_data"]!.map((x) => JobOrderCompletion.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "Job_data": jobData == null
            ? []
            : List<dynamic>.from(jobData!.map((x) => x.toMap())),
      };
}

class JobOrderCompletion {
  final String? jobOrderNo;

  JobOrderCompletion({
    this.jobOrderNo,
  });

  JobOrderCompletion copyWith({
    String? jobOrderNo,
  }) =>
      JobOrderCompletion(
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
      );

  factory JobOrderCompletion.fromJson(String str) =>
      JobOrderCompletion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobOrderCompletion.fromMap(Map<String, dynamic> json) =>
      JobOrderCompletion(
        jobOrderNo: json["JOB_ORDER_NO"],
      );

  Map<String, dynamic> toMap() => {
        "JOB_ORDER_NO": jobOrderNo,
      };
}
