import 'package:flutter/material.dart';
import 'model/rejected_model.dart';
import 'service/fetch_rejected.dart';
import 'widget/rejected_saloon_card.dart';

class RejectedScreen extends StatelessWidget {
  final FetchRejected _firebaseService = FetchRejected();
  
  RejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: StreamBuilder<List<SaloonRejectedModel>>(
        stream: _firebaseService.getRejectedSaloons(),
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
                'No rejected salons yet',
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
            itemBuilder: (context, index) => RejectedSaloonCard(salon: salons[index]),
          );
        },
      ),
    );
  }
}


