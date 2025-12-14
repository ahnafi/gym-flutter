class GymClassAttendance {
  final int id;
  final String status;
  final DateTime attendedAt;
  final int userId;
  final int gymClassScheduleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  GymClassAttendance({
    required this.id,
    required this.status,
    required this.attendedAt,
    required this.userId,
    required this.gymClassScheduleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GymClassAttendance.fromJson(Map<String, dynamic> json) {
    return GymClassAttendance(
      id: json['id'] as int,
      status: json['status'] as String,
      attendedAt: DateTime.parse(json['attended_at'] as String),
      userId: json['user_id'] as int,
      gymClassScheduleId: json['gym_class_schedule_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}