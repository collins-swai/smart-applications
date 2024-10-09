import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/presentation/profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName; // Pass current name as an argument

  const EditProfileScreen({Key? key, required this.currentName}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController(); // Controller for name input
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName; // Set the current name in the controller
  }

  Future<void> _updateUserData() async {
    setState(() {
      _isLoading = true; // Show loader
    });

    try {
      User? user = _auth.currentUser; // Get the current user
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': _nameController.text.trim(), // Update the name in Firestore
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );

        // Delay for visibility of the message
        await Future.delayed(Duration(seconds: 1));

        // Navigate back to the ProfileScreen
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: const Color(0xFF00964D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController, // Controller to manage input
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                hintText: 'Enter your name',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateUserData, // Disable button while loading
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white) // Show loader on button
                  : Text('Save Changes'),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00964D)),
            ),
            if (_isLoading) // Show loader below button if loading
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
