import 'dart:convert';

class LocatorListResponse {
  final int? statusCode;
  final String? message;
  final String? errorMessage;
  final List<Locator>? locator;

  LocatorListResponse({
    this.statusCode,
    this.message,
    this.errorMessage,
    this.locator,
  });

  LocatorListResponse copyWith({
    int? statusCode,
    String? message,
    String? errorMessage,
    List<Locator>? locator,
  }) => LocatorListResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    errorMessage: errorMessage ?? this.errorMessage,
    locator: locator ?? this.locator,
  );

  factory LocatorListResponse.fromJson(String str) =>
      LocatorListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LocatorListResponse.fromMap(Map<String, dynamic> json) =>
      LocatorListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errorMessage: json["error_message"],
        locator: json["locator"] == null
            ? []
            : List<Locator>.from(
                json["locator"]!.map((x) => Locator.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "error_message": errorMessage,
    "locator": locator == null
        ? []
        : List<dynamic>.from(locator!.map((x) => x.toMap())),
  };
}

class Locator {
  final int? secondaryLocator;
  final String? fullLocator;
  final String? subinventoryCode;

  Locator({this.secondaryLocator, this.fullLocator, this.subinventoryCode});

  Locator copyWith({
    int? secondaryLocator,
    String? fullLocator,
    String? subinventoryCode,
  }) => Locator(
    secondaryLocator: secondaryLocator ?? this.secondaryLocator,
    fullLocator: fullLocator ?? this.fullLocator,
    subinventoryCode: subinventoryCode ?? this.subinventoryCode,
  );

  factory Locator.fromJson(String str) => Locator.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Locator.fromMap(Map<String, dynamic> json) => Locator(
    secondaryLocator: json["SECONDARY_LOCATOR"],
    fullLocator: json["FULL_LOCATOR"],
    subinventoryCode: json["SUBINVENTORY_CODE"],
  );

  Map<String, dynamic> toMap() => {
    "SECONDARY_LOCATOR": secondaryLocator,
    "FULL_LOCATOR": fullLocator,
    "SUBINVENTORY_CODE": subinventoryCode,
  };
  @override
  String toString() {
    return '$fullLocator';
  }
}
