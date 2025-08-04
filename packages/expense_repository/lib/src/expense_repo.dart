import 'dart:async';
import 'models/models.dart';

abstract class ExpenseRepository {
  // Category operations
  Future<List<Category>> getCategories();
  Future<Category?> getCategoryById(String id);
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<void> deleteCategory(String id);

  // Expense operations
  Future<List<Expense>> getExpenses({String? userId});
  Future<List<Expense>> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? userId,
  });
  Future<Expense?> getExpenseById(String id);
  Future<Expense> createExpense(Expense expense);
  Future<Expense> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);

  // Analytics operations
  Future<double> getTotalExpenses({String? userId, DateTime? startDate, DateTime? endDate});
  Future<double> getTotalIncome({String? userId, DateTime? startDate, DateTime? endDate});
  Future<double> getBalance({String? userId, DateTime? startDate, DateTime? endDate});
  Future<Map<Category, double>> getExpensesByCategory({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Map<Category, double>> getIncomeByCategory({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  });

  // Stream operations for real-time updates
  Stream<List<Expense>> watchExpenses({String? userId});
  Stream<List<Category>> watchCategories();
  Stream<double> watchTotalExpenses({String? userId});
  Stream<double> watchTotalIncome({String? userId});
  Stream<double> watchBalance({String? userId});
}
