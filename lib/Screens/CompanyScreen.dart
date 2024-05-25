//create company screen stateless widget
// Gather Company Details:
// Prompt the user to input the following:
// Company Name
// Company Logo (image file) option
// Company Address
// QR Code (image file for payment)
// Signature Image (to add below the total amount)
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:getwidget/getwidget.dart';
import 'package:invoice_pdf_generate/Controller/pdfController.dart';
import 'package:invoice_pdf_generate/Controller/sharedController.dart';
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
  final sharedPref = Get.find<SharedPref>();
  final _formKey = GlobalKey<FormState>();

  final indexOfGst = {
    GstVar.NONE: 0,
    GstVar.GST: 1,
    GstVar.IGST: 2,
    GstVar.CGST: 3,
    GstVar.SGST: 4,
    GstVar.UTGST: 5,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 1,
        title: const Text('Company Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: GetBuilder(
            init: pdfController,
            builder: (context) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                pdfController.companypickImage();
                              },
                              child: GFAvatar(
                                backgroundImage: pdfController
                                                .companyPickedImageFile !=
                                            null &&
                                        pdfController.companyPickedImageFile!
                                            .path.isNotEmpty
                                    ? FileImage(File(pdfController
                                        .companyPickedImageFile!.path))
                                    : sharedPref.getData(key: 'logo') != null &&
                                            sharedPref.getData(key: 'logo') !=
                                                ''
                                        ? FileImage(File(pdfController
                                            .updateCompanyImage(File(sharedPref
                                                .getData(key: 'logo')!))
                                            .path))
                                        : null,
                                shape: GFAvatarShape.circle,
                                radius: 50,
                                child: pdfController.companyPickedImageFile ==
                                            null &&
                                        (pdfController.companyPickedImageFile
                                                ?.path.isEmpty) ==
                                            null
                                    ? sharedPref.getData(key: 'logo') == null &&
                                            sharedPref.getData(key: 'logo') ==
                                                "" &&
                                            sharedPref
                                                    .getData(key: 'logo')
                                                    .toString() ==
                                                "null"
                                        ? const Icon(
                                            Icons.add_a_photo,
                                            size: 50,
                                          )
                                        : Icon(
                                            Icons.add_a_photo,
                                            size: 50,
                                          )
                                    : null,
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Row(
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
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //company name
                      TextFormField(
                        // onChanged: (value) {
                        //   pdfController.companyName.value = value;
                        // },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter company name';
                          }
                          return null;
                        },
                        controller: pdfController.companyNameController
                          ..text = pdfController
                                  .companyNameController.text.isEmpty
                              ? sharedPref.getData(key: 'company_name') ?? ""
                              : pdfController.companyNameController.text,
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
                        controller: pdfController.companyAddressController
                          ..text = pdfController
                                  .companyAddressController.text.isEmpty
                              ? sharedPref.getData(key: 'company_address') ?? ''
                              : pdfController.companyAddressController.text,
                        // onChanged: (value) {
                        //   pdfController.companyAddress.value = value;
                        // },
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
                      TextFormField(
                        controller: pdfController.companyEmailController
                          ..text = pdfController
                                  .companyEmailController.text.isEmpty
                              ? sharedPref.getData(key: 'company_email') ?? ''
                              : pdfController.companyEmailController.text,
                        // onChanged: (value) {
                        //   pdfController.companyEmail.value = value;
                        // },
                        // validator: (value) {
                        //   if (value?.contains('@') == false) {
                        //     return 'Please enter valid email';
                        //   }
                        //   return null;
                        // },
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Company Email',
                          label: const Text('Company Email'),
                          alignLabelWithHint: true,
                          // errorText: 'Please enter company address',
                        ),
                      ),
                      const SizedBox(height: 10),
                      SegmentedButton(
                        // selectedIcon: const Icon(Icons.check),
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        segments: const [
                          ButtonSegment(
                            value: GstVar.NONE,
                            label: Text('None'),
                          ),
                          ButtonSegment(
                            value: GstVar.GST,
                            label: Text('GST'),
                          ),
                          ButtonSegment(
                            value: GstVar.IGST,
                            label: Text('IGST'),
                          ),
                          ButtonSegment(
                            value: GstVar.CGST,
                            label: Text('CGST'),
                          ),
                          ButtonSegment(
                            value: GstVar.SGST,
                            label: Text('SGST'),
                          ),
                          ButtonSegment(
                            value: GstVar.UTGST,
                            label: Text('UTGST'),
                          ),
                        ],

                        selected: pdfController.gstVar.value == GstVar.NONE
                            ? {
                                GstVar.NONE,
                              }
                            : sharedPref.getData(key: 'gst_type') == null
                                ? {
                                    pdfController.gstVar.value,
                                  }
                                : {
                                    GstVar.values.firstWhere((element) =>
                                        element.toString().split('.').last ==
                                        sharedPref.getData(key: 'gst_type'))
                                  },

                        onSelectionChanged: (value) {
                          setState(() {});
                          // on same value selection again deselect the value
                          if (pdfController.gstVar.value == value.first) {
                            pdfController.gstVar.value = GstVar.NONE;
                            // sharedPref.saveData(key: 'gst_type', value: '');
                            return;
                          } else
                            pdfController.gstVar.value = value.first;
                          pdfController.gstControllerFocusNode[
                                  pdfController.gstVar.value.index]
                              .requestFocus();
                          sharedPref.saveData(
                              key: 'gst_type',
                              value: pdfController.gstVar.value
                                  .toString()
                                  .split('.')
                                  .last);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      pdfController.gstVar.value == GstVar.NONE
                          ? Container()
                          : TextFormField(
                              focusNode: pdfController.gstControllerFocusNode[
                                  pdfController.gstVar.value.index],
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(50),
                              ],
                              controller: pdfController.gstController[
                                  pdfController.gstVar.value.index]
                                ..text = pdfController
                                            .gstController[pdfController
                                                .gstVar.value.index]
                                            .text
                                            .isEmpty ||
                                        pdfController
                                                .gstController[pdfController
                                                    .gstVar.value.index]
                                                .text ==
                                            '0'
                                    ? sharedPref.getData(key: 'gstVal') != null
                                        ? sharedPref
                                            .getData(key: 'gstVal')!
                                            .split(',')[pdfController.gstVar.value.index - 1]
                                            .trim()
                                            .replaceAll('[', '')
                                            .replaceAll(']', '')
                                        : pdfController.gstController[pdfController.gstVar.value.index].text
                                    : pdfController.gstController[pdfController.gstVar.value.index].text,
                              // onChanged: (value) {
                              //   pdfController.companyAddress.value = value;
                              // },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter ${pdfController.gstVar.value == GstVar.NONE ? "" : pdfController.gstVar.value}';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                hintText:
                                    'Enter ${pdfController.gstVar.value == GstVar.NONE ? "" : pdfController.gstVar.value.toString().split('.').last}',
                                label: Text(
                                    'Enter ${pdfController.gstVar.value == GstVar.NONE ? "" : pdfController.gstVar.value.toString().split('.').last}'),
                                alignLabelWithHint: true,
                                // errorText: 'Please enter company address',
                              ),
                            ),

                      // DropdownButtonFormField(
                      //   isDense: true,
                      //   style: TextStyle(
                      //     color: primaryColor,
                      //   ),
                      //   value: pdfController.gstType.value,
                      //   decoration: const InputDecoration(
                      //     isDense: true,
                      //     hintText: 'Select GST Type',
                      //     border: OutlineInputBorder(
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(10))),
                      //   ),
                      //   items: const [
                      //     DropdownMenuItem(
                      //         value: GstType.NONE, child: Text('None')),
                      //     DropdownMenuItem(
                      //         value: GstType.GST_5, child: Text('GST 5%')),
                      //     DropdownMenuItem(
                      //         value: GstType.GST_12, child: Text('GST 12%')),
                      //     DropdownMenuItem(
                      //         value: GstType.GST_18, child: Text('GST 18%')),
                      //     DropdownMenuItem(
                      //         value: GstType.GST_28, child: Text('GST 28%')),
                      //   ],
                      //   onChanged: (value) {
                      //     if (value != null) {
                      //       pdfController.gstType.value = value;
                      //     }
                      //   },
                      // ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          pdfController.qrCodePickedImageFile != null &&
                                  pdfController
                                      .qrCodePickedImageFile!.path.isNotEmpty
                              ? Expanded(
                                  child: Column(
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
                                                padding:
                                                    const EdgeInsets.all(0),
                                                iconSize: 10,
                                                onPressed: () {
                                                  pdfController
                                                      .qrCodePickImage();
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : sharedPref.getData(key: 'qr_code') != null &&
                                      sharedPref.getData(key: 'qr_code') != ''
                                  ? Expanded(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Image.file(
                                                File(
                                                  pdfController
                                                      .updateQrCodeImage(File(
                                                          sharedPref.getData(
                                                                  key:
                                                                      'qr_code') ??
                                                              ""))
                                                      .path,
                                                ),
                                                height: 100,
                                                width: 100,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: IconButton(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    iconSize: 10,
                                                    onPressed: () {
                                                      pdfController
                                                          .qrCodePickImage();
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: IconButton(
                                          onPressed: () async {
                                            pdfController.qrCodePickImage();
                                          },
                                          icon: const Icon(Icons.qr_code),
                                        ),
                                      ),
                                    ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
                            flex: 2,
                            child: Row(
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
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // company address

                      Row(
                        children: [
                          pdfController.signatureCodePickedImageFile != null &&
                                  pdfController.signatureCodePickedImageFile!
                                      .path.isNotEmpty
                              ? Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Image.file(
                                            File(pdfController
                                                .signatureCodePickedImageFile!
                                                .path),
                                            height: 50,
                                            width: 600,
                                            fit: BoxFit.fitWidth,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                iconSize: 10,
                                                onPressed: () {
                                                  pdfController
                                                      .signaturePickImage();
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : sharedPref.getData(key: 'signature') != null &&
                                      sharedPref.getData(key: 'signature') != ''
                                  ? Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Image.file(
                                                File(pdfController
                                                    .updateSignatureImage(File(
                                                        sharedPref.getData(
                                                            key: 'signature')!))
                                                    .path),
                                                height: 50,
                                                width: 600,
                                            fit: BoxFit.fitWidth,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: IconButton(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    iconSize: 10,
                                                    onPressed: () {
                                                      pdfController
                                                          .signaturePickImage();
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: IconButton(
                                            onPressed: () async {
                                              pdfController
                                                  .signaturePickImage();
                                            },
                                            icon: const Icon(
                                                Icons.edit_document)),
                                      ),
                                    ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
                            flex: 2,
                            child: Row(
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
                          ),
                        ],
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
                              // sharedPref.clearData();
                              sharedPref.saveData(
                                  key: 'company_name',
                                  value: pdfController
                                          .companyNameController.text.isEmpty
                                      ? sharedPref.getData(
                                              key: 'company_name') ??
                                          ''
                                      : pdfController
                                          .companyNameController.text);
                              sharedPref.saveData(
                                  key: 'company_email',
                                  value: pdfController
                                          .companyEmailController.text.isEmpty
                                      ? sharedPref.getData(
                                              key: 'company_email') ??
                                          ''
                                      : pdfController
                                          .companyEmailController.text);
                              sharedPref.saveData(
                                key: 'gstVal',
                                value: [
                                  pdfController
                                      .gstController[GstVar.GST.index].text,
                                  pdfController
                                      .gstController[GstVar.IGST.index].text,
                                  pdfController
                                      .gstController[GstVar.CGST.index].text,
                                  pdfController
                                      .gstController[GstVar.SGST.index].text,
                                  pdfController
                                      .gstController[GstVar.UTGST.index].text,
                                ].toString(),
                              );
                              sharedPref.saveData(
                                  key: 'company_address',
                                  value: pdfController
                                          .companyAddressController.text.isEmpty
                                      ? sharedPref.getData(
                                              key: 'company_address') ??
                                          ''
                                      : pdfController
                                          .companyAddressController.text);
                              sharedPref.saveData(
                                  key: 'gst_type',
                                  value: pdfController.gstVar.value
                                      .toString()
                                      .split('.')
                                      .last);
                              sharedPref.saveData(
                                  key: 'qr_code',
                                  value: pdfController.qrCodePickedImageFile !=
                                          null
                                      ? pdfController
                                          .qrCodePickedImageFile!.path
                                      : sharedPref.getData(key: 'qr_code') ??
                                          '');
                              sharedPref.saveData(
                                  key: 'signature',
                                  value: pdfController
                                              .signatureCodePickedImageFile !=
                                          null
                                      ? pdfController
                                          .signatureCodePickedImageFile!.path
                                      : sharedPref.getData(key: 'signature') ??
                                          "");

                              sharedPref.saveData(
                                  key: 'logo',
                                  value: pdfController.companyPickedImageFile !=
                                          null
                                      ? pdfController
                                          .companyPickedImageFile!.path
                                      : sharedPref.getData(key: 'logo') ?? '');

                              Get.to(
                                () => const InvoiceScreen(),
                              );
                              _formKey.currentState!.save();
                            } else {
                              Get.snackbar('', 'Please fill all the fields',
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(10),
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  titleText: Container());
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
      ),
    );
  }
}
