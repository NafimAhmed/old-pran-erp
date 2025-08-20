import 'dart:convert';

class OrgWiseMessageResponse {
  final int? statusCode;
  final String? message;
  final List<OrgWiseMessage>? orgwisemessage;

  OrgWiseMessageResponse({this.statusCode, this.message, this.orgwisemessage});

  OrgWiseMessageResponse copyWith({
    int? statusCode,
    String? message,
    List<OrgWiseMessage>? orgwisemessage,
  }) => OrgWiseMessageResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    orgwisemessage: orgwisemessage ?? this.orgwisemessage,
  );

  factory OrgWiseMessageResponse.fromJson(String str) =>
      OrgWiseMessageResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrgWiseMessageResponse.fromMap(Map<String, dynamic> json) =>
      OrgWiseMessageResponse(
        statusCode: json["status_code"],
        message: json["message"],
        orgwisemessage: json["ORGWISEMESSAGE"] == null
            ? []
            : List<OrgWiseMessage>.from(
                json["ORGWISEMESSAGE"]!.map((x) => OrgWiseMessage.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "ORGWISEMESSAGE": orgwisemessage == null
        ? []
        : List<dynamic>.from(orgwisemessage!.map((x) => x.toMap())),
  };
}

class OrgWiseMessage {
  final int? sl;
  final String? messageText;

  OrgWiseMessage({this.sl, this.messageText});

  OrgWiseMessage copyWith({int? sl, String? messageText}) => OrgWiseMessage(
    sl: sl ?? this.sl,
    messageText: messageText ?? this.messageText,
  );

  factory OrgWiseMessage.fromJson(String str) =>
      OrgWiseMessage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrgWiseMessage.fromMap(Map<String, dynamic> json) =>
      OrgWiseMessage(sl: json["SL"], messageText: json["MESSAGE_TEXT"]);

  Map<String, dynamic> toMap() => {"SL": sl, "MESSAGE_TEXT": messageText};
}
