import 'dart:convert';

class JobHistoryResponse {
  final List<JobHistory>? items;
  final bool? hasMore;
  final int? limit;
  final int? offset;
  final int? count;
  final List<Link>? links;

  JobHistoryResponse({
    this.items,
    this.hasMore,
    this.limit,
    this.offset,
    this.count,
    this.links,
  });

  JobHistoryResponse copyWith({
    List<JobHistory>? items,
    bool? hasMore,
    int? limit,
    int? offset,
    int? count,
    List<Link>? links,
  }) =>
      JobHistoryResponse(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        count: count ?? this.count,
        links: links ?? this.links,
      );

  factory JobHistoryResponse.fromJson(String str) =>
      JobHistoryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobHistoryResponse.fromMap(Map<String, dynamic> json) =>
      JobHistoryResponse(
        items: json["items"] == null
            ? []
            : List<JobHistory>.from(
                json["items"]!.map((x) => JobHistory.fromMap(x))),
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

class JobHistory {
  final String? jobOrderNo;
  final String? fpoNo;
  final String? item;
  final String? creationDate;
  final String? planStartDate;
  final String? planCmpltDate;
  final num? fpoQty;
  final String? dtlUm;
  final int? totalMadeQty;
  final int? goodQty;
  final int? badQty;
  final int? trnQty;
  final int? rackQty;
  final num? madeP;
  final num? dueMadeP;

  JobHistory({
    this.jobOrderNo,
    this.fpoNo,
    this.item,
    this.creationDate,
    this.planStartDate,
    this.planCmpltDate,
    this.fpoQty,
    this.dtlUm,
    this.totalMadeQty,
    this.goodQty,
    this.badQty,
    this.trnQty,
    this.rackQty,
    this.madeP,
    this.dueMadeP,
  });

  JobHistory copyWith({
    String? jobOrderNo,
    String? fpoNo,
    String? item,
    String? creationDate,
    String? planStartDate,
    String? planCmpltDate,
    double? fpoQty,
    String? dtlUm,
    int? totalMadeQty,
    int? goodQty,
    int? badQty,
    int? trnQty,
    int? rackQty,
    double? madeP,
    double? dueMadeP,
  }) =>
      JobHistory(
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        fpoNo: fpoNo ?? this.fpoNo,
        item: item ?? this.item,
        creationDate: creationDate ?? this.creationDate,
        planStartDate: planStartDate ?? this.planStartDate,
        planCmpltDate: planCmpltDate ?? this.planCmpltDate,
        fpoQty: fpoQty ?? this.fpoQty,
        dtlUm: dtlUm ?? this.dtlUm,
        totalMadeQty: totalMadeQty ?? this.totalMadeQty,
        goodQty: goodQty ?? this.goodQty,
        badQty: badQty ?? this.badQty,
        trnQty: trnQty ?? this.trnQty,
        rackQty: rackQty ?? this.rackQty,
        madeP: madeP ?? this.madeP,
        dueMadeP: dueMadeP ?? this.dueMadeP,
      );

  factory JobHistory.fromJson(String str) =>
      JobHistory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobHistory.fromMap(Map<String, dynamic> json) => JobHistory(
        jobOrderNo: json["job_order_no"],
        fpoNo: json["fpo_no"],
        item: json["item"],
        creationDate: json["creation_date"],
        planStartDate: json["plan_start_date"],
        planCmpltDate: json["plan_cmplt_date"],
        fpoQty: json["fpo_qty"]?.toDouble(),
        dtlUm: json["dtl_um"],
        totalMadeQty: json["total_made_qty"],
        goodQty: json["good_qty"],
        badQty: json["bad_qty"],
        trnQty: json["trn_qty"],
        rackQty: json["rack_qty"],
        madeP: json["made_p"]?.toDouble(),
        dueMadeP: json["due_made_p"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "job_order_no": jobOrderNo,
        "fpo_no": fpoNo,
        "item": item,
        "creation_date": creationDate,
        "plan_start_date": planStartDate,
        "plan_cmplt_date": planCmpltDate,
        "fpo_qty": fpoQty,
        "dtl_um": dtlUm,
        "total_made_qty": totalMadeQty,
        "good_qty": goodQty,
        "bad_qty": badQty,
        "trn_qty": trnQty,
        "rack_qty": rackQty,
        "made_p": madeP,
        "due_made_p": dueMadeP,
      };
}

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
