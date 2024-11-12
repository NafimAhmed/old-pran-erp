import 'dart:convert';

class QrUserMenuResponse {
  final int? statusCode;
  final String? message;
  final List<QrUserMenu>? usersMenuData;
  final List<QrUserChildMenu>? usersChildMenuData;
  QrUserMenuResponse({
    this.statusCode,
    this.message,
    this.usersMenuData,
    this.usersChildMenuData,
  });

  QrUserMenuResponse copyWith({
    int? statusCode,
    String? message,
    List<QrUserMenu>? usersMenuData,
    List<QrUserChildMenu>? usersChildMenuData,
  }) =>
      QrUserMenuResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        usersMenuData: usersMenuData ?? this.usersMenuData,
        usersChildMenuData: usersChildMenuData ?? this.usersChildMenuData,
      );

  factory QrUserMenuResponse.fromJson(String str) =>
      QrUserMenuResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QrUserMenuResponse.fromMap(Map<String, dynamic> json) =>
      QrUserMenuResponse(
        statusCode: json["status_code"],
        message: json["message"],
        usersMenuData: json["users_menu_data"] == null
            ? []
            : List<QrUserMenu>.from(
                json["users_menu_data"]!.map((x) => QrUserMenu.fromMap(x))),
        usersChildMenuData: json["users_child_menu_data"] == null
            ? []
            : List<QrUserChildMenu>.from(json["users_child_menu_data"]!
                .map((x) => QrUserChildMenu.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "users_menu_data": usersMenuData == null
            ? []
            : List<dynamic>.from(usersMenuData!.map((x) => x.toMap())),
        "users_child_menu_data": usersChildMenuData == null
            ? []
            : List<dynamic>.from(usersChildMenuData!.map((x) => x.toMap())),
      };
}

class QrUserMenu {
  final int? menuId;
  final String? menuName;
  final String? menuType;
  final String? menuRoute;

  QrUserMenu({
    this.menuId,
    this.menuName,
    this.menuType,
    this.menuRoute,
  });

  QrUserMenu copyWith({
    int? menuId,
    String? menuName,
    String? menuType,
    String? menuRoute,
  }) =>
      QrUserMenu(
        menuId: menuId ?? this.menuId,
        menuName: menuName ?? this.menuName,
        menuType: menuType ?? this.menuType,
        menuRoute: menuRoute ?? this.menuRoute,
      );

  factory QrUserMenu.fromJson(String str) =>
      QrUserMenu.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QrUserMenu.fromMap(Map<String, dynamic> json) => QrUserMenu(
        menuId: json["MENU_ID"],
        menuName: json["MENU_NAME"],
        menuType: json["MENU_TYPE"],
        menuRoute: json["MENU_ROUTE"],
      );

  Map<String, dynamic> toMap() => {
        "MENU_ID": menuId,
        "MENU_NAME": menuName,
        "MENU_TYPE": menuType,
        "MENU_ROUTE": menuRoute,
      };

  @override
  String toString() {
    return menuRoute ?? "";
  }
}

class QrUserChildMenu {
  final int? menuId;
  final String? menuName;
  final String? menuType;
  final String? menuRoute;

  QrUserChildMenu({
    this.menuId,
    this.menuName,
    this.menuType,
    this.menuRoute,
  });

  QrUserChildMenu copyWith({
    int? menuId,
    String? menuName,
    String? menuType,
    String? menuRoute,
  }) =>
      QrUserChildMenu(
        menuId: menuId ?? this.menuId,
        menuName: menuName ?? this.menuName,
        menuType: menuType ?? this.menuType,
        menuRoute: menuRoute ?? this.menuRoute,
      );

  factory QrUserChildMenu.fromJson(String str) =>
      QrUserChildMenu.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QrUserChildMenu.fromMap(Map<String, dynamic> json) => QrUserChildMenu(
        menuId: json["MENU_ID"],
        menuName: json["MENU_NAME"],
        menuType: json["MENU_TYPE"],
        menuRoute: json["MENU_ROUTE"],
      );

  Map<String, dynamic> toMap() => {
        "MENU_ID": menuId,
        "MENU_NAME": menuName,
        "MENU_TYPE": menuType,
        "MENU_ROUTE": menuRoute,
      };

  @override
  String toString() {
    return menuName ?? "";
  }
}
