import 'package:admin_sec_pro/screens/pending/pendingScreen/model/pending_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchPending {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<SaloonPendingModel>> getSalons() {
    return _firestore.collection('saloon_register').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
               Map<String, dynamic> data = doc.data();
        data['uid'] = doc.id; 
        return SaloonPendingModel.fromMap(data, data);
      }).toList();
    });
  }
}