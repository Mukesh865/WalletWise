import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

sealed class GetCategoriesState extends Equatable {
  const GetCategoriesState();

  @override
  List<Object> get props => [];
}

class GetCategoriesInitial extends GetCategoriesState {}

class GetCategoriesLoading extends GetCategoriesState {}

class GetCategoriesSuccess extends GetCategoriesState {
  final List<Category> categories;

  const GetCategoriesSuccess({required this.categories});

  @override
  List<Object> get props => [categories];
}

class GetCategoriesFailure extends GetCategoriesState {
  final String message;

  const GetCategoriesFailure({required this.message});

  @override
  List<Object> get props => [message];
}