class Category {
  final String id;
  final String name;
  final String icon;
  final String color;
  final CategoryType type;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    required this.createdAt,
    this.updatedAt,
  });

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
    CategoryType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toEntity() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Category.fromEntity(Map<String, dynamic> entity) {
    return Category(
      id: entity['id'] as String,
      name: entity['name'] as String,
      icon: entity['icon'] as String,
      color: entity['color'] as String,
      type: CategoryType.values.firstWhere(
        (e) => e.name == entity['type'],
        orElse: () => CategoryType.expense,
      ),
      createdAt: DateTime.parse(entity['createdAt'] as String),
      updatedAt: entity['updatedAt'] != null
          ? DateTime.parse(entity['updatedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category &&
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
    return 'Category(id: $id, name: $name, icon: $icon, color: $color, type: $type)';
  }
}

enum CategoryType {
  expense,
  income,
}

extension CategoryTypeExtension on CategoryType {
  String get displayName {
    switch (this) {
      case CategoryType.expense:
        return 'Expense';
      case CategoryType.income:
        return 'Income';
    }
  }
}
