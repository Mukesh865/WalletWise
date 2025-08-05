import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';
import 'create_category_event.dart';
import 'create_category_state.dart';

class CreateCategoryBloc extends Bloc<CreateCategoryEvent, CreateCategoryState> {
  final ExpenseRepository _expenseRepository;

  CreateCategoryBloc({
    required ExpenseRepository expenseRepository,
  })  : _expenseRepository = expenseRepository,
        super(CreateCategoryInitial()) {
    on<CreateCategory>(_onCreateCategory);
  }

  Future<void> _onCreateCategory(
    CreateCategory event,
    Emitter<CreateCategoryState> emit,
  ) async {
    try {
      emit(CreateCategoryLoading());
      
      final createdCategory = await _expenseRepository.createCategory(event.category);
      
      emit(CreateCategorySuccess(category: createdCategory));
    } catch (e) {
      emit(CreateCategoryFailure(message: e.toString()));
    }
  }
}
