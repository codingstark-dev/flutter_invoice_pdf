import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:invoice_pdf_generate/Controller/pdfController.dart';
import 'package:invoice_pdf_generate/Controller/sharedController.dart';
import 'package:invoice_pdf_generate/Screens/CompanyScreen.dart';
import 'package:invoice_pdf_generate/style/ConstStyle.dart';
import 'package:pdf/pdf.dart';
import 'file_handle_api.dart';
import 'pdf_invoice_api.dart';

void main() {
  //  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
     List<GetPage> routers = [
        GetPage(
          name: "/home",
          page: () => const CompanyScreen(),

          transition: Transition.leftToRightWithFade,
          opaque: false,
          showCupertinoParallax: true,
        )
      ];
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme:  ColorScheme(
          background: Colors.white,
          brightness: Brightness.light,
          primary: primaryColor,
          secondary: secondaryColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.black,
          onError: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          surface: Colors.white,
        ),
        // primaryColor: const Color(0xffFBCD08),
      ),
      // title: 'Invoice PDF Generate',
      home:
            CompanyScreen(),
        
    );
  }
}

