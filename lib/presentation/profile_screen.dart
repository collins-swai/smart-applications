import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/presentation/edit_profile_screen.dart';
import 'package:untitled/presentation/login_screen.dart';
import 'package:untitled/theme/color_constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser; // Get the current user
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            userName = userDoc.get('name'); // Assuming 'name' is the field in Firestore
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () async {
                await _auth.signOut(); // Sign out the user
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double widthScale = screenWidth / 414;
    double heightScale = screenHeight / 896;

    return Scaffold(
      backgroundColor: ColorConstant.whiteA700,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(103 * heightScale),
        child: Stack(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF00964D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20 * widthScale),
                  bottomRight: Radius.circular(20 * widthScale),
                ),
              ),
              elevation: 0,
            ),
            Positioned(
              top: 75 * heightScale,
              left: 24 * widthScale,
              child: Container(
                width: 366.14 * widthScale,
                height: 37 * heightScale,
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 24 * widthScale,
                      fontWeight: FontWeight.w500,
                      height: 30 / 24,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 75 * heightScale,
              left: 370 * widthScale,
              child: Container(
                width: 20.14 * widthScale,
                height: 20 * heightScale,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.circular(4 * widthScale),
                ),
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 24 * widthScale,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 23 * heightScale,
            left: 21.5 * widthScale,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 25 * widthScale,
                color: const Color(0xFF445668),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 68 * heightScale,
            left: 157 * widthScale,
            child: CircleAvatar(
              radius: 50, // Set the radius
              backgroundColor: Colors.grey, // Placeholder background color
              backgroundImage: AssetImage('assets/images/avatar-5.png'), // Use backgroundImage for circular effect
            ),
          ),
          Positioned(
            top: 178 * heightScale, // Adjust the top position
            left: 93 * widthScale,  // Center the text under the avatar
            child: Container(
              width: 199 * widthScale,
              height: 23 * heightScale,
              color: Colors.white, // Background color
              child: Center( // Center the text within the container
                child: Text(
                  userName.isNotEmpty ? userName : 'Loading...', // Replace with the actual name
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 18 * widthScale,
                    fontWeight: FontWeight.w500,
                    height: 22.5 / 18, // Line height
                    color: Color(0xFF0D1829), // Text color
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            top: 236 * heightScale,
            left: 22 * widthScale,
            child: Container(
              width: 371 * widthScale,
              height: 54 * heightScale,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16 * widthScale),
                    child: CircleAvatar(
                      radius: 18 * widthScale,
                      backgroundColor: Color(0xFFF0F2F6),
                      child: Icon(
                        Icons.person_outline,
                        size: 36 * widthScale,
                        color: Color(0xFF0D1829), // Change icon color if needed
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 22 * widthScale),
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 16 * widthScale,
                        fontWeight: FontWeight.w500,
                        height: 20 / 16,
                        color: Color(0xFF0D1829), // Text color
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 16 * widthScale),
                    child: Transform.rotate(
                      angle: 180 * 3.1415926535897932 / 180,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(currentName: userName),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 18 * widthScale,
                          color: Color(0xFF445668), // Icon color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 290 * heightScale,
            left: 26 * widthScale,
            child: Container(
              width: 367 * widthScale,
              height: 0, // Height set to 0 for an underline effect
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFF96DDD9), // Border color
                    width: 1, // Border width
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 296 * heightScale,
            left: 22 * widthScale,
            child: Container(
              width: 371 * widthScale,
              height: 54 * heightScale,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16 * widthScale),
                    child: CircleAvatar(
                      radius: 18 * widthScale,
                      backgroundColor: Color(0xFFF0F2F6),
                      child: Icon(
                        Icons.badge_outlined,
                        size: 36 * widthScale,
                        color: Color(0xFF0D1829), // Change icon color if needed
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 22 * widthScale),
                    child: Text(
                      'Terms and Conditions',
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 16 * widthScale,
                        fontWeight: FontWeight.w500,
                        height: 20 / 16,
                        color: Color(0xFF0D1829), // Text color
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 16 * widthScale),
                    child: Transform.rotate(
                      angle: 180 * 3.1415926535897932 / 180,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 18 * widthScale,
                        color: Color(0xFF445668), // Icon color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 350 * heightScale,
            left: 26 * widthScale,
            child: Container(
              width: 367 * widthScale,
              height: 0,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFF96DDD9), // Border color
                    width: 1, // Border width
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 546 * heightScale,
            left: 22 * widthScale,
            child: GestureDetector(
              onTap: _showLogoutDialog,
              child: Container(
                width: 371 * widthScale,
                height: 54 * heightScale,
                color: Colors.white, // Set the background color here
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16 * widthScale),
                      child: CircleAvatar(
                        radius: 18 * widthScale,
                        backgroundColor: Color(0xFFF0F2F6),
                        child: Icon(
                          Icons.logout_outlined,
                          size: 26 * widthScale,
                          color: Colors.red, // Change icon color if needed
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12 * widthScale),
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 16 * widthScale,
                          fontWeight: FontWeight.w500,
                          height: 20 / 16,
                          color: Colors.red, // Text color
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
