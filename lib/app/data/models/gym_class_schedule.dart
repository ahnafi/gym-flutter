class GymClassSchedule {
  final int id;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int slot;
  final int availableSlot;
  final int gymClassId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GymClassSchedule({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.slot,
    required this.availableSlot,
    required this.gymClassId,
    this.createdAt,
    this.updatedAt,
  });

  factory GymClassSchedule.fromJson(Map<String, dynamic> json) {
    return GymClassSchedule(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      slot: json['slot'] as int,
      availableSlot: json['available_slot'] as int,
      gymClassId: json['gym_class_id'] as int,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  // Helper getter to check if slots are available
  bool get hasAvailableSlots => availableSlot > 0;

  // Helper getter to check if fully booked
  bool get isFullyBooked => availableSlot == 0;

  // Helper getter for formatted date
  String get formattedDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Helper getter for formatted time range
  String get timeRange => '$startTime - $endTime';
}
