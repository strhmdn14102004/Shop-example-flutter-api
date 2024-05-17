import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/helper/dimension.dart';
import 'package:shop/module/auth/signup/signup_page.dart';
import 'package:shop/module/home/home_page.dart';
import 'package:shop/overlay/error_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      _emailController.clear();
      _passwordController.clear();
      setState(() {
        _errorMessage = '';
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

      print('User signed in: ${userCredential.user!.email}');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });

      // Show error message using ScaffoldMessenger
      Navigator.of(context).push(
        ErrorOverlay(
          message: "Login Gagal, Periksa Kembali Password Kamu",
        ),
      );

      print('Sign in error: $_errorMessage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container()
    );
  }
}
