// ignore_for_file: unnecessary_null_comparison, unused_import

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:invoice_pdf_generate/Screens/AddDataScreen.dart';
import 'package:invoice_pdf_generate/file_handle_api.dart';
import 'package:invoice_pdf_generate/style/ConstStyle.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../Controller/pdfController.dart';
import '../Controller/sharedController.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final pdfController = Get.put(PdfController());
  final shared = Get.find<SharedPref>();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext bcontext) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          elevation: 2,
          title: const Text('Invoice Details'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          )),
      body: GetBuilder<PdfController>(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: key,
            child: ListView(
              children: [
                DropdownButtonFormField(
                  isDense: true,
                  style: TextStyle(
                    color: primaryColor,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Select Theme Color',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                      pdfController.color.value = value!;
                    });
                  },
                ),
                SizedBox(height: 10),
                // Choose Font
                DropdownButtonFormField(
                  isDense: true,
                  style: TextStyle(
                    color: primaryColor,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Select Font',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                        switch (value) {
                          case pw.Font.courier:
                            pdfController.fontFamily.value = pw.Font.courier();
                            break;
                          case pw.Font.helvetica:
                            pdfController.fontFamily.value =
                                pw.Font.helvetica();
                            break;
                          case pw.Font.times:
                            pdfController.fontFamily.value = pw.Font.times();
                            break;
                          case pw.Font.zapfDingbats:
                            pdfController.fontFamily.value =
                                pw.Font.zapfDingbats();
                            break;

                          default:
                            pdfController.fontFamily.value = pw.Font.courier();
                        }
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                //               Invoice To Name
                // Invoice To Address (optional)
                // Invoice To Contact Number (optional)
                //Invoice Number (auto generated)
                TextFormField(
                  controller: pdfController.invoiceNumber
                    ..text = (int.parse(shared.getData(key: "invoice_gen") ?? "0") + 1)
                        .toString()
                        .padLeft(6, '0'),
                 
                  decoration: InputDecoration(
                    isDense: true,

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Invoice Number',
                    label: Text('Invoice Number'),
                    // errorText: 'Please enter company name',
                    alignLabelWithHint: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (value) {
                    pdfController.invoiceToName.value = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter invoice to name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    isDense: true,

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Invoice To Name',
                    label: Text('Invoice To Name'),
                    // errorText: 'Please enter company name',
                    alignLabelWithHint: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (value) {
                    pdfController.invoiceToAddress.value = value;
                  },
                  decoration: InputDecoration(
                    isDense: true,

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Invoice To Address (optional)',
                    label: Text('Invoice To Address'),
                    // errorText: 'Please enter company name',
                    alignLabelWithHint: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (value) {
                    pdfController.invoiceToContactNumber.value = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Invoice To Contact Number (optional)",
                    label: Text('Invoice To Contact Number'),
                    // errorText: 'Please enter company name',
                    alignLabelWithHint: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //email
                TextFormField(
                  onChanged: (value) {
                    pdfController.invoiceToEmail.value = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    isDense: true,

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Invoice To Email (optional)",
                    label: Text('Invoice To Email'),
                    // errorText: 'Please enter company name',
                    alignLabelWithHint: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //date picker
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: secondaryColor,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    showDatePicker(
                      context: bcontext,
                      initialDate: pdfController.invoiceDate.value,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                    ).then((value) {
                      if (value != null) {
                        setState(() {});
                        pdfController.invoiceDate.value = value;
                      }
                    });
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: pdfController.invoiceDate.value == null
                      ? const Text('Select Invoice Date')
                      : Text(
                          'Invoice Date: ${pdfController.invoiceDate.value!.day}/${pdfController.invoiceDate.value!.month}/${pdfController.invoiceDate.value!.year}'),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: secondaryColor,
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (!key.currentState!.validate()) {
                        Get.snackbar(
                          '',
                          'Please enter invoice to name',
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.all(10),
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          titleText: Container(),
                        );
                        return;
                      }
                      Get.to(() => AddDataScreen());
                      // generate pdf file
                      // final pdfFile = await pdfController.generate(
                      //   themeColor,
                      //   pw.Font.courier(),
                      // );

                      // opening the pdf file
                      // FileHandleApi.openFile(pdfFile);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                    label: const Text('Add Invoice Content'),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
