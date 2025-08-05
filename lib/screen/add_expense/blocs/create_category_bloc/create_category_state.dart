import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

sealed class CreateCategoryState extends Equatable {
  const CreateCategoryState();

  @override
  List<Object> get props => [];
}

class CreateCategoryInitial extends CreateCategoryState {}

class CreateCategoryLoading extends CreateCategoryState {}

class CreateCategorySuccess extends CreateCategoryState {
  final Category category;

  const CreateCategorySuccess({required this.category});

  @override
  List<Object> get props => [category];
}

class CreateCategoryFailure extends CreateCategoryState {
  final String message;

  const CreateCategoryFailure({required this.message});

  @override
  List<Object> get props => [message];
}
