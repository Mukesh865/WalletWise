import '../models/expense.dart';
import 'category_entity.dart';

class ExpenseEntity {
  final String id;
  final String title;
  final String description;
  final double amount;
  final CategoryEntity category;
  final String date;
  final String type;
  final String? userId;
  final String createdAt;
  final String? updatedAt;

  const ExpenseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.userId,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert from Expense model to ExpenseEntity
  factory ExpenseEntity.fromExpense(Expense expense) {
    return ExpenseEntity(
      id: expense.id,
      title: expense.title,
      description: expense.description,
      amount: expense.amount,
      category: CategoryEntity.fromCategory(expense.category),
      date: expense.date.toIso8601String(),
      type: expense.type.name,
      userId: expense.userId,
      createdAt: expense.createdAt.toIso8601String(),
      updatedAt: expense.updatedAt?.toIso8601String(),
    );
  }

  // Convert from ExpenseEntity to Expense model
  Expense toExpense() {
    return Expense(
      id: id,
      title: title,
      description: description,
      amount: amount,
      category: category.toCategory(),
      date: DateTime.parse(date),
      type: ExpenseType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => ExpenseType.expense,
      ),
      userId: userId,
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  Map<String, dynamic> toEntity() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'category': category.toEntity(),
      'date': date,
      'type': type,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ExpenseEntity.fromJson(Map<String, dynamic> entity) {
    return ExpenseEntity(
      id: entity['id'] as String,
      title: entity['title'] as String,
      description: entity['description'] as String,
      amount: (entity['amount'] as num).toDouble(),
      category: CategoryEntity.fromEntity(entity['category'] as Map<String, dynamic>),
      date: entity['date'] as String,
      type: entity['type'] as String,
      userId: entity['userId'] as String?,
      createdAt: entity['createdAt'] as String,
      updatedAt: entity['updatedAt'] as String?,
    );
  }

  ExpenseEntity copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    CategoryEntity? category,
    String? date,
    String? type,
    String? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExpenseEntity &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.amount == amount &&
        other.category == category &&
        other.date == date &&
        other.type == type &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      amount,
      category,
      date,
      type,
      userId,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'ExpenseEntity(id: $id, title: $title, amount: $amount, type: $type)';
  }
}
