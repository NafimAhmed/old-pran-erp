class NewTask {
  final String? taskName;
  final String? stDate;
  final String? enDate;
  final String? manPower;
  final String? hour;
  final String? dept;
  final String? buyer;
  final String? userId;
  final String? userName;

  NewTask({
    this.taskName,
    this.stDate,
    this.enDate,
    this.manPower,
    this.hour,
    this.dept,
    this.buyer,
    this.userId,
    this.userName,
  });

  NewTask copyWith({
    String? taskName,
    String? stDate,
    String? enDate,
    String? manPower,
    String? hour,
    String? dept,
    String? buyer,
    String? userId,
    String? userName,
  }) {
    return NewTask(
      taskName: taskName ?? this.taskName,
      stDate: stDate ?? this.stDate,
      enDate: enDate ?? this.enDate,
      manPower: manPower ?? this.manPower,
      hour: hour ?? this.hour,
      dept: dept ?? this.dept,
      buyer: buyer ?? this.buyer,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
    );
  }
}
