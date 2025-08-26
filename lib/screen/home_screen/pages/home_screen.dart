import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_app/screen/transaction_screen/pages/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import '../../add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import '../../add_expense/blocs/delete_category_bloc/delete_category_bloc.dart';
import '../../add_expense/pages/add_expense_screen.dart';
import '../../main_screen/pages/main_screen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int index = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          onTap: (value){
            setState(() {
              index = value;
            });
            _pageController.animateToPage(
              value,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          backgroundColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: index,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            elevation: 3,
            items: const [
              BottomNavigationBarItem(
                label: 'home',
                icon:Icon(Icons.home_rounded) ),
              BottomNavigationBarItem(icon: Icon(Icons.settings),
              label: 'Settings'),
            ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) {
                // Wrap AddExpenseScreen with multiple BlocProviders
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<CreateCategoryBloc>(
                      create: (context) => CreateCategoryBloc(
                        expenseRepository: context.read<ExpenseRepository>(),
                      ),
                    ),
                    BlocProvider<GetCategoriesBloc>(
                      create: (context) => GetCategoriesBloc(
                        expenseRepository: context.read<ExpenseRepository>(),
                      ),
                    ),
                    BlocProvider<DeleteCategoryBloc>(
                      create: (context) => DeleteCategoryBloc(
                        expenseRepository: context.read<ExpenseRepository>(),
                      ),
                    ),
                  ],
                  child: const AddExpenseScreen(),
                );
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.80, end: 1.0)
                        .chain(CurveTween(curve: Curves.easeInOut))
                        .animate(animation),
                    child: child,
                  ),
                );
              },
            ),
          );
        },
        shape: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary,
              ],
              transform: const GradientRotation(pi/4),
            )
          ),
            child: const Icon(Icons.add)),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            index = value;
          });
        },
        children: const [
          MainScreen(),
          TransactionScreen(),
        ],
      ),
    );
  }
}