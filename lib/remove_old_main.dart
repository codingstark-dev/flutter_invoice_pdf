
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice_pdf_generate/Screens/CompanyScreen.dart';
import 'package:invoice_pdf_generate/style/ConstStyle.dart';

void main() {
  //  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
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

