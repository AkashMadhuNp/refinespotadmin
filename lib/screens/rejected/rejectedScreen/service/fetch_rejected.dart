import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/rejected_model.dart';

class FetchRejected {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<SaloonRejectedModel>> getRejectedSaloons() {
    return _firestore.collection("rejected_saloon").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return SaloonRejectedModel.fromMap(data,data);
      }).toList();
    });
  }
}
