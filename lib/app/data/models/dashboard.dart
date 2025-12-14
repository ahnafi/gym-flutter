class DashboardSummary {
  final int visitCountInCurrentMonth;
  final int visitCountInCurrentWeek;
  final int gymClassCountInCurrentMonth;
  final double? averageVisitTimeInCurrentMonth;
  final String? averageVisitTimeFormatted;
  final Map<String, dynamic>? currentMembership;
  final Map<String, dynamic>? currentMembershipPackage;

  DashboardSummary({
    required this.visitCountInCurrentMonth,
    required this.visitCountInCurrentWeek,
    required this.gymClassCountInCurrentMonth,
    this.averageVisitTimeInCurrentMonth,
    this.averageVisitTimeFormatted,
    this.currentMembership,
    this.currentMembershipPackage,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      visitCountInCurrentMonth: json['visitCountInCurrentMonth'] as int? ?? 0,
      visitCountInCurrentWeek: json['visitCountInCurrentWeek'] as int? ?? 0,
      gymClassCountInCurrentMonth: json['gymClassCountInCurrentMonth'] as int? ?? 0,
      averageVisitTimeInCurrentMonth: json['averageVisitTimeInCurrentMonth'] != null
          ? (json['averageVisitTimeInCurrentMonth'] as num).toDouble()
          : null,
      averageVisitTimeFormatted: json['averageVisitTimeFormatted'] as String?,
      currentMembership: json['currentMembership'] as Map<String, dynamic>?,
      currentMembershipPackage: json['currentMembershipPackage'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visitCountInCurrentMonth': visitCountInCurrentMonth,
      'visitCountInCurrentWeek': visitCountInCurrentWeek,
      'gymClassCountInCurrentMonth': gymClassCountInCurrentMonth,
      'averageVisitTimeInCurrentMonth': averageVisitTimeInCurrentMonth,
      'averageVisitTimeFormatted': averageVisitTimeFormatted,
      'currentMembership': currentMembership,
      'currentMembershipPackage': currentMembershipPackage,
    };
  }
}

class DashboardData {
  final Map<String, dynamic> user;
  final List<Map<String, dynamic>> gymVisits;
  final List<Map<String, dynamic>> membershipHistories;
  final List<Map<String, dynamic>> gymClassAttendances;

  DashboardData({
    required this.user,
    required this.gymVisits,
    required this.membershipHistories,
    required this.gymClassAttendances,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      user: json['user'] as Map<String, dynamic>,
      gymVisits: (json['gymVisits'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? [],
      membershipHistories: (json['membershipHistories'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? [],
      gymClassAttendances: (json['gymClassAttendances'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'gymVisits': gymVisits,
      'membershipHistories': membershipHistories,
      'gymClassAttendances': gymClassAttendances,
    };
  }
}

class Dashboard {
  final DashboardSummary summary;
  final DashboardData data;

  Dashboard({
    required this.summary,
    required this.data,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      summary: DashboardSummary.fromJson(json['summary'] as Map<String, dynamic>),
      data: DashboardData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
      'data': data.toJson(),
    };
  }
}
