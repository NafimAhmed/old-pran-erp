import 'dart:convert';

class JobHistoryResponse {
  final List<JobHisory>? items;
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
    List<JobHisory>? items,
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
            : List<JobHisory>.from(
                json["items"]!.map((x) => JobHisory.fromMap(x))),
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

class JobHisory {
  final String? jobOrderNo;
  final String? fpoNo;
  final String? creationDate;
  final String? planStartDate;
  final String? planCmpltDate;
  final num? planQty;
  final num? originalQty;
  final String? dtlUm;
  final int? totalMadeQty;
  final int? goodQty;
  final int? badQty;
  final int? trnQty;
  final int? rackQty;
  final num? madeP;
  final num? dueMadeP;

  JobHisory({
    this.jobOrderNo,
    this.fpoNo,
    this.creationDate,
    this.planStartDate,
    this.planCmpltDate,
    this.planQty,
    this.originalQty,
    this.dtlUm,
    this.totalMadeQty,
    this.goodQty,
    this.badQty,
    this.trnQty,
    this.rackQty,
    this.madeP,
    this.dueMadeP,
  });

  JobHisory copyWith({
    String? jobOrderNo,
    String? fpoNo,
    String? creationDate,
    String? planStartDate,
    String? planCmpltDate,
    num? planQty,
    num? originalQty,
    String? dtlUm,
    int? totalMadeQty,
    int? goodQty,
    int? badQty,
    int? trnQty,
    int? rackQty,
    num? madeP,
    num? dueMadeP,
  }) =>
      JobHisory(
        jobOrderNo: jobOrderNo ?? this.jobOrderNo,
        fpoNo: fpoNo ?? this.fpoNo,
        creationDate: creationDate ?? this.creationDate,
        planStartDate: planStartDate ?? this.planStartDate,
        planCmpltDate: planCmpltDate ?? this.planCmpltDate,
        planQty: planQty ?? this.planQty,
        originalQty: originalQty ?? this.originalQty,
        dtlUm: dtlUm ?? this.dtlUm,
        totalMadeQty: totalMadeQty ?? this.totalMadeQty,
        goodQty: goodQty ?? this.goodQty,
        badQty: badQty ?? this.badQty,
        trnQty: trnQty ?? this.trnQty,
        rackQty: rackQty ?? this.rackQty,
        madeP: madeP ?? this.madeP,
        dueMadeP: dueMadeP ?? this.dueMadeP,
      );

  factory JobHisory.fromJson(String str) => JobHisory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobHisory.fromMap(Map<String, dynamic> json) => JobHisory(
        jobOrderNo: json["job_order_no"],
        fpoNo: json["fpo_no"],
        creationDate: json["creation_date"],
        planStartDate: json["plan_start_date"],
        planCmpltDate: json["plan_cmplt_date"],
        planQty: json["plan_qty"],
        originalQty: json["original_qty"],
        dtlUm: json["dtl_um"],
        totalMadeQty: json["total_made_qty"],
        goodQty: json["good_qty"],
        badQty: json["bad_qty"],
        trnQty: json["trn_qty"],
        rackQty: json["rack_qty"],
        madeP: json["made_p"],
        dueMadeP: json["due_made_p"],
      );

  Map<String, dynamic> toMap() => {
        "job_order_no": jobOrderNo,
        "fpo_no": fpoNo,
        "creation_date": creationDate,
        "plan_start_date": planStartDate,
        "plan_cmplt_date": planCmpltDate,
        "plan_qty": planQty,
        "original_qty": originalQty,
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
