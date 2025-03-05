import 'package:admin_sec_pro/screens/approved/approvedScreen/model/approved_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchApproved{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<SaloonApprovedModel>> getApprovedSaloons(){
    return _firestore.collection("approved_saloon").snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        Map<String,dynamic> data = doc.data();
        data['uid'] = doc.id;
        return SaloonApprovedModel.fromMap(data,data);
      }).toList();
    });
  }
}