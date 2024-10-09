import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:untitled/presentation/login_screen.dart';
import 'package:untitled/presentation/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 5000,
        splash: Image.asset('assets/images/Smart-Applications-International-Logo.png'),
        nextScreen: RegisterScreen(),
        splashTransition: SplashTransition.slideTransition,
        pageTransitionType: PageTransitionType.leftToRight,
    );
  }
}
