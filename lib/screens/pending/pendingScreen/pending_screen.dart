import 'package:admin_sec_pro/screens/pending/pendingScreen/model/pending_model.dart';
import 'package:admin_sec_pro/screens/pending/pendingScreen/service/fetch_pending.dart';
import 'package:admin_sec_pro/screens/pending/pendingScreen/widget/saloon_card.dart';
import 'package:flutter/material.dart';

class PendingScreen extends StatelessWidget {
  final FetchPending _firebaseService = FetchPending();

  PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<SaloonPendingModel>>(
        stream: _firebaseService.getSalons(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
      
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
      
          final salons = snapshot.data!;
      
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1, 
              crossAxisSpacing: 8, 
              mainAxisSpacing: 8, 
            ),
            itemCount: salons.length,
            itemBuilder: (context, index) => SalonCard(salon: salons[index]),
          );
        },
      ),
    );
  }
}