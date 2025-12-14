class Transaction {
  final int id;
  final String code;
  final int? gymClassScheduleId;
  final int amount;
  final String? snapToken;
  final DateTime? paymentDate;
  final String paymentStatus;

  final String purchasableType;
  final int purchasableId;
  final int userId;

  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.code,
    this.gymClassScheduleId,
    required this.amount,
    this.snapToken,
    this.paymentDate,
    required this.paymentStatus,
    required this.purchasableType,
    required this.purchasableId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      code: json['code'] as String,
      gymClassScheduleId: json['gym_class_schedule_id'] as int?,
      amount: (json['amount'] as num).toInt(),
      snapToken: json['snap_token'] as String?,
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'] as String)
          : null,
      paymentStatus: json['payment_status'] as String,
      purchasableType: json['purchasable_type'] as String,
      purchasableId: json['purchasable_id'] as int,
      userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
