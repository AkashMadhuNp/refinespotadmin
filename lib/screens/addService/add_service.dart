import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:admin_sec_pro/constant/colors.dart';
import 'package:admin_sec_pro/model/service_model.dart';
import 'package:admin_sec_pro/screens/widget/customTextFormField/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  String? _cloudinaryUrl;
  List<Service> _services = [];
  final TextEditingController _serviceTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _imageError;
  bool _isLoading = false;
  StreamSubscription<QuerySnapshot>? _servicesSubscription;

  // Firebase collection reference
  final CollectionReference _servicesCollection = 
      FirebaseFirestore.instance.collection('services');

  @override
  void initState() {
    super.initState();
    _subscribeToServices();
  }

  void _subscribeToServices() {
    _servicesSubscription = _servicesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        setState(() {
          _services = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Service(
              id: doc.id,
              name: data['name'] as String,
              imagePath: data['imageUrl'] as String,
            );
          }).toList();
        });
      }
    }, onError: (error) {
      _showSnackBar('Error loading services: $error');
    });
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status.isDenied) {
        final result = await Permission.storage.request();
        return result.isGranted;
      }
      return status.isGranted;
    }
    return true;
  }

  Future<void> _pickImage() async {
    try {
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        _showSnackBar('Permission denied');
        return;
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageError = null;
          _cloudinaryUrl = null;
        });
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e');
    }
  }

  Future<String?> _uploadToCloudinary() async {
    if (_imageFile == null) return null;

    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dtdddixzr/upload');
      final request = http.MultipartRequest('POST', url);
      
      request.fields['upload_preset'] = 'servicefolder';
      request.files.add(
        await http.MultipartFile.fromPath('file', _imageFile!.path)
      );

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
      _showSnackBar('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      setState(() => _imageError = 'Please select an image');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imageUrl = await _uploadToCloudinary();
      if (imageUrl == null) throw Exception('Failed to upload image');

      final serviceName = _serviceTextController.text.trim();
      final serviceData = {
        'name': serviceName,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _servicesCollection.add(serviceData);

      setState(() {
        _imageFile = null;
        _cloudinaryUrl = null;
        _imageError = null;
        _serviceTextController.clear();
        _formKey.currentState!.reset();
      });

      _showSnackBar('Service added successfully', isError: false);
    } catch (e) {
      _showSnackBar('Error saving service: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteService(Service service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Service', style: GoogleFonts.montserrat()),
        content: Text(
          'Are you sure you want to delete ${service.name}?',
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.montserrat()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: GoogleFonts.montserrat(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        setState(() => _isLoading = true);
        await _servicesCollection.doc(service.id).delete();
        _showSnackBar('Service deleted successfully', isError: false);
      } catch (e) {
        _showSnackBar('Error deleting service: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.montserrat(),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _serviceTextController.dispose();
    _servicesSubscription?.cancel();
    super.dispose();
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: AppColor.mainGradient,
        ),
      ),
      title: Text(
        "ADD SERVICES",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          color: AppColor.white,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      gradient: AppColor.cardGradient,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image picker section with enhanced styling
                          GestureDetector(
                            onTap: _isLoading ? null : _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.white,
                                backgroundImage: _imageFile != null
                                    ? FileImage(_imageFile!)
                                    : null,
                                child: _imageFile == null
                                    ? Icon(
                                        Icons.add_a_photo,
                                        size: 40,
                                        color: Colors.grey[700],
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          if (_imageError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _imageError!,
                                style: TextStyle(
                                  color: Colors.red[100],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          // Enhanced text field styling
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: CustomTextField(
                              controller: _serviceTextController,
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  return "Service name is required";
                                }
                                
                              },
                              hint: "Service Name",
                              prefixIcon: Icons.design_services,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Enhanced button styling
                          ElevatedButton(
                            onPressed: _isLoading ? null : _saveService,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              _isLoading ? "Saving..." : "Save Service",
                              style: GoogleFonts.montserrat(
                                color: AppColor.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _services.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No services added yet",
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _services.length,
                          itemBuilder: (context, index) {
                            final service = _services[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(service.imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                title: Text(
                                  service.name,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : () => _deleteService(service),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}}