import 'dart:math';
import 'package:expense_tracker_app/screen/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:expense_tracker_app/screen/add_expense/blocs/create_category_bloc/create_category_event.dart';
import 'package:expense_tracker_app/screen/add_expense/blocs/create_category_bloc/create_category_state.dart';
import 'package:expense_tracker_app/screen/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expense_tracker_app/screen/add_expense/blocs/get_categories_bloc/get_categories_event.dart';
import 'package:expense_tracker_app/screen/add_expense/blocs/get_categories_bloc/get_categories_state.dart';
import 'package:expense_tracker_app/screen/add_expense/blocs/delete_category_bloc/delete_category_bloc.dart';
import 'package:expense_tracker_app/screen/add_expense/blocs/delete_category_bloc/delete_category_event.dart';
import 'package:expense_tracker_app/screen/add_expense/blocs/delete_category_bloc/delete_category_state.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TextEditingController addExpenseController = TextEditingController();
  TextEditingController addCategoryController = TextEditingController();
  TextEditingController addDateController = TextEditingController();
  TextEditingController addNoteController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();

  String? selectedCategory;
  List<Category> categories = [];
  List<String> categoryNames = [];

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    addDateController.text = "${today.day}/${today.month}/${today.year}";
    
    // Load categories when screen initializes
    context.read<GetCategoriesBloc>().add(const GetCategories());
  }

  @override
  void dispose() {
    addExpenseController.dispose();
    addCategoryController.dispose();
    addDateController.dispose();
    addNoteController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  void _createDefaultCategories() {
    final uuid = const Uuid();
    final now = DateTime.now();
    
    final defaultCategories = [
      {'name': 'Food', 'icon': 'utensils', 'color': '#FF6B6B'},
      {'name': 'Shopping', 'icon': 'bagShopping', 'color': '#4ECDC4'},
      {'name': 'Entertainment', 'icon': 'film', 'color': '#45B7D1'},
      {'name': 'Travel', 'icon': 'plane', 'color': '#96CEB4'},
    ];
    
    for (final categoryData in defaultCategories) {
      final category = Category(
        id: uuid.v4(),
        name: categoryData['name']!,
        icon: categoryData['icon']!,
        color: categoryData['color']!,
        type: CategoryType.expense,
        createdAt: now,
      );
      
      context.read<CreateCategoryBloc>().add(CreateCategory(category: category));
    }
  }

  void _updateCategoryNames() {
    setState(() {
      categoryNames = categories.map((cat) => cat.name).toList();
      categoryNames.add('Create Category');
    });
  }

  void _showCreateCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Create a New Category'),
          content: TextField(
            controller: _newCategoryController,
            decoration: const InputDecoration(hintText: "Category Name"),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _newCategoryController.clear();
              },
            ),
            TextButton(
              child: const Text('SAVE'),
              onPressed: () {
                if (_newCategoryController.text.trim().isNotEmpty) {
                  final newCategoryName = _newCategoryController.text.trim();
                  final uuid = const Uuid();
                  final now = DateTime.now();
                  
                  final category = Category(
                    id: uuid.v4(),
                    name: newCategoryName,
                    icon: 'category', // Default icon
                    color: '#757575', // Default gray color
                    type: CategoryType.expense,
                    createdAt: now,
                  );
                  
                  // Create the category using the parent context
                  context.read<CreateCategoryBloc>().add(CreateCategory(category: category));
                  
                  // Close dialog and clear controller
                  Navigator.of(dialogContext).pop();
                  _newCategoryController.clear();
                } else {
                  // Show error for empty category name
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a category name'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(String categoryId, String categoryName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text('Are you sure you want to delete "$categoryName"? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('DELETE', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<DeleteCategoryBloc>().add(DeleteCategory(categoryId: categoryId));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldWidth = screenWidth * 0.85;

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateCategoryBloc, CreateCategoryState>(
          listener: (context, state) {
            if (state is CreateCategorySuccess) {
              // Add the new category to the list
              setState(() {
                categories.add(state.category);
                _updateCategoryNames();
                selectedCategory = state.category.name;
              });
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Category "${state.category.name}" created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              
              // Refresh categories from the repository
              context.read<GetCategoriesBloc>().add(const GetCategories());
            } else if (state is CreateCategoryFailure) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<DeleteCategoryBloc, DeleteCategoryState>(
          listener: (context, state) {
            if (state is DeleteCategorySuccess) {
              // Remove the deleted category from the list
              setState(() {
                categories.removeWhere((cat) => cat.id == state.categoryId);
                _updateCategoryNames();
                
                // If the deleted category was selected, clear the selection
                if (selectedCategory != null) {
                  final deletedCategory = categories.firstWhere(
                    (cat) => cat.id == state.categoryId,
                    orElse: () => Category(
                      id: '',
                      name: '',
                      icon: '',
                      color: '',
                      type: CategoryType.expense,
                      createdAt: DateTime.now(),
                    ),
                  );
                  if (deletedCategory.name == selectedCategory) {
                    selectedCategory = null;
                  }
                }
              });
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Category deleted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              
              // Refresh categories from the repository
              context.read<GetCategoriesBloc>().add(const GetCategories());
            } else if (state is DeleteCategoryFailure) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<GetCategoriesBloc, GetCategoriesState>(
          listener: (context, state) {
            if (state is GetCategoriesSuccess) {
              setState(() {
                categories = state.categories;
                _updateCategoryNames();
                
                // If no categories exist, create some default ones
                if (categories.isEmpty) {
                  _createDefaultCategories();
                }
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Add Expense',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: fieldWidth * 0.7,
                    child: TextField(
                      textAlign: TextAlign.left,
                      controller: addExpenseController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        prefixIcon: const Icon(FontAwesomeIcons.indianRupeeSign),
                        hintText: '0',
                        hintStyle: GoogleFonts.nunitoSans(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    width: fieldWidth,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          hint: Row(
                            children: [
                              const Icon(FontAwesomeIcons.list, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'Category',
                                style: GoogleFonts.nunitoSans(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          icon: const Icon(
                            FontAwesomeIcons.caretDown,
                            color: Colors.grey,
                          ),
                          style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue == 'Create Category') {
                              _showCreateCategoryDialog();
                            } else {
                              setState(() {
                                selectedCategory = newValue!;
                              });
                            }
                          },
                          items: categoryNames.map<DropdownMenuItem<String>>((String value) {
                            IconData icon;
                            switch (value) {
                              case 'Food':
                                icon = FontAwesomeIcons.utensils;
                                break;
                              case 'Shopping':
                                icon = FontAwesomeIcons.bagShopping;
                                break;
                              case 'Entertainment':
                                icon = FontAwesomeIcons.film;
                                break;
                              case 'Travel':
                                icon = FontAwesomeIcons.plane;
                                break;
                              case 'Create Category':
                                icon = FontAwesomeIcons.plus;
                                break;
                              default:
                                icon = FontAwesomeIcons.question;
                            }
                            
                            // Find the category object for this value
                            final category = categories.firstWhere(
                              (cat) => cat.name == value,
                              orElse: () => Category(
                                id: '',
                                name: '',
                                icon: '',
                                color: '',
                                type: CategoryType.expense,
                                createdAt: DateTime.now(),
                              ),
                            );
                            
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  FaIcon(icon, size: 18, color: Colors.grey[700]),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(value),
                                  ),
                                  if (value != 'Create Category' && category.id.isNotEmpty)
                                    GestureDetector(
                                      onTap: () {
                                        _deleteCategory(category.id, category.name);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Icon(
                                          Icons.delete_outline,
                                          size: 16,
                                          color: Colors.red.shade600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: fieldWidth,
                    child: TextField(
                      controller: addNoteController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(FontAwesomeIcons.noteSticky, color: Colors.grey),
                        hintText: "Note",
                        hintStyle: GoogleFonts.nunitoSans(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                      style: GoogleFonts.nunitoSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: fieldWidth,
                    child: TextField(
                      controller: addDateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime today = DateTime.now();
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: today,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            addDateController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          });
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(FontAwesomeIcons.calendarXmark, color: Colors.grey),
                        hintText: "Today",
                        hintStyle: GoogleFonts.nunitoSans(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                      style: GoogleFonts.nunitoSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      // TODO: Add your save logic here
                    },
                    child: Container(
                      width: fieldWidth,
                      height: 56,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.tertiary,
                          ],
                          transform: const GradientRotation(pi / 4),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'SAVE',
                          style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}