class MembershipHistory {
  final int id;
  final String code;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final int userId;
  final int membershipPackageId;
  final DateTime createdAt;
  final DateTime updatedAt;

  MembershipHistory({
    required this.id,
    required this.code,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.userId,
    required this.membershipPackageId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MembershipHistory.fromJson(Map<String, dynamic> json) {
    return MembershipHistory(
      id: json['id'] as int,
      code: json['code'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      status: json['status'] as String,
      userId: json['user_id'] as int,
      membershipPackageId: json['membership_package_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}