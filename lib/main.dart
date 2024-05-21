import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:invoice_pdf_generate/Controller/pdfController.dart';
import 'package:invoice_pdf_generate/Controller/sharedController.dart';
import 'package:invoice_pdf_generate/Screens/AddDataScreen.dart';
import 'package:invoice_pdf_generate/Screens/CompanyScreen.dart';
import 'package:invoice_pdf_generate/Screens/InvoiceScreen.dart';
import 'package:invoice_pdf_generate/Screens/OnboardingScreen.dart';
import 'package:invoice_pdf_generate/Screens/SplashScreen.dart';
import 'package:invoice_pdf_generate/Utils/PermissionUtil.dart';
import 'package:invoice_pdf_generate/style/ConstStyle.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'file_handle_api.dart';
import 'pdf_invoice_api.dart';

void main() async {
  //  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MainApp(
    prefs: prefs,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.prefs,
  });
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<PdfController>(() => PdfController());
        Get.lazyPut<SharedPref>(() => SharedPref(
              prefs: prefs,
            ));
        Get.lazyPut<PdfInvoiceApi>(() => PdfInvoiceApi());
      }),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => SplashScreen(),
        ),
        GetPage(
          name: '/onboarding',
          page: () => Onboardingscreen(),
        ),
        GetPage(
          name: '/company',
          page: () => CompanyScreen(),
        ),
        GetPage(name: '/add', page: () => AddDataScreen()),
        GetPage(name: '/invoice', page: () => InvoiceScreen()),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primaryColor,
          secondary: secondaryColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onError: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          surface: Colors.white,
        ),
        // primaryColor: const Color(0xffFBCD08),
      ),
      // title: 'Invoice PDF Generate',
      // home:
      //       CompanyScreen(),
    );
  }
}
