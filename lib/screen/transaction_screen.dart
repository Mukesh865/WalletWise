import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Transactions',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                      },
                      icon: FaIcon(FontAwesomeIcons.chartSimple, size: 20),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: screenWidth,
              height: screenHeight/2,
              color: Colors.red,
              child: BarChart(),
            )
          ],
        ),
      ),
    );
  }
}
