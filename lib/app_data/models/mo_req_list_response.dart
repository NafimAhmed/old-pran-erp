import 'dart:convert';

class MOReqListResponse {
  final int? statusCode;
  final String? message;
  final List<MOReqTask>? moReqTaskList;

  MOReqListResponse({this.statusCode, this.message, this.moReqTaskList});

  MOReqListResponse copyWith({
    int? statusCode,
    String? message,
    List<MOReqTask>? moReqTaskList,
  }) => MOReqListResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    moReqTaskList: moReqTaskList ?? this.moReqTaskList,
  );

  factory MOReqListResponse.fromJson(String str) =>
      MOReqListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MOReqListResponse.fromMap(Map<String, dynamic> json) =>
      MOReqListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        moReqTaskList: json["mo_req_task_list"] == null
            ? []
            : List<MOReqTask>.from(
                json["mo_req_task_list"]!.map((x) => MOReqTask.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "mo_req_task_list": moReqTaskList == null
        ? []
        : List<dynamic>.from(moReqTaskList!.map((x) => x.toMap())),
  };
}

class MOReqTask {
  final int? taskId;
  final String? item;
  final String? purchaseRequisition;
  final String? assignee;
  final String? requester;
  final String? startDate;
  final String? status;
  final String? priority;
  final String? givenOrganization;
  final String? requestOrganization;
  final num? qty;

  MOReqTask.MOReqTask({
    this.taskId,
    this.item,
    this.purchaseRequisition,
    this.assignee,
    this.requester,
    this.startDate,
    this.status,
    this.priority,
    this.givenOrganization,
    this.requestOrganization,
    this.qty,
  });

  MOReqTask copyWith({
    int? taskId,
    String? item,
    String? purchaseRequisition,
    String? assignee,
    String? requester,
    String? startDate,
    String? status,
    String? priority,
    String? givenOrganization,
    String? requestOrganization,
    num? qty,
  }) => MOReqTask.MOReqTask(
    taskId: taskId ?? this.taskId,
    item: item ?? this.item,
    purchaseRequisition: purchaseRequisition ?? this.purchaseRequisition,
    assignee: assignee ?? this.assignee,
    requester: requester ?? this.requester,
    startDate: startDate ?? this.startDate,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    givenOrganization: givenOrganization ?? this.givenOrganization,
    requestOrganization: requestOrganization ?? this.requestOrganization,
    qty: qty ?? this.qty,
  );

  factory MOReqTask.fromJson(String str) => MOReqTask.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MOReqTask.fromMap(Map<String, dynamic> json) => MOReqTask.MOReqTask(
    taskId: json["TASK_ID"],
    item: json["ITEM"],
    purchaseRequisition: json["PURCHASE_REQUISITION"],
    assignee: json["ASSIGNEE"],
    requester: json["REQUESTER"],
    startDate: json["START_DATE"],
    status: json["STATUS"],
    priority: json["PRIORITY"],
    givenOrganization: json["GIVEN_ORGANIZATION"],
    requestOrganization: json["REQUEST_ORGANIZATION"],
    qty: json["QTY"],
  );

  Map<String, dynamic> toMap() => {
    "TASK_ID": taskId,
    "ITEM": item,
    "PURCHASE_REQUISITION": purchaseRequisition,
    "ASSIGNEE": assignee,
    "REQUESTER": requester,
    "START_DATE": startDate,
    "STATUS": status,
    "PRIORITY": priority,
    "GIVEN_ORGANIZATION": givenOrganization,
    "REQUEST_ORGANIZATION": requestOrganization,
    "QTY": qty,
  };
}
