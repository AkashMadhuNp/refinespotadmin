import 'package:admin_sec_pro/screens/approved/approvedScreen/widget/approved_saloon_card.dart';
import 'package:flutter/material.dart';
import 'package:admin_sec_pro/screens/approved/approvedScreen/model/approved_model.dart';
import 'package:admin_sec_pro/screens/approved/approvedScreen/service/fetch_approved.dart';

class ApprovedScreen extends StatelessWidget {
  final FetchApproved _firebaseService = FetchApproved();

  ApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: StreamBuilder<List<SaloonApprovedModel>>(
        stream: _firebaseService.getApprovedSaloons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final salons = snapshot.data ?? [];
          
          if (salons.isEmpty) {
            return const Center(
              child: Text(
                'No approved salons yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: salons.length,
            itemBuilder: (context, index) => 
              ApprovedSalonCard(salon: salons[index]),
          );
        },
      ),
    );
  }
}