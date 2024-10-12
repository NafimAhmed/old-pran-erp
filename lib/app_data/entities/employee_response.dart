import 'dart:convert';

class EmployeResponse {
  final List<Item> items;
  final bool hasMore;
  final int limit;
  final int offset;
  final int count;
  final List<Link> links;

  EmployeResponse({
    required this.items,
    required this.hasMore,
    required this.limit,
    required this.offset,
    required this.count,
    required this.links,
  });

  EmployeResponse copyWith({
    List<Item>? items,
    bool? hasMore,
    int? limit,
    int? offset,
    int? count,
    List<Link>? links,
  }) =>
      EmployeResponse(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        count: count ?? this.count,
        links: links ?? this.links,
      );

  factory EmployeResponse.fromJson(String str) =>
      EmployeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EmployeResponse.fromMap(Map<String, dynamic> json) => EmployeResponse(
        items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
        hasMore: json["hasMore"],
        limit: json["limit"],
        offset: json["offset"],
        count: json["count"],
        links: List<Link>.from(json["links"].map((x) => Link.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
        "hasMore": hasMore,
        "limit": limit,
        "offset": offset,
        "count": count,
        "links": List<dynamic>.from(links.map((x) => x.toMap())),
      };
}

class Item {
  final int empno;
  final String ename;
  final String job;
  final int? mgr;
  final DateTime hiredate;
  final int sal;
  final int? comm;
  final int deptno;

  Item({
    required this.empno,
    required this.ename,
    required this.job,
    required this.mgr,
    required this.hiredate,
    required this.sal,
    required this.comm,
    required this.deptno,
  });

  Item copyWith({
    int? empno,
    String? ename,
    String? job,
    int? mgr,
    DateTime? hiredate,
    int? sal,
    int? comm,
    int? deptno,
  }) =>
      Item(
        empno: empno ?? this.empno,
        ename: ename ?? this.ename,
        job: job ?? this.job,
        mgr: mgr ?? this.mgr,
        hiredate: hiredate ?? this.hiredate,
        sal: sal ?? this.sal,
        comm: comm ?? this.comm,
        deptno: deptno ?? this.deptno,
      );

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        empno: json["empno"],
        ename: json["ename"],
        job: json["job"],
        mgr: json["mgr"],
        hiredate: DateTime.parse(json["hiredate"]),
        sal: json["sal"],
        comm: json["comm"],
        deptno: json["deptno"],
      );

  Map<String, dynamic> toMap() => {
        "empno": empno,
        "ename": ename,
        "job": job,
        "mgr": mgr,
        "hiredate": hiredate.toIso8601String(),
        "sal": sal,
        "comm": comm,
        "deptno": deptno,
      };
}

class Link {
  final String rel;
  final String href;

  Link({
    required this.rel,
    required this.href,
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
