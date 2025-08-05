import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../stats/chart.dart';
import '../../../ui_help/category_widget.dart';
import '../../main_screen/pages/main_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildChartSection(context),
            const SizedBox(height: 10),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDER METHODS ---

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Transactions',
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {
              // Using pushReplacement can be disorienting.
              // Consider using Navigator.pop(context) if this screen is pushed on top of the main screen.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            },
            icon: const FaIcon(FontAwesomeIcons.chartSimple, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection(BuildContext context) {
    return Flexible( // Use Flexible to allow the chart to resize
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // The column should only be as tall as its children
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  Text(
                    '01 July 2025 - 01 August 2025',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '₹3500',
                    style: GoogleFonts.lato(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Flexible( // Allows the chart to take up the remaining space inside the container
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: MyChart(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Expanded( // Use Expanded to fill the remaining space
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sat, 05 July 2025',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '- ₹500.00',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded( // Make the list itself expandable
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  ExpenseTile(
                    title: 'Food',
                    icon: Icons.fastfood,
                    amount: '- ₹200.00',
                    date: 'Today',
                  ),
                  ExpenseTile(
                    title: 'Shopping',
                    icon: Icons.shopping_cart,
                    amount: '- ₹200.00',
                    date: 'Today',
                  ),
                  ExpenseTile(
                    title: 'Entertainment',
                    icon: Icons.local_movies,
                    amount: '- ₹500.00',
                    date: 'Today',
                  ),
                  ExpenseTile(
                    title: 'Travel',
                    icon: Icons.airplane_ticket,
                    amount: '- ₹1000.00',
                    date: 'Today',
                  ),
                  ExpenseTile(
                    title: 'Bills',
                    icon: Icons.inventory_2,
                    amount: '- ₹500.00',
                    date: 'Today',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}