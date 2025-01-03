import 'package:admin_sec_pro/screens/splashScreen/splash.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  await Permission.storage.request();
  await Permission.camera.request();
}

void main() async {
  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: "dtdddixzr");
  try {
    await initializeApp();
  } catch (e) {
    print('Error initializing app: $e');
  }
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: child,
        );
      },
    );
  }
}