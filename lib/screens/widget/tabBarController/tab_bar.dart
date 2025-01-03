import 'package:admin_sec_pro/constant/colors.dart';
import 'package:admin_sec_pro/screens/approvedScreen/approved_screen.dart';
import 'package:admin_sec_pro/screens/pendingScreen/pending_screen.dart';
import 'package:admin_sec_pro/screens/rejectedScreen/rejected_Screen.dart';
import 'package:flutter/material.dart';

class TabBarController extends StatelessWidget {
  const TabBarController({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 400,
        child: Column(
          children: [
            Container(
              color:Colors.blue.shade100, // Background color of the TabBar
              child: TabBar(
                indicator: BoxDecoration(
                  color:AppColor.Cblue, // Selected tab background color
                  borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                ),
                labelColor: Colors.white, // Selected text color
                unselectedLabelColor: Colors.black, // Unselected text color
                indicatorSize: TabBarIndicatorSize.tab  , // Makes indicator match tab size
                tabs: const [
                  Tab(text: "Pending"),
                  Tab(text: "Accepted"),
                  Tab(text: "Rejected"),
                ],
              ),
            ),
           const Expanded(
              child: TabBarView(
                children: [
                  PendingScreen(),
                  ApprovedScreen(),
                  RejectedScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}