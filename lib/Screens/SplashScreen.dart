//create splash screen for 3 seconds
//       home: SplashScreen(),
//     );

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice_pdf_generate/style/ConstStyle.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAndToNamed('/onboarding');
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Image.asset(
          'assets/splash.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}