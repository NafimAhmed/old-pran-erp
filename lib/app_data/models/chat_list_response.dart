import 'dart:convert';

class ChatListResponse {
  final int? statusCode;
  final String? message;
  final List<GptInfo>? gptInfo;

  ChatListResponse({
    this.statusCode,
    this.message,
    this.gptInfo,
  });

  ChatListResponse copyWith({
    int? statusCode,
    String? message,
    List<GptInfo>? gptInfo,
  }) =>
      ChatListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        gptInfo: gptInfo ?? this.gptInfo,
      );

  factory ChatListResponse.fromJson(String str) =>
      ChatListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChatListResponse.fromMap(Map<String, dynamic> json) =>
      ChatListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        gptInfo: json["GPT_info"] == null
            ? []
            : List<GptInfo>.from(
                json["GPT_info"]!.map((x) => GptInfo.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "GPT_info": gptInfo == null
            ? []
            : List<dynamic>.from(gptInfo!.map((x) => x.toMap())),
      };
}

class GptInfo {
  final String? chatOwner;
  final int? replyQuey;
  final String? askText;
  final String? chatTime;
  final String? creationDate;

  GptInfo({
    this.chatOwner,
    this.replyQuey,
    this.askText,
    this.chatTime,
    this.creationDate,
  });

  GptInfo copyWith({
    String? chatOwner,
    int? replyQuey,
    String? askText,
    String? chatTime,
    String? creationDate,
  }) =>
      GptInfo(
        chatOwner: chatOwner ?? this.chatOwner,
        replyQuey: replyQuey ?? this.replyQuey,
        askText: askText ?? this.askText,
        chatTime: chatTime ?? this.chatTime,
        creationDate: creationDate ?? this.creationDate,
      );

  factory GptInfo.fromJson(String str) => GptInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GptInfo.fromMap(Map<String, dynamic> json) => GptInfo(
        chatOwner: json["CHAT_OWNER"],
        replyQuey: json["REPLY_QUEY"],
        askText: json["ASK_TEXT"],
        chatTime: json["CHAT_TIME"],
        creationDate: json["creation_date"],
      );

  Map<String, dynamic> toMap() => {
        "CHAT_OWNER": chatOwner,
        "REPLY_QUEY": replyQuey,
        "ASK_TEXT": askText,
        "CHAT_TIME": chatTime,
        "creation_date": creationDate,
      };
}
