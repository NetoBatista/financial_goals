class GoalModel {
  String userId;
  String name;
  double value;
  DateTime finalDate;
  GoalModel({
    required this.userId,
    required this.name,
    required this.value,
    required this.finalDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'value': value,
      'finalDate': finalDate.millisecondsSinceEpoch,
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      userId: map['userId'] as String,
      name: map['name'] as String,
      value: map['value'] as double,
      finalDate: DateTime.fromMillisecondsSinceEpoch(map['finalDate'] as int),
    );
  }

  factory GoalModel.empty() {
    return GoalModel(
      userId: '',
      name: '',
      value: 0,
      finalDate: DateTime.now(),
    );
  }

  GoalModel copyWith({
    String? userId,
    String? name,
    double? value,
    DateTime? finalDate,
  }) {
    return GoalModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      value: value ?? this.value,
      finalDate: finalDate ?? this.finalDate,
    );
  }
}
