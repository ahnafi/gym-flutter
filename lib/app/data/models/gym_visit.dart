class GymVisit {
  final int id;
  final DateTime visitDate;
  final DateTime entryTime;
  final DateTime? exitTime;
  final String status;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  GymVisit({
    required this.id,
    required this.visitDate,
    required this.entryTime,
    this.exitTime,
    required this.status,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory GymVisit.fromJson(Map<String, dynamic> json) {
    return GymVisit(
      id: json['id'] as int,
      visitDate: DateTime.parse(json['visit_date'] as String),
      entryTime: DateTime.parse(json['entry_time'] as String),
      exitTime: json['exit_time'] != null
          ? DateTime.parse(json['exit_time'] as String)
          : null,
      status: json['status'] as String,
      userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}