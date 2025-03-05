import 'package:admin_sec_pro/screens/pending/pendingScreen/model/pending_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApproveRejectionService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> approveSaloon(SaloonPendingModel saloon)async{
    try{
      await _firestore.collection("approved_saloon").doc(saloon.uid).set({
        'uid': saloon.uid,
        'name': saloon.name,
        'email': saloon.email,
        'phone': saloon.phone,
        'saloonName': saloon.saloonName,
        'location': saloon.location,
        'shopUrl': saloon.shopUrl,
        'profileUrl': saloon.profileUrl,
        'licenseUrl': saloon.licenseUrl,
        'coordinates': saloon.coordinates,
        'holidays': saloon.holidays,
        'services': saloon.services,
        'workingHours': saloon.workingHours,
        'status': 'approved',
        'approvedAt': FieldValue.serverTimestamp(),


      });

      await _firestore.collection('saloon_register').doc(saloon.uid).delete();

    }catch(e){
      throw Exception("Failed to approve Saloon : $e");

    }
  }


  Future<void> rejectSaloon(SaloonPendingModel saloon)async{
    try{
      await _firestore.collection("rejected_saloon").doc(saloon.uid).set({
        'uid': saloon.uid,
        'name': saloon.name,
        'email': saloon.email,
        'phone': saloon.phone,
        'saloonName': saloon.saloonName,
        'location': saloon.location,
        'shopUrl': saloon.shopUrl,
        'profileUrl': saloon.profileUrl,
        'licenseUrl': saloon.licenseUrl,
        'coordinates': saloon.coordinates,
        'holidays': saloon.holidays,
        'services': saloon.services,
        'workingHours': saloon.workingHours,
        'status': 'approved',
        'approvedAt': FieldValue.serverTimestamp(),


      });

      await _firestore.collection('saloon_register').doc(saloon.uid).delete();

    }catch(e){
      throw Exception("Failed to reject Saloon : $e");

    }
  }

}