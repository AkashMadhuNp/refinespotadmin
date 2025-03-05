import 'package:admin_sec_pro/screens/widget/tabBarController/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea( 
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            backgroundColor: Colors.blue.shade100,
            title: Padding( 
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                "REFINE SPOT",
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            centerTitle: true, 
            elevation: 2,
          ),
        ),
        body: Column(
          children: const [
            Expanded(
              child: TabBarController(),
            ),
          ],
        ),
      ),
    );
  }
}
