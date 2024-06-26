import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/helper/dimension.dart';
import 'package:shop/module/account/account_form/account_form_page.dart';
import 'package:shop/module/auth/forgot_password/forgot_password_page.dart';
import 'package:shop/module/auth/login/login_page.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  void _loadProfileImage() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email!;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .get();

        if (userDoc.exists) {
          setState(() {
            _imageUrl = userDoc[
                'profileImageURL']; // Ambil URL gambar profil dari Firestore
          });
        }
      }
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String email = user != null ? user.email ?? "" : "";

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage:
                      _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                ),
                if (_imageUrl == null)
                  Positioned.fill(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              email,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountFormPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15), // Increase padding
                  minimumSize:
                      const Size(double.infinity, 50), // Set button size
                ),
                child: const Text(
                  'Profilku',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.size20,
            ),
            Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  _resetPassword(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15), // Increase padding
                  minimumSize:
                      const Size(double.infinity, 50), // Set button size
                ),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () {
          _showLogoutConfirmationDialog(context);
        },
        child: const Icon(Icons.door_back_door_outlined),
      ),
    );
  }

  void _resetPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin logout?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context);
            },
            child: const Text("Ya, Logout"),
          ),
        ],
      );
    },
  );
}

void _logout(BuildContext context) {
  FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
}
