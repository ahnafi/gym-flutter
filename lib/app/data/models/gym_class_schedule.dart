class GymClassSchedule {
  final int id;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int slot;
  final int availableSlot;
  final String gymClassId;
  final DateTime createdAt;
  final DateTime updatedAt;

  GymClassSchedule({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.slot,
    required this.availableSlot,
    required this.gymClassId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GymClassSchedule.fromJson(Map<String, dynamic> json) {
    return GymClassSchedule(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      slot: json['slot'] as int,
      availableSlot: json['available_slot'] as int,
      gymClassId: json['gym_class_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
