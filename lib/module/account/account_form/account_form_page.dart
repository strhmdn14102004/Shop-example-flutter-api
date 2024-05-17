import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shop/overlay/error_overlay.dart';
import 'package:shop/overlay/success_overlay.dart';

class AccountFormPage extends StatefulWidget {
  @override
  _AccountFormPageState createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  File? _image;
  String _gender = '';
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUserDataFromFirestore();
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

  void _loadUserDataFromFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email!; // Ambil email pengguna saat ini

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(email) // Ambil dokumen berdasarkan email
            .get();

        if (userDoc.exists) {
          print(
              'Data from Firestore: ${userDoc.data()}'); // Print data from Firestore
          setState(() {
            // Isi kontrol formulir berdasarkan data yang diambil dari Firestore
            _fullNameController.text = userDoc['fullName'];
            _birthDateController.text = userDoc['birthDate'];
            _gender = userDoc['gender'];
          });

          // Load profile image URL if exists
          String? profileImageURL = userDoc['profileImageURL'];
          if (profileImageURL != null && profileImageURL.isNotEmpty) {
            // Load profile image from URL if exists
            // Download the image and store it locally
            try {
              final response = await http.get(Uri.parse(profileImageURL));
              final bytes = response.bodyBytes;

              // Save the image to local storage
              final directory = await getApplicationDocumentsDirectory();
              final imagePath = '${directory.path}/profile_image.jpg';
              File imageFile = File(imagePath);
              await imageFile.writeAsBytes(bytes);

              // Set the image file to the state
              setState(() {
                _image = imageFile;
              });
            } catch (e) {
              print('Error downloading profile image: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Error loading user data from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _selectImage(context);
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _imageUrl != null ? NetworkImage(_imageUrl!) : null,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    labelText: 'Birth Date',
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
              items: <String>['', 'Male', 'Female', 'Other']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Gender',
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _uploadDataToFirestore(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

 void _selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageUrl = null; // Reset imageUrl to null since a new image is chosen
      }
    });
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _birthDateController.text = pickedDate.toString();
      });
    }
  }

  void _uploadDataToFirestore(BuildContext context) async {
    try {
      String? email = FirebaseAuth
          .instance.currentUser?.email; // Ambil email pengguna saat ini
      if (email == null) {
        // Handle jika email pengguna tidak tersedia
        print('User email is null');
        return;
      }

      String fullName = _fullNameController.text.trim();
      String birthDate = _birthDateController.text.trim();
      String gender = _gender;

      // Validasi bahwa kedua kolom diisi
      if (fullName.isEmpty || birthDate.isEmpty || gender.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please fill in all fields.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // Menambahkan data ke Firestore berdasarkan email pengguna
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'fullName': fullName,
        'birthDate': birthDate,
        'gender': gender,
        // tambahkan foto profil jika ada
        'profileImageURL':
            _image != null ? await _uploadImageToFirebaseStorage() : null,
      });

      // Tampilkan dialog sukses
       Navigator.of(context).push(
        SuccessOverlay(
          message:
              "Profile Berhasil diupload",
        ),
      );
    } catch (e) {
      print('Error uploading data to Firestore: $e');
      // Tampilkan pesan error jika terjadi kesalahan
     Navigator.of(context).push(
        ErrorOverlay(
          message:
              "Profile Gagal diupload",
        ),
      );
    }
  }

  Future<String> _uploadImageToFirebaseStorage() async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(_image!);
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      throw e; // Re-throw error to handle it in the caller function
    }
  }
}
