import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'expense_repo.dart';
import 'models/models.dart';
import 'entities/entities.dart';

class FirebaseExpenseRepository implements ExpenseRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseExpenseRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _firestore.collection('categories');

  CollectionReference<Map<String, dynamic>> get _expensesCollection =>
      _firestore.collection('expenses');

  String? get _currentUserId => _auth.currentUser?.uid;

  // Category operations
  @override
  Future<List<Category>> getCategories() async {
    try {
      final querySnapshot = await _categoriesCollection.get();
      return querySnapshot.docs
          .map((doc) => CategoryEntity.fromEntity(doc.data()).toCategory())
          .toList();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    try {
      final doc = await _categoriesCollection.doc(id).get();
      if (doc.exists) {
        return CategoryEntity.fromEntity(doc.data()!).toCategory();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get category: $e');
    }
  }

  @override
  Future<Category> createCategory(Category category) async {
    try {
      final docRef = _categoriesCollection.doc();
      final categoryWithId = category.copyWith(id: docRef.id);
      final entity = CategoryEntity.fromCategory(categoryWithId);
      
      await docRef.set(entity.toEntity());
      return categoryWithId;
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  @override
  Future<Category> updateCategory(Category category) async {
    try {
      final entity = CategoryEntity.fromCategory(category);
      await _categoriesCollection.doc(category.id).update(entity.toEntity());
      return category;
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _categoriesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  // Expense operations
  @override
  Future<List<Expense>> getExpenses({String? userId}) async {
    try {
      final currentUserId = userId ?? _currentUserId;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final querySnapshot = await _expensesCollection
          .where('userId', isEqualTo: currentUserId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ExpenseEntity.fromJson(doc.data()).toExpense())
          .toList();
    } catch (e) {
      throw Exception('Failed to get expenses: $e');
    }
  }

  @override
  Future<List<Expense>> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? userId,
  }) async {
    try {
      final currentUserId = userId ?? _currentUserId;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final querySnapshot = await _expensesCollection
          .where('userId', isEqualTo: currentUserId)
          .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ExpenseEntity.fromJson(doc.data()).toExpense())
          .toList();
    } catch (e) {
      throw Exception('Failed to get expenses by date range: $e');
    }
  }

  @override
  Future<Expense?> getExpenseById(String id) async {
    try {
      final doc = await _expensesCollection.doc(id).get();
      if (doc.exists) {
        return ExpenseEntity.fromJson(doc.data()!).toExpense();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get expense: $e');
    }
  }

  @override
  Future<Expense> createExpense(Expense expense) async {
    try {
      final currentUserId = _currentUserId;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final docRef = _expensesCollection.doc();
      final expenseWithId = expense.copyWith(
        id: docRef.id,
        userId: currentUserId,
      );
      final entity = ExpenseEntity.fromExpense(expenseWithId);

      await docRef.set(entity.toEntity());
      return expenseWithId;
    } catch (e) {
      throw Exception('Failed to create expense: $e');
    }
  }

  @override
  Future<Expense> updateExpense(Expense expense) async {
    try {
      final entity = ExpenseEntity.fromExpense(expense);
      await _expensesCollection.doc(expense.id).update(entity.toEntity());
      return expense;
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await _expensesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  // Analytics operations
  @override
  Future<double> getTotalExpenses({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final currentUserId = userId ?? _currentUserId;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      Query query = _expensesCollection
          .where('userId', isEqualTo: currentUserId)
          .where('type', isEqualTo: 'expense');

      if (startDate != null) {
        query = query.where('date', isGreaterThanOrEqualTo: startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.where('date', isLessThanOrEqualTo: endDate.toIso8601String());
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => ExpenseEntity.fromJson(doc.data()).toExpense())
          .fold(0.0, (sum, expense) => sum + expense.amount);
    } catch (e) {
      throw Exception('Failed to get total expenses: $e');
    }
  }

  @override
  Future<double> getTotalIncome({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final currentUserId = userId ?? _currentUserId;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      Query query = _expensesCollection
          .where('userId', isEqualTo: currentUserId)
          .where('type', isEqualTo: 'income');

      if (startDate != null) {
        query = query.where('date', isGreaterThanOrEqualTo: startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.where('date', isLessThanOrEqualTo: endDate.toIso8601String());
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => ExpenseEntity.fromJson(doc.data()).toExpense())
          .fold(0.0, (sum, expense) => sum + expense.amount);
    } catch (e) {
      throw Exception('Failed to get total income: $e');
    }
  }

  @override
  Future<double> getBalance({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final income = await getTotalIncome(userId: userId, startDate: startDate, endDate: endDate);
      final expenses = await getTotalExpenses(userId: userId, startDate: startDate, endDate: endDate);
      return income - expenses;
    } catch (e) {
      throw Exception('Failed to get balance: $e');
    }
  }

  @override
  Future<Map<Category, double>> getExpensesByCategory({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final expenses = await getExpensesByDateRange(
        startDate: startDate ?? DateTime(2020),
        endDate: endDate ?? DateTime.now(),
        userId: userId,
      );

      final expenseExpenses = expenses.where((e) => e.isExpense).toList();
      final Map<Category, double> result = {};

      for (final expense in expenseExpenses) {
        result[expense.category] = (result[expense.category] ?? 0) + expense.amount;
      }

      return result;
    } catch (e) {
      throw Exception('Failed to get expenses by category: $e');
    }
  }

  @override
  Future<Map<Category, double>> getIncomeByCategory({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final expenses = await getExpensesByDateRange(
        startDate: startDate ?? DateTime(2020),
        endDate: endDate ?? DateTime.now(),
        userId: userId,
      );

      final incomeExpenses = expenses.where((e) => e.isIncome).toList();
      final Map<Category, double> result = {};

      for (final expense in incomeExpenses) {
        result[expense.category] = (result[expense.category] ?? 0) + expense.amount;
      }

      return result;
    } catch (e) {
      throw Exception('Failed to get income by category: $e');
    }
  }

  // Stream operations
  @override
  Stream<List<Expense>> watchExpenses({String? userId}) {
    final currentUserId = userId ?? _currentUserId;
    if (currentUserId == null) {
      return Stream.error(Exception('User not authenticated'));
    }

    return _expensesCollection
        .where('userId', isEqualTo: currentUserId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseEntity.fromJson(doc.data()).toExpense())
            .toList());
  }

  @override
  Stream<List<Category>> watchCategories() {
    return _categoriesCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => CategoryEntity.fromEntity(doc.data()).toCategory())
        .toList());
  }

  @override
  Stream<double> watchTotalExpenses({String? userId}) {
    return watchExpenses(userId: userId).map((expenses) =>
        expenses.where((e) => e.isExpense).fold(0.0, (sum, e) => sum + e.amount));
  }

  @override
  Stream<double> watchTotalIncome({String? userId}) {
    return watchExpenses(userId: userId).map((expenses) =>
        expenses.where((e) => e.isIncome).fold(0.0, (sum, e) => sum + e.amount));
  }

  @override
  Stream<double> watchBalance({String? userId}) {
    return watchExpenses(userId: userId).map((expenses) {
      double income = 0.0;
      double expense = 0.0;
      
      for (final e in expenses) {
        if (e.isIncome) {
          income += e.amount;
        } else {
          expense += e.amount;
        }
      }
      
      return income - expense;
    });
  }
} 