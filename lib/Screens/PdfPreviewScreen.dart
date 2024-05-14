import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice_pdf_generate/Controller/pdfController.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({super.key,
    required this.themeColor,
    required this.font,
  });
final  PdfColor themeColor;
final  pw.Font font ;
  @override
  Widget build(BuildContext context) {
    final pdfController = Get.put(PdfController());

    return PdfPreview(build: (format) {
      return pdfController
          .generate(
            themeColor,
            pw.Font.courier(),
            true
          )
          .then((file) => file.readAsBytesSync());
    });
  }
}
