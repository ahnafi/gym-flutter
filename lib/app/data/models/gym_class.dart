class GymClass {
  final int id;
  final String code;
  final String name;
  final String slug;
  final String description;
  final int price;
  final String images;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  GymClass({
    required this.id,
    required this.code,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.images,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GymClass.fromJson(Map<String, dynamic> json) {
    return GymClass(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
      images: json['images'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
