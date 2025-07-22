import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  String? selectedCategory;
  List<String> categories = ['Food', 'Shopping', 'Entertainment', 'Travel'];

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    addDateController.text = "${today.day}/${today.month}/${today.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.background),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add Expense',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 200,
                child: TextField(
                  textAlign: TextAlign.left,
                  controller: addExpenseController,
                  decoration: InputDecoration(
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
                width: 350,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      items:
                          categories.map<DropdownMenuItem<String>>((
                            String value,
                          ) {
                            IconData icon;
                            switch (value) {
                              case 'Food':
                                icon = FontAwesomeIcons.utensils;
                                break;
                              case 'Shopping':
                                icon = FontAwesomeIcons.shoppingBag;
                                break;
                              case 'Entertainment':
                                icon = FontAwesomeIcons.film;
                                break;
                              case 'Travel':
                                icon = FontAwesomeIcons.plane;
                                break;
                              default:
                                icon = FontAwesomeIcons.question;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  FaIcon(
                                    icon,
                                    size: 18,
                                    color: Colors.grey[700],
                                  ),
                                  SizedBox(width: 8),
                                  Text(value),
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
                width: 350,
                child: TextField(
                  textAlign: TextAlign.left,
                  controller: addNoteController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      FontAwesomeIcons.stickyNote,
                      color: Colors.grey,
                    ),
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
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 350,
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
                    prefixIcon: const Icon(
                      FontAwesomeIcons.calendarTimes,
                      color: Colors.grey,
                    ),
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
              const SizedBox(height: 250),
              GestureDetector(
                onTap: () {
                  // TODO: Add your save logic here
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.tertiary, // pink/orange
                      ],
                      transform: const GradientRotation(pi / 4),
                    ),
                  ),
                  child:  Center(
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
    );
  }
}
