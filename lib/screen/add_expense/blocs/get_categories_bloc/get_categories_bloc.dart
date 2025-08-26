import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_repository/expense_repository.dart';
import 'get_categories_event.dart';
import 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  final ExpenseRepository _expenseRepository;

  GetCategoriesBloc({
    required ExpenseRepository expenseRepository,
  })  : _expenseRepository = expenseRepository,
        super(GetCategoriesInitial()) {
    on<GetCategories>(_onGetCategories);
  }

  Future<void> _onGetCategories(
    GetCategories event,
    Emitter<GetCategoriesState> emit,
  ) async {
    try {
      emit(GetCategoriesLoading());
      
      final categories = await _expenseRepository.getCategories();
      
      emit(GetCategoriesSuccess(categories: categories));
    } catch (e) {
      emit(GetCategoriesFailure(message: e.toString()));
    }
  }
}