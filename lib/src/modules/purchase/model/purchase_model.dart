class PurchaseModel {
  String userId;
  String receipt;
  PurchaseModel({
    required this.userId,
    required this.receipt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'receipt': receipt,
    };
  }

  factory PurchaseModel.fromMap(Map<String, dynamic> map) {
    return PurchaseModel(
      userId: map['userId'] as String,
      receipt: map['receipt'] as String,
    );
  }
}
