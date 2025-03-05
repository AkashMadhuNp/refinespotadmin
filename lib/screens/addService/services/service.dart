
import 'dart:convert';
import 'dart:io';
import 'package:admin_sec_pro/model/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ServiceManager {
  final CollectionReference _servicesCollection = 
      FirebaseFirestore.instance.collection('services');
  final ImagePicker _picker = ImagePicker();


  Future<bool> requestPermissions() async {
    if (!Platform.isAndroid) return true;
    
    final status = await Permission.storage.status;
    if (status.isDenied) {
      final result = await Permission.storage.request();
      return result.isGranted;
    }
    return status.isGranted;
  }

  Future<File?> pickImage() async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        throw Exception('Permission denied');
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      throw Exception('Error picking image: $e');
    }
  }

  Future<String> uploadToCloudinary(File imageFile) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dtdddixzr/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'servicefolder'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        return jsonMap['secure_url'] as String;
      } else {
        throw HttpException('Upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  
  Stream<List<Service>> getServices() {
    return _servicesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Service(
                id: doc.id,
                name: data['name'] as String,
                imagePath: data['imageUrl'] as String,
              );
            }).toList());
  }

  Future<void> addService(String name, String imageUrl) async {
    try {
      await _servicesCollection.add({
        'name': name,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error adding service: $e');
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      await _servicesCollection.doc(serviceId).delete();
    } catch (e) {
      throw Exception('Error deleting service: $e');
    }
  }
}