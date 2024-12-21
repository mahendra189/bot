import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:bot/utils/auth_service/auth_service.dart';
import '../../utils/bottomNavBar/bottom_Nav_Bar.dart';

class LoginModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> saveUserIdToLocal(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('UID', userId);
  }

  void login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      User? user = await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      if (user != null) {
        String userId = user.uid;
        await saveUserIdToLocal(userId);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const NavigationMenu()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      }
    }
  }
}