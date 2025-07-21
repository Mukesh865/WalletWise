import 'dart:math';

import 'package:expense_tracker_app/screen/transaction_screen.dart';
import 'package:flutter/material.dart';

import 'add_expense_screen.dart';
import 'main_screen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int index = 0;
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
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpenseScreen()));
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
      body: index == 0 ? MainScreen() : TransactionScreen(),
    );
  }
}