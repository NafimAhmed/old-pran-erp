import 'dart:convert';

class UserMenuItemResponse {
  final int? statusCode;
  final String? message;
  final String? errmsg;
  final List<UserMenuItem>? userMenuItems;

  UserMenuItemResponse({
    this.statusCode,
    this.message,
    this.errmsg,
    this.userMenuItems,
  });

  UserMenuItemResponse copyWith({
    int? statusCode,
    String? message,
    String? errmsg,
    List<UserMenuItem>? userMenuItems,
  }) =>
      UserMenuItemResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errmsg: errmsg ?? this.errmsg,
        userMenuItems: userMenuItems ?? this.userMenuItems,
      );

  factory UserMenuItemResponse.fromJson(String str) => UserMenuItemResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserMenuItemResponse.fromMap(Map<String, dynamic> json) => UserMenuItemResponse(
    statusCode: json["status_code"],
    message: json["message"],
    errmsg: json["errmsg"],
    userMenuItems: json["user_menu_items"] == null ? [] : List<UserMenuItem>.from(json["user_menu_items"]!.map((x) => UserMenuItem.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status_code": statusCode,
    "message": message,
    "errmsg": errmsg,
    "user_menu_items": userMenuItems == null ? [] : List<dynamic>.from(userMenuItems!.map((x) => x.toMap())),
  };
}

class UserMenuItem {
  final String? moduleName;
  final String? moduleRoute;
  final List<UserPmenuItem>? userPmenuItems;

  UserMenuItem({
    this.moduleName,
    this.moduleRoute,
    this.userPmenuItems,
  });

  UserMenuItem copyWith({
    String? moduleName,
    String? moduleRoute,
    List<UserPmenuItem>? userPmenuItems,
  }) =>
      UserMenuItem(
        moduleName: moduleName ?? this.moduleName,
        moduleRoute: moduleRoute ?? this.moduleRoute,
        userPmenuItems: userPmenuItems ?? this.userPmenuItems,
      );

  factory UserMenuItem.fromJson(String str) => UserMenuItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserMenuItem.fromMap(Map<String, dynamic> json) => UserMenuItem(
    moduleName: json["module_name"],
    moduleRoute: json["module_route"],
    userPmenuItems: json["user_pmenu_items"] == null ? [] : List<UserPmenuItem>.from(json["user_pmenu_items"]!.map((x) => UserPmenuItem.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "module_name": moduleName,
    "module_route": moduleRoute,
    "user_pmenu_items": userPmenuItems == null ? [] : List<dynamic>.from(userPmenuItems!.map((x) => x.toMap())),
  };
}

class UserPmenuItem {
  final int? menuId;
  final String? menuName;
  final String? menuType;
  final String? menuRoute;
  final int? slno;
  final String? linkAddrs;
  final int? displaySl;
  final List<UserCmenuItem>? userCmenuItems;

  UserPmenuItem({
    this.menuId,
    this.menuName,
    this.menuType,
    this.menuRoute,
    this.slno,
    this.linkAddrs,
    this.displaySl,
    this.userCmenuItems,
  });

  UserPmenuItem copyWith({
    int? menuId,
    String? menuName,
    String? menuType,
    String? menuRoute,
    int? slno,
    String? linkAddrs,
    int? displaySl,
    List<UserCmenuItem>? userCmenuItems,
  }) =>
      UserPmenuItem(
        menuId: menuId ?? this.menuId,
        menuName: menuName ?? this.menuName,
        menuType: menuType ?? this.menuType,
        menuRoute: menuRoute ?? this.menuRoute,
        slno: slno ?? this.slno,
        linkAddrs: linkAddrs ?? this.linkAddrs,
        displaySl: displaySl ?? this.displaySl,
        userCmenuItems: userCmenuItems ?? this.userCmenuItems,
      );

  factory UserPmenuItem.fromJson(String str) => UserPmenuItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserPmenuItem.fromMap(Map<String, dynamic> json) => UserPmenuItem(
    menuId: json["MENU_ID"],
    menuName: json["MENU_NAME"],
    menuType: json["MENU_TYPE"],
    menuRoute: json["MENU_ROUTE"],
    slno: json["SLNO"],
    linkAddrs: json["LINK_ADDRS"],
    displaySl: json["DISPLAY_SL"],
    userCmenuItems: json["user_cmenu_items"] == null ? [] : List<UserCmenuItem>.from(json["user_cmenu_items"]!.map((x) => UserCmenuItem.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "MENU_ID": menuId,
    "MENU_NAME": menuName,
    "MENU_TYPE": menuType,
    "MENU_ROUTE": menuRoute,
    "SLNO": slno,
    "LINK_ADDRS": linkAddrs,
    "DISPLAY_SL": displaySl,
    "user_cmenu_items": userCmenuItems == null ? [] : List<dynamic>.from(userCmenuItems!.map((x) => x.toMap())),
  };
}

class UserCmenuItem {
  final int? menuId;
  final String? menuName;
  final String? menuType;
  final String? menuRoute;
  final int? parentId;
  final int? slno;
  final String? linkAddrs;
  final int? displaySl;

  UserCmenuItem({
    this.menuId,
    this.menuName,
    this.menuType,
    this.menuRoute,
    this.parentId,
    this.slno,
    this.linkAddrs,
    this.displaySl,
  });

  UserCmenuItem copyWith({
    int? menuId,
    String? menuName,
    String? menuType,
    String? menuRoute,
    int? parentId,
    int? slno,
    String? linkAddrs,
    int? displaySl,
  }) =>
      UserCmenuItem(
        menuId: menuId ?? this.menuId,
        menuName: menuName ?? this.menuName,
        menuType: menuType ?? this.menuType,
        menuRoute: menuRoute ?? this.menuRoute,
        parentId: parentId ?? this.parentId,
        slno: slno ?? this.slno,
        linkAddrs: linkAddrs ?? this.linkAddrs,
        displaySl: displaySl ?? this.displaySl,
      );

  factory UserCmenuItem.fromJson(String str) => UserCmenuItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserCmenuItem.fromMap(Map<String, dynamic> json) => UserCmenuItem(
    menuId: json["MENU_ID"],
    menuName: json["MENU_NAME"],
    menuType: json["MENU_TYPE"],
    menuRoute: json["MENU_ROUTE"],
    parentId: json["PARENT_ID"],
    slno: json["SLNO"],
    linkAddrs: json["LINK_ADDRS"],
    displaySl: json["DISPLAY_SL"],
  );

  Map<String, dynamic> toMap() => {
    "MENU_ID": menuId,
    "MENU_NAME": menuName,
    "MENU_TYPE": menuType,
    "MENU_ROUTE": menuRoute,
    "PARENT_ID": parentId,
    "SLNO": slno,
    "LINK_ADDRS": linkAddrs,
    "DISPLAY_SL": displaySl,
  };
}
