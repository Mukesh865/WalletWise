import 'package:expense_tracker_app/screen/home_screen/pages/home_screen.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_app/screen/login_screen/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppView extends StatelessWidget{
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ExpenseRepository>(
      create: (context) => FirebaseExpenseRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Expense Tracker",
        theme: ThemeData(
            colorScheme: ColorScheme.light(
              surface: Colors.grey.shade100,
                onSurface: Colors.black,
                primary: Color(0xFF00B2E7),
                secondary: Color(0xFFE064F7),
              tertiary: Color(0xFFFF8D6C),
              outline: Colors.grey.shade400,
                )
        ),
        home: const LoginForm(),
      ),
    );
  }

}