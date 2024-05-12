import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice_pdf_generate/Controller/pdfController.dart';
import 'package:invoice_pdf_generate/style/ConstStyle.dart';
import 'package:pdf/pdf.dart';
import 'file_handle_api.dart';
import 'pdf_invoice_api.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      title: 'Invoice PDF Generate',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PdfColor themeColor = PdfColors.black;
  pw.Font font = pw.Font.courier();
  final pdfController = Get.put(PdfController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        centerTitle: true,
      ),
      body: GetBuilder<PdfController>(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                'Company Information',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  hintText: 'Select Theme color',
                ),
                items: [
                  const DropdownMenuItem(
                    child: const Text('Black'),
                    value: PdfColors.black,
                  ),
                  const DropdownMenuItem(
                    child: Text('Dark Grey'),
                    value: PdfColors.grey900,
                  ),
                  const DropdownMenuItem(
                    child: Text('Green'),
                    value: PdfColors.green,
                  ),
                  const DropdownMenuItem(
                    child: Text('Blue'),
                    value: PdfColors.blue,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    themeColor = value as PdfColor;
                  });
                },
              ),

              // Choose Font
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  hintText: 'Select Font',
                ),
                items: const [
                  DropdownMenuItem(
                    child: Text('Courier'),
                    value: pw.Font.courier,
                  ),
                  DropdownMenuItem(
                    child: Text('Helvetica'),
                    value: pw.Font.helvetica,
                  ),
                  DropdownMenuItem(
                    child: Text('Times'),
                    value: pw.Font.times,
                  ),
                  DropdownMenuItem(
                    child: Text('ZapfDingbats'),
                    value: pw.Font.zapfDingbats,
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      font = value();
                    });
                  }
                },
              ),
              //company name
              TextFormField(
                onChanged: (value) {
                  pdfController.companyName.value = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Company Name',
                ),
              ),
              // company image
              pdfController.companyPickedImageFile != null
                  ? Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Stack(
                          children: [
                            Image.file(
                              File(pdfController.companyPickedImageFile!.path),
                              height: 100,
                              width: 100,
                            ),
                            IconButton(
                                onPressed: () {
                                  pdfController.deleteCompanyImage();
                                },
                                icon: Icon(Icons.edit)),
                          ],
                        ),
                      ],
                    )
                  : TextButton(
                      onPressed: () async {
                        pdfController.companypickImage();
                      },
                      child: const Text('Choose Company Logo'),
                    ),

              // company address
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Company Address',
                ),
              ),
              //qr code
              TextButton(
                onPressed: () async {
                  pdfController.qrcodepickImage();
                },
                child: const Text('Choose QR Code'),
              ),

              ElevatedButton(
                onPressed: () async {
                  // generate pdf file
                  final pdfFile = await pdfController.generate(
                    themeColor,
                    pw.Font.courier(),
                  );

                  // opening the pdf file
                  FileHandleApi.openFile(pdfFile);
                },
                child: const Text('Generate Invoice'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
