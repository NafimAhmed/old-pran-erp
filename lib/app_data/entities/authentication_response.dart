import 'dart:convert';

class AuthenticationResponse {
  final int? statusCode;
  final String? message;
  final String? errmsg;
  final List<MenuItem>? menuItems;

  AuthenticationResponse({
    this.statusCode,
    this.message,
    this.errmsg,
    this.menuItems,
  });

  AuthenticationResponse copyWith({
    int? statusCode,
    String? message,
    String? errmsg,
    List<MenuItem>? menuItems,
  }) =>
      AuthenticationResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errmsg: errmsg ?? this.errmsg,
        menuItems: menuItems ?? this.menuItems,
      );

  factory AuthenticationResponse.fromJson(String str) =>
      AuthenticationResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthenticationResponse.fromMap(Map<String, dynamic> json) =>
      AuthenticationResponse(
        statusCode: json["status_code"],
        message: json["message"],
        errmsg: json["errmsg"],
        menuItems: json["menu_items"] == null
            ? []
            : List<MenuItem>.from(
                json["menu_items"]!.map((x) => MenuItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "errmsg": errmsg,
        "menu_items": menuItems == null
            ? []
            : List<dynamic>.from(menuItems!.map((x) => x.toMap())),
      };
}

class MenuItem {
  final int? menuId;
  final String? menuName;
  final String? menuType;
  final String? menuRoute;
  final int? slno;
  final int? parentId;

  MenuItem({
    this.menuId,
    this.menuName,
    this.menuType,
    this.menuRoute,
    this.slno,
    this.parentId,
  });

  MenuItem copyWith({
    int? menuId,
    String? menuName,
    String? menuType,
    String? menuRoute,
    int? slno,
    int? parentId,
  }) =>
      MenuItem(
        menuId: menuId ?? this.menuId,
        menuName: menuName ?? this.menuName,
        menuType: menuType ?? this.menuType,
        menuRoute: menuRoute ?? this.menuRoute,
        slno: slno ?? this.slno,
        parentId: parentId ?? this.parentId,
      );

  factory MenuItem.fromJson(String str) => MenuItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MenuItem.fromMap(Map<String, dynamic> json) => MenuItem(
        menuId: json["MENU_ID"],
        menuName: json["MENU_NAME"],
        menuType: json["MENU_TYPE"],
        menuRoute: json["MENU_ROUTE"],
        slno: json["SLNO"],
        parentId: json["PARENT_ID"],
      );

  Map<String, dynamic> toMap() => {
        "MENU_ID": menuId,
        "MENU_NAME": menuName,
        "MENU_TYPE": menuType,
        "MENU_ROUTE": menuRoute,
        "SLNO": slno,
        "PARENT_ID": parentId,
      };
}
