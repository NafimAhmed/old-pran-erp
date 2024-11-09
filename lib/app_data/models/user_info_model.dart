class UserInfoModel {
  final int? id;
  final String userId;
  final String userName;
  final String mobileNo;
  final String userDesg;
  final String userDept;

  UserInfoModel({
    this.id,
    required this.userId,
    required this.userName,
    required this.mobileNo,
    required this.userDesg,
    required this.userDept,
  });

  // From Map
  factory UserInfoModel.fromMap(Map<String, dynamic> map) {
    return UserInfoModel(
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      mobileNo: map['mobileNo'],
      userDesg: map['userDesg'],
      userDept: map['userDept'],
    );
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'mobileNo': mobileNo,
      'userDesg': userDesg,
      'userDept': userDept,
    };
  }

  // From JSON
  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      mobileNo: json['mobileNo'],
      userDesg: json['userDesg'],
      userDept: json['userDept'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'mobileNo': mobileNo,
      'userDesg': userDesg,
      'userDept': userDept,
    };
  }

  // CopyWith method
  UserInfoModel copyWith({
    int? id,
    String? userId,
    String? userName,
    String? mobileNo,
    String? userDesg,
    String? userDept,
  }) {
    return UserInfoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      mobileNo: mobileNo ?? this.mobileNo,
      userDesg: userDesg ?? this.userDesg,
      userDept: userDept ?? this.userDept,
    );
  }
}
