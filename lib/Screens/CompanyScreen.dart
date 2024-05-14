//create company screen stateless widget
// Gather Company Details:
// Prompt the user to input the following:
// Company Name
// Company Logo (image file) option
// Company Address
// QR Code (image file for payment)
// Signature Image (to add below the total amount)
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:invoice_pdf_generate/Controller/pdfController.dart';
import 'package:invoice_pdf_generate/Controller/sqlController.dart';
import 'package:invoice_pdf_generate/Screens/InvoiceScreen.dart';
import 'package:invoice_pdf_generate/Utils/Enums.dart';
import 'package:invoice_pdf_generate/style/ConstStyle.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final pdfController = Get.put(PdfController());
  final sqfliteController = Get.put(SqlDb());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 1,
        title: const Text('Company Details'),
        centerTitle: true,
      ),
      body: GetBuilder(
          init: pdfController,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.black38),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Choose Company Image'),
                        ),
                        Expanded(
                          child: Divider(color: Colors.black38),
                        ),
                      ],
                    ),

                    InkWell(
                      onTap: () {
                        pdfController.companypickImage();
                      },
                      child: GFAvatar(
                        backgroundImage:
                            pdfController.companyPickedImageFile != null
                                ? FileImage(File(
                                    pdfController.companyPickedImageFile!.path))
                                : null,
                        shape: GFAvatarShape.circle,
                        radius: 50,
                        child: pdfController.companyPickedImageFile == null
                            ? const Icon(Icons.person,
                                size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //company name
                    TextFormField(
                      onChanged: (value) {
                        pdfController.companyName.value = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter company name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        isDense: true,

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Company Name',
                        label: const Text('Company Name'),
                        // errorText: 'Please enter company name',
                        alignLabelWithHint: true,
                      ),
                    ),
                    // company image
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        pdfController.companyAddress.value = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter company address';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Company Address',
                        label: const Text('Company Address'),
                        alignLabelWithHint: true,
                        // errorText: 'Please enter company address',
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Choose Font
                    DropdownButtonFormField(
                      isDense: true,
                      style: TextStyle(
                        color: primaryColor,
                      ),
                      value: pdfController.gstType.value,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'Select GST Type',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: GstType.NONE,
                            child: Text('None')),
                        DropdownMenuItem(
                            value: GstType.GST_5,
                            child: Text('GST 5%')),
                        DropdownMenuItem(
                            value: GstType.GST_12,
                            child: Text('GST 12%')),
                        DropdownMenuItem(
                            value: GstType.GST_18,
                            child: Text('GST 18%')),
                        DropdownMenuItem(
                            value: GstType.GST_28,
                            child: Text('GST 28%')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                            pdfController.gstType.value = value;
                        }
                      },
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.black38),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Choose QR Code'),
                        ),
                        Expanded(
                          child: Divider(color: Colors.black38),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    pdfController.qrCodePickedImageFile != null
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.file(
                                    File(pdfController
                                        .qrCodePickedImageFile!.path),
                                    height: 100,
                                    width: 100,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        iconSize: 10,
                                        onPressed: () {
                                          pdfController.qrCodePickImage();
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 20,
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: IconButton(
                              onPressed: () async {
                                pdfController.qrCodePickImage();
                              },
                              icon: const Icon(Icons.qr_code),
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),

                    const Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.black38),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Choose Signature Image'),
                        ),
                        Expanded(
                          child: Divider(color: Colors.black38),
                        ),
                      ],
                    ),
                    // company address

                    pdfController.signatureCodePickedImageFile != null
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.file(
                                    File(pdfController
                                        .signatureCodePickedImageFile!.path),
                                    height: 100,
                                    width: 100,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        iconSize: 10,
                                        onPressed: () {
                                          pdfController.signaturePickImage();
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 20,
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: IconButton(
                                onPressed: () async {
                                  pdfController.signaturePickImage();
                                },
                                icon: const Icon(Icons.edit_document)),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      color: Colors.black26,
                    ),
                    const SizedBox(
                      height: 20,
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
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            sqfliteController.insert('company', {
                              'name': pdfController.companyName.value,
                              'logo': pdfController.companyPickedImageFile !=
                                      null
                                  ? pdfController.companyPickedImageFile!.path
                                  : '',
                              'address': pdfController.companyAddress.value,
                              'qr_code': pdfController.qrCodePickedImageFile !=
                                      null
                                  ? pdfController.qrCodePickedImageFile!.path
                                  : '',
                              'signature':
                                  pdfController.signatureCodePickedImageFile !=
                                          null
                                      ? pdfController
                                          .signatureCodePickedImageFile!.path
                                      : '',
                            });
                            Get.to(
                              () => const InvoiceScreen(),
                            );
                            _formKey.currentState!.save();
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please fill all the fields',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(10),
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        label: const Text('Go to Invoice Screen'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
