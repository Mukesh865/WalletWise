import 'category.dart';

class Expense {
  final String id;
  final String title;
  final String description;
  final double amount;
  final Category category;
  final DateTime date;
  final ExpenseType type;
  final String? userId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Expense({
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

  Expense copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    Category? category,
    DateTime? date,
    ExpenseType? type,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
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

  Map<String, dynamic> toEntity() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'category': category.toEntity(),
      'date': date.toIso8601String(),
      'type': type.name,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Expense.fromEntity(Map<String, dynamic> entity) {
    return Expense(
      id: entity['id'] as String,
      title: entity['title'] as String,
      description: entity['description'] as String,
      amount: (entity['amount'] as num).toDouble(),
      category: Category.fromEntity(entity['category'] as Map<String, dynamic>),
      date: DateTime.parse(entity['date'] as String),
      type: ExpenseType.values.firstWhere(
        (e) => e.name == entity['type'],
        orElse: () => ExpenseType.expense,
      ),
      userId: entity['userId'] as String?,
      createdAt: DateTime.parse(entity['createdAt'] as String),
      updatedAt: entity['updatedAt'] != null
          ? DateTime.parse(entity['updatedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Expense &&
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
    return 'Expense(id: $id, title: $title, amount: $amount, type: $type, date: $date)';
  }

  // Helper methods
  bool get isExpense => type == ExpenseType.expense;
  bool get isIncome => type == ExpenseType.income;
  
  // Get formatted amount with sign
  String get formattedAmount {
    final sign = isExpense ? '-' : '+';
    return '$sign\$${amount.toStringAsFixed(2)}';
  }

  // Get amount for calculations (negative for expenses, positive for income)
  double get signedAmount => isExpense ? -amount : amount;

  // Check if expense is from today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if expense is from this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  // Check if expense is from this month
  bool get isThisMonth {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  // Check if expense is from this year
  bool get isThisYear {
    final now = DateTime.now();
    return date.year == now.year;
  }
}

enum ExpenseType {
  expense,
  income,
}

extension ExpenseTypeExtension on ExpenseType {
  String get displayName {
    switch (this) {
      case ExpenseType.expense:
        return 'Expense';
      case ExpenseType.income:
        return 'Income';
    }
  }

  String get icon {
    switch (this) {
      case ExpenseType.expense:
        return '📤';
      case ExpenseType.income:
        return '📥';
    }
  }
}
