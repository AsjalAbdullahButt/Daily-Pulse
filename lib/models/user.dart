"""
User model mirroring backend schema
"""
class User {
  final String id;
  final String email;
  final String name;
  final int? age;
  final double? weightKg;
  final double? heightCm;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.age,
    this.weightKg,
    this.heightCm,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> j) => User(
    id: j['id'] as String,
    email: j['email'] as String,
    name: j['name'] as String,
    age: j['age'] as int?,
    weightKg: (j['weight_kg'] as num?)?.toDouble(),
    heightCm: (j['height_cm'] as num?)?.toDouble(),
    createdAt: DateTime.parse(j['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'age': age,
    'weight_kg': weightKg,
    'height_cm': heightCm,
  };
}
