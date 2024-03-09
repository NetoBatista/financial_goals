class TransactionModel {
  String goalId;
  double value;
  DateTime transactionDate;
  String type;
  TransactionModel({
    required this.goalId,
    required this.value,
    required this.transactionDate,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'goalId': goalId,
      'value': value,
      'transactionDate': transactionDate.millisecondsSinceEpoch,
      'type': type,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      goalId: map['goalId'] as String,
      value: map['value'] as double,
      transactionDate:
          DateTime.fromMillisecondsSinceEpoch(map['transactionDate'] as int),
      type: map['type'] as String,
    );
  }

  TransactionModel copyWith({
    String? goalId,
    double? value,
    DateTime? transactionDate,
    String? type,
  }) {
    return TransactionModel(
      goalId: goalId ?? this.goalId,
      value: value ?? this.value,
      transactionDate: transactionDate ?? this.transactionDate,
      type: type ?? this.type,
    );
  }

  factory TransactionModel.empty() {
    return TransactionModel(
      goalId: '',
      transactionDate: DateTime.now(),
      value: 0,
      type: '',
    );
  }
}
