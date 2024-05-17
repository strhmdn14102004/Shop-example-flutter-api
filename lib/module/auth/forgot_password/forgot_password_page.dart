import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/helper/dimension.dart';
import 'package:shop/module/auth/login/login_page.dart';
import 'package:shop/overlay/error_overlay.dart';
import 'package:shop/overlay/success_overlay.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = '';

  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      _emailController.clear();
      setState(() {
        _errorMessage = '';
      });
      Navigator.of(context).push(
        SuccessOverlay(
          message:
              "Reset Berhasil, Link Reset Password Dikirimkan Ke email kamu.",
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => LoginScreen()), // Navigate back to login
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      print('Password reset error: $_errorMessage');
      Navigator.of(context).push(
        ErrorOverlay(
          message: "$_errorMessage",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/shop.png', // Add your Shopee logo image asset
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: Dimensions.size10),
          Text(
            "Reset Password",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          SizedBox(height: 20),
          Padding(
           padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0), // Adjust the radius as needed
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _sendPasswordResetEmail(context),
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );
  }
}
