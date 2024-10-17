import 'dart:convert';

class LovResponse {
  final List<Lov>? items;
  final bool? hasMore;
  final int? limit;
  final int? offset;
  final int? count;
  final List<Link>? links;

  LovResponse({
    this.items,
    this.hasMore,
    this.limit,
    this.offset,
    this.count,
    this.links,
  });

  LovResponse copyWith({
    List<Lov>? items,
    bool? hasMore,
    int? limit,
    int? offset,
    int? count,
    List<Link>? links,
  }) =>
      LovResponse(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        count: count ?? this.count,
        links: links ?? this.links,
      );

  factory LovResponse.fromJson(String str) =>
      LovResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LovResponse.fromMap(Map<String, dynamic> json) => LovResponse(
        items: json["items"] == null
            ? []
            : List<Lov>.from(json["items"]!.map((x) => Lov.fromMap(x))),
        hasMore: json["hasMore"],
        limit: json["limit"],
        offset: json["offset"],
        count: json["count"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toMap())),
        "hasMore": hasMore,
        "limit": limit,
        "offset": offset,
        "count": count,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toMap())),
      };
}

class Lov {
  final int? orgId;
  final OrgCode? orgCode;
  final String? machineName;
  final String? machineDesc;

  Lov({
    this.orgId,
    this.orgCode,
    this.machineName,
    this.machineDesc,
  });

  Lov copyWith({
    int? orgId,
    OrgCode? orgCode,
    String? machineName,
    String? machineDesc,
  }) =>
      Lov(
        orgId: orgId ?? this.orgId,
        orgCode: orgCode ?? this.orgCode,
        machineName: machineName ?? this.machineName,
        machineDesc: machineDesc ?? this.machineDesc,
      );

  factory Lov.fromJson(String str) => Lov.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Lov.fromMap(Map<String, dynamic> json) => Lov(
        orgId: json["org_id"],
        orgCode: orgCodeValues.map[json["org_code"]]!,
        machineName: json["machine_name"],
        machineDesc: json["machine_desc"],
      );

  Map<String, dynamic> toMap() => {
        "org_id": orgId,
        "org_code": orgCodeValues.reverse[orgCode],
        "machine_name": machineName,
        "machine_desc": machineDesc,
      };
}

enum OrgCode { PB0 }

final orgCodeValues = EnumValues({"PB0": OrgCode.PB0});

class Link {
  final String? rel;
  final String? href;

  Link({
    this.rel,
    this.href,
  });

  Link copyWith({
    String? rel,
    String? href,
  }) =>
      Link(
        rel: rel ?? this.rel,
        href: href ?? this.href,
      );

  factory Link.fromJson(String str) => Link.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Link.fromMap(Map<String, dynamic> json) => Link(
        rel: json["rel"],
        href: json["href"],
      );

  Map<String, dynamic> toMap() => {
        "rel": rel,
        "href": href,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
