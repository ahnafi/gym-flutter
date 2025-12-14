class MembershipPackage {
  final String id;
  final String name;
  final String slug;
  final String description;
  final int duration;
  final int price;
  final String status;
  final List<String> images;
  final String createdAt;
  final String updatedAt;

  MembershipPackage({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.duration,
    required this.price,
    required this.status,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MembershipPackage.fromJson(Map<String, dynamic> json) {
    return MembershipPackage(
      id: json['id'].toString(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      duration: json['duration'] as int,
      price: (json['price'] as num).toInt(),
      status: json['status'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  /// Get the first image path for display
  String get primaryImage => images.isNotEmpty ? images.first : 'membership_package/default.jpg';
}