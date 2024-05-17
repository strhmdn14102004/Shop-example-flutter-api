import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/overlay/success_overlay.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _signupSuccess = false;

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _emailController.clear();
      _passwordController.clear();
      setState(() {
        _errorMessage = '';
        _signupSuccess = true;
      });
      Navigator.of(context).push(
        SuccessOverlay(
          message:
              "Regist Akun Dengan Email\n${userCredential.user!.email}\nBerhasil",
        ),
      );
      setState(() {});
      print('User signed up: ${userCredential.user!.email}');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      print('Sign up error: $_errorMessage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: true, body: Container());
  }
}
