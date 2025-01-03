import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, {this.code});

  @override
  String toString() => message;
}

String _getFirebaseAuthErrorMessage(String code) {
  switch (code) {
    case 'user-not-found':
      return 'No account found with this email.';
    case 'wrong-password':
      return 'Incorrect password.';
    case 'invalid-email':
      return 'Invalid email format.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'too-many-requests':
      return 'Too many failed attempts. Please try again later.';
    default:
      return 'Authentication failed: $code';
  }
}

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection("adminlog").doc(credential.user!.uid).set({
        "name": username,
        "email": email,
        'uid': credential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Set login state in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Authentication error occurred";
    } on FirebaseException catch (e) {
      return e.message ?? "Database error occurred";
    } catch (e) {
      return e.toString();
    }
  }

  Future<User?> loginUserWithEmailandPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _firestore.collection("adminlog").doc(credential.user!.uid).set({
          'lastLogin': FieldValue.serverTimestamp(),
          'email': credential.user!.email,
          'uid': credential.user!.uid,
        }, SetOptions(merge: true));

        // Set login state in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getFirebaseAuthErrorMessage(e.code), code: e.code);
    } catch (e) {
      throw AuthException("Failed to Sign in: ${e.toString()}",
          code: "unknown-error");
    }
  }

  Future<void> signOut() async {
    try {
      // Clear login state from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      await Future.wait([
        _auth.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Failed to sign out: ${e.toString()}');
    }
  }
}