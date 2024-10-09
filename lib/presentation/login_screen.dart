import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/presentation/register_screen.dart';

import 'bottom_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController companyCodeController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isHidden = true;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double widthScale = screenWidth / 400;
    double heightScale = screenHeight / 800;

    final companyField = Container(
      width: 348 * widthScale,
      height: 60 * heightScale,
      padding: EdgeInsets.symmetric(horizontal: 16 * widthScale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * widthScale),
        border: Border.all(
          color: Color(0xFF30BEB6),
          width: 1 * widthScale,
        ),
      ),
      child: TextFormField(
        controller: companyCodeController,
        decoration: InputDecoration(
          labelText: 'Name',
          labelStyle: TextStyle(
            fontFamily: 'Lexend',
            fontSize: 16 * widthScale,
            fontWeight: FontWeight.w400,
            color: Color(0xFF445668),
          ),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'The name is required.';
          }
          return null;
        },
        style: TextStyle(
          fontFamily: 'Lexend',
          fontSize: 16 * widthScale,
          fontWeight: FontWeight.w400,
          color: Color(0xFF16151C),
        ),
      ),
    );

    final emailField = Container(
      width: 348 * widthScale,
      height: 60 * heightScale,
      padding: EdgeInsets.symmetric(horizontal: 16 * widthScale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * widthScale),
        border: Border.all(
          color: Color(0xFF30BEB6),
          width: 1 * widthScale,
        ),
      ),
      child: TextFormField(
        controller: emailAddressController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'The email field is required.';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Email Address',
          labelStyle: TextStyle(
            fontFamily: 'Lexend',
            fontSize: 16 * widthScale,
            fontWeight: FontWeight.w400,
            color: Color(0xFF445668),
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontFamily: 'Lexend',
          fontSize: 16 * widthScale,
          fontWeight: FontWeight.w400,
          color: Color(0xFF16151C),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );

    final passwordField = Container(
      width: 348 * widthScale,
      height: 60 * heightScale,
      padding: EdgeInsets.symmetric(horizontal: 16 * widthScale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * widthScale),
        border: Border.all(
          color: Color(0xFF30BEB6),
          width: 1 * widthScale,
        ),
      ),
      child: TextFormField(
        controller: passwordController,
        obscureText: _isHidden,
        validator: (value) {
          if (value!.isEmpty) {
            return "Password";
          } else if (value.length < 6) {
            return "Password";
          }
          return null;
        },
        decoration: InputDecoration(
          suffix: InkWell(
            onTap: _togglePasswordView,
            child: Icon(
              _isHidden ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          labelText: 'Password',
          labelStyle: TextStyle(
            fontFamily: 'Lexend',
            fontSize: 16 * widthScale,
            fontWeight: FontWeight.w400,
            color: Color(0xFF445668),
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontFamily: 'Lexend',
          fontSize: 16 * widthScale,
          fontWeight: FontWeight.w400,
          color: Color(0xFF16151C),
        ),
      ),
    );

    final forgotPasswordButton = Positioned(
      top: 594 * heightScale,
      right: 20 * widthScale,
      child: Container(
        width: 143 * widthScale,
        height: 16 * heightScale,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            minimumSize: Size(113 * widthScale, 16 * heightScale),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Dont have Acounnt?',
            style: TextStyle(
              fontFamily: 'Lexend',
              fontSize: 13 * widthScale,
              fontWeight: FontWeight.w400,
              height: 16.25 / 13,
              // Line height relative to font size
              color: Color(0xFF30BEB6),
            ),
            textAlign: TextAlign.right,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterScreen()));
          },
        ),
      ),
    );

    final loginButton = Positioned(
      top: 637 * heightScale,
      left: 20 * widthScale,
      child: Container(
        width: 354 * widthScale,
        height: 60 * heightScale,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF16AD4D), // Button color
            foregroundColor: Colors.white, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14 * widthScale),
                topRight: Radius.circular(14 * widthScale),
                bottomLeft: Radius.circular(14 * widthScale),
                bottomRight: Radius.circular(14 * widthScale),
              ),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Container(
            alignment: Alignment.center,
            child: _isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 16 * widthScale,
                      fontWeight: FontWeight.w400,
                      height: 20 / 16,
                      color: Color(0xFFFFFFFF), // Text color
                    ),
                  ),
          ),
          onPressed: _isLoading ? null : _login,
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: 125 * heightScale,
              left: 34 * widthScale,
              child: Row(
                children: [
                  Container(
                    width: 133 * widthScale,
                    height: 73 * heightScale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36.5 * widthScale),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36.5 * widthScale),
                      ),
                      child: Image.asset(
                        'assets/images/Smart-Applications-International-Logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10 * widthScale),
                ],
              ),
            ),
            Positioned(
              top: 222 * heightScale,
              left: 32 * widthScale,
              child: Container(
                width: 300 * widthScale,
                height: 70 * heightScale,
                color: Colors.transparent,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: 'Welcome Back to \n',
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 28 * widthScale,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        color: Color(0xFF16151C),
                      ),
                      children: [
                        TextSpan(
                          text: 'Health',
                          style: TextStyle(
                            color: Color(0xFF00964D),
                            fontFamily: 'Lexend',
                            fontSize: 28 * widthScale,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 307 * heightScale,
              left: 31 * widthScale,
              child: Container(
                width: 224 * widthScale,
                height: 20 * heightScale,
                child: Text(
                  'Hello there, login to continue',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 16 * widthScale,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    color: Color(0xFF445668),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Positioned(
              top: 351 * heightScale,
              left: 25 * widthScale,
              child: companyField,
            ),
            Positioned(
              top: 431 * heightScale,
              left: 25 * widthScale,
              child: emailField,
            ),
            Positioned(
              top: 511 * heightScale,
              left: 25 * widthScale,
              child: passwordField,
            ),
            forgotPasswordButton,
            loginButton,
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Set loading to true when login starts
    });
    try {
      final email = emailAddressController.text.trim();
      final password = passwordController.text.trim();

      // Attempt to sign in the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        final userName = userDoc.get('name');
        print('Logged in as: $userName');

        _showSnackBar(context, "Welcome, $userName");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomScreen()));
      } else {
        print('User does not exist in Firestore.');
        _showSnackBar(context, 'User does not exist. Please register.');
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase specific errors
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email. Please register.';
          break;
        case 'wrong-password':
          message = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = 'An unexpected error occurred. Please try again.';
          break;
      }
      _showSnackBar(context, message);
    } catch (e) {
      print('Login failed: $e');
      _showSnackBar(context, 'An error occurred. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false after login attempt
      });
    }
  }


  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
