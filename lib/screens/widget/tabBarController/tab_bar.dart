import 'package:admin_sec_pro/constant/colors.dart';
import 'package:admin_sec_pro/screens/approved/approvedScreen/approved_screen.dart';
import 'package:admin_sec_pro/screens/pending/pendingScreen/pending_screen.dart';
import 'package:admin_sec_pro/screens/rejected/rejectedScreen/rejected_screen.dart';
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
              color:Colors.blue.shade100, 
              child: TabBar(
                indicator: BoxDecoration(
                  color:AppColor.Cblue, 
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black, 
                indicatorSize: TabBarIndicatorSize.tab  , 
                tabs: const [
                  Tab(text: "Pending"),
                  Tab(text: "Approved"),
                  Tab(text: "Rejected"),
                ],
              ),
            ),
           Expanded(
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