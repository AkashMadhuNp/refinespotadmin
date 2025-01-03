import 'package:admin_sec_pro/screens/loginScreen/login_screen.dart';
import 'package:admin_sec_pro/screens/widget/bottonBar/bottom_bar.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<Widget> checkLoginStatus() async {
    // Check both Firebase Auth and SharedPreferences
    final currentUser = _auth.currentUser;
    final prefs = await SharedPreferences.getInstance();

    if (currentUser != null) {
      // User is logged in with Firebase, update SharedPreferences
      await prefs.setBool('isLoggedIn', true);
      return const BottomBar();
    } else {
      // No Firebase user, clear SharedPreferences
      await prefs.setBool('isLoggedIn', false);
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show splash screen while checking auth state
          return AnimatedSplashScreen(
            splash: Lottie.asset("asset/splashscreen.json"),
            nextScreen: const CircularProgressIndicator(),
            duration: 6000,
          );
        }

        // Navigation to appropriate screen
        return AnimatedSplashScreen(
          splash: Lottie.asset("asset/splashscreen.json"),
          nextScreen: snapshot.data ?? const LoginScreen(),
          duration: 6000,
        );
      },
    );
  }
}