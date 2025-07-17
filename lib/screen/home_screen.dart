import 'dart:math';

import 'package:flutter/material.dart';

import 'main_screen.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
            selectedItemColor: Colors.grey.shade800,
            unselectedItemColor: Colors.grey.shade400,
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
        onPressed: (){},
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
      body: const MainScreen(),
    );
  }

}