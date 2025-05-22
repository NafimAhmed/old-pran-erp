class CompanyModel {
  final int? id;
  final String baseUrl;
  final String comName;

  CompanyModel({
    this.id,
    required this.baseUrl,
    required this.comName,
  });

  // From Map
  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      id: map['id'],
      baseUrl: map['baseUrl'],
      comName: map['comName'],
    );
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'baseUrl': baseUrl,
      'comName': comName,
    };
  }

  // From JSON
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      baseUrl: json['baseUrl'],
      comName: json['comName'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baseUrl': baseUrl,
      'comName': comName,
    };
  }

  // CopyWith method
  CompanyModel copyWith({
    int? id,
    String? baseUrl,
    String? comName,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      baseUrl: baseUrl ?? this.baseUrl,
      comName: comName ?? this.comName,
    );
  }
}
