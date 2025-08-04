import '../models/category.dart';

class CategoryEntity {
  final String id;
  final String name;
  final String icon;
  final String color;
  final String type;
  final String createdAt;
  final String? updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert from Category model to CategoryEntity
  factory CategoryEntity.fromCategory(Category category) {
    return CategoryEntity(
      id: category.id,
      name: category.name,
      icon: category.icon,
      color: category.color,
      type: category.type.name,
      createdAt: category.createdAt.toIso8601String(),
      updatedAt: category.updatedAt?.toIso8601String(),
    );
  }

  // Convert from CategoryEntity to Category model
  Category toCategory() {
    return Category(
      id: id,
      name: name,
      icon: icon,
      color: color,
      type: CategoryType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => CategoryType.expense,
      ),
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  Map<String, dynamic> toEntity() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'type': type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory CategoryEntity.fromEntity(Map<String, dynamic> entity) {
    return CategoryEntity(
      id: entity['id'] as String,
      name: entity['name'] as String,
      icon: entity['icon'] as String,
      color: entity['color'] as String,
      type: entity['type'] as String,
      createdAt: entity['createdAt'] as String,
      updatedAt: entity['updatedAt'] as String?,
    );
  }

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
    String? type,
    String? createdAt,
    String? updatedAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryEntity &&
        other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.color == color &&
        other.type == type &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, icon, color, type, createdAt, updatedAt);
  }

  @override
  String toString() {
    return 'CategoryEntity(id: $id, name: $name, type: $type)';
  }
}
