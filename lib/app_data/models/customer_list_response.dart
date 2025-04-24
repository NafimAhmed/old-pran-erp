import 'dart:convert';

class CustomerListResponse {
  final int? statusCode;
  final String? message;
  final List<Customer>? customerList;

  CustomerListResponse({
    this.statusCode,
    this.message,
    this.customerList,
  });

  CustomerListResponse copyWith({
    int? statusCode,
    String? message,
    List<Customer>? customerList,
  }) =>
      CustomerListResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        customerList: customerList ?? this.customerList,
      );

  factory CustomerListResponse.fromJson(String str) =>
      CustomerListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerListResponse.fromMap(Map<String, dynamic> json) =>
      CustomerListResponse(
        statusCode: json["status_code"],
        message: json["message"],
        customerList: json["customerList"] == null
            ? []
            : List<Customer>.from(
                json["customerList"]!.map((x) => Customer.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "customerList": customerList == null
            ? []
            : List<dynamic>.from(customerList!.map((x) => x.toMap())),
      };
}

class Customer {
  final String? customerName;
  final String? customerNumber;

  Customer({
    this.customerName,
    this.customerNumber,
  });

  Customer copyWith({
    String? customerName,
    String? customerNumber,
  }) =>
      Customer(
        customerName: customerName ?? this.customerName,
        customerNumber: customerNumber ?? this.customerNumber,
      );

  factory Customer.fromJson(String str) => Customer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
        customerName: json["CUSTOMER_NAME"],
        customerNumber: json["CUSTOMER_NUMBER"],
      );

  Map<String, dynamic> toMap() => {
        "CUSTOMER_NAME": customerName,
        "CUSTOMER_NUMBER": customerNumber,
      };
  @override
  String toString() {
    return "$customerNumber-$customerName";
  }
}
