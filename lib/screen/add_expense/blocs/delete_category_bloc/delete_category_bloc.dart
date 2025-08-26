import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_repository/expense_repository.dart';
import 'delete_category_event.dart';
import 'delete_category_state.dart';

class DeleteCategoryBloc extends Bloc<DeleteCategoryEvent, DeleteCategoryState> {
  final ExpenseRepository _expenseRepository;

  DeleteCategoryBloc({
    required ExpenseRepository expenseRepository,
  })  : _expenseRepository = expenseRepository,
        super(DeleteCategoryInitial()) {
    on<DeleteCategory>(_onDeleteCategory);
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<DeleteCategoryState> emit,
  ) async {
    try {
      emit(DeleteCategoryLoading());
      
      await _expenseRepository.deleteCategory(event.categoryId);
      
      emit(DeleteCategorySuccess(categoryId: event.categoryId));
    } catch (e) {
      emit(DeleteCategoryFailure(message: e.toString()));
    }
  }
}
