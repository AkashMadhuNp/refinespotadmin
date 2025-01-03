import 'package:admin_sec_pro/screens/widget/bottonBar/bottom_bar.dart';
import 'package:admin_sec_pro/screens/widget/customTextFormField/custom_field.dart';
import 'package:admin_sec_pro/service/authentication/authentication.dart';
import 'package:admin_sec_pro/service/validation/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'weak-password':
        return 'Please enter a stronger password.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'internal-error':
        return 'Internal system error. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  final AuthServices _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please check all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final result = await _authServices.signUpUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _nameController.text.trim(),
      );

      if (result != "success") {
        throw AuthException(result);
      }

      final prefs = await SharedPreferences.getInstance();

      // Save user data to SharedPreferences
      await Future.wait([
        prefs.setString("userEmail", _emailController.text.trim()),
        prefs.setString("userName", _nameController.text.trim()),
        prefs.setBool("isLoggedIn", true),
      ]);

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the next screen 
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomBar()),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = "An error occurred during signup";
        
        if (e is AuthException) {
          errorMessage = e.toString();
        } else if (e is FirebaseAuthException) {
          errorMessage = _getFirebaseAuthErrorMessage(e.code);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Lottie.asset(
                      "asset/Login.json",
                      height: 300,
                      repeat: true,
                      reverse: true
                    ),
                  ),
                  
                  Text(
                    "CREATE \nACCOUNT",
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      color: Colors.grey
                    ),
                  ),
                  
                  CustomTextField(
                    controller: _emailController,
                    validator: ValidationService.validateEmail,
                    hint: "Email",
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                                     ),
                  
                  CustomTextField(
                    controller: _nameController,
                    validator: ValidationService.validateName,
                    hint: "Admin Name",
                    prefixIcon: Icons.person,
                   
                  ),
                  
                  CustomTextField(
                    controller: _passwordController,
                    validator: ValidationService.validatePassword,
                    hint: 'Create a strong password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_isPasswordVisible,
                   
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  CustomTextField(
                    controller: _confirmPasswordController,
                    validator: (value) => ValidationService.validateConfirmPassword(
                      value,
                      _passwordController.text
                    ),
                    hint: 'Confirm your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_isConfirmPasswordVisible,
                    
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(0, 76, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Sign Up',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}