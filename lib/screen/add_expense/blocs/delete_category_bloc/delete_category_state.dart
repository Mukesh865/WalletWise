import 'package:equatable/equatable.dart';

sealed class DeleteCategoryState extends Equatable {
  const DeleteCategoryState();

  @override
  List<Object> get props => [];
}

class DeleteCategoryInitial extends DeleteCategoryState {}

class DeleteCategoryLoading extends DeleteCategoryState {}

class DeleteCategorySuccess extends DeleteCategoryState {
  final String categoryId;

  const DeleteCategorySuccess({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class DeleteCategoryFailure extends DeleteCategoryState {
  final String message;

  const DeleteCategoryFailure({required this.message});

  @override
  List<Object> get props => [message];
}
