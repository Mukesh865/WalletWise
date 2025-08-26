import 'package:equatable/equatable.dart';

sealed class DeleteCategoryEvent extends Equatable {
  const DeleteCategoryEvent();

  @override
  List<Object> get props => [];
}

class DeleteCategory extends DeleteCategoryEvent {
  final String categoryId;
  
  const DeleteCategory({required this.categoryId});
  
  @override
  List<Object> get props => [categoryId];
}
