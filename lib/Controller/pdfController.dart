import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoice_pdf_generate/Controller/sharedController.dart';
import 'package:invoice_pdf_generate/Utils/Enums.dart';
import 'package:invoice_pdf_generate/file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfController extends GetxController {
  final shared = Get.find<SharedPref>();
  var color = PdfColors.black.obs;
  Rx<pw.Font> fontFamily = pw.Font().obs;
  //company name
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyAddressController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
  TextEditingController invoiceToEmailController = TextEditingController();
  //invoicedate
  Rx<DateTime> invoiceDate = DateTime.now().obs;
  late List<List<String>> tableData = [];
  Rx<GstVar> gstVar = GstVar.NONE.obs;

  TextEditingController itemController = TextEditingController();
  TextEditingController srnoController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController itemControlleru = TextEditingController();
  TextEditingController srnoControlleru = TextEditingController();
  TextEditingController qtyControlleru = TextEditingController();
  TextEditingController amountControlleru = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController invoiceNumber = TextEditingController();
  List<TextEditingController> gstController =
      List.generate(6, (index) => TextEditingController(text: "0"));
  //gstControllerfocusnode
  List<FocusNode> gstControllerFocusNode =
      List.generate(6, (index) => FocusNode());

//  Invoice To Name
// Invoice To Address (optional)
// Invoice To Contact Number (optional)
  var invoiceToName = "".obs;
  var invoiceToAddress = "".obs;
  var invoiceToContactNumber = "".obs;
  //company image xfile

  File? companyPickedImageFile;
  File? qrCodePickedImageFile;
  File? signatureCodePickedImageFile;

  File updateCompanyImage(File file) {
    companyPickedImageFile = file;
    update();
    return file;
  }

  File updateQrCodeImage(File file) {
    qrCodePickedImageFile = file;
    update();
    return file;
  }

  File updateSignatureImage(File file) {
    signatureCodePickedImageFile = file;
    update();
    return file;
  }

  companyPickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    companyPickedImageFile = File(pickedImage!.path);
    update();
  }

  deleteCompanyImage() {
    companyPickedImageFile = null;
    update();
  }

  void updateTableBasedOnIndex(int index) {
    tableData[index][0] = srnoControlleru.text.isEmpty
        ? (tableData.length + 1).toString()
        : srnoControlleru.text;
    tableData[index][1] = itemControlleru.text;
    tableData[index][2] = qtyControlleru.text;
    tableData[index][3] = amountControlleru.text;
    itemControlleru.clear();
    srnoControlleru.clear();
    qtyControlleru.clear();
    amountControlleru.clear();

    update();
  }

  void clearAllData() {
  
    invoiceToEmailController.clear();
    invoiceToName.value = '';
    invoiceToAddress.value = '';
    invoiceToContactNumber.value = '';
    invoiceDate(DateTime.now());
    tableData.clear();
   
    itemController.clear();
    srnoController.clear();
    qtyController.clear();
    amountController.clear();
    itemControlleru.clear();
    srnoControlleru.clear();
    qtyControlleru.clear();
    amountControlleru.clear();
    fileNameController.clear();

    // update();
    Get.offAndToNamed('/company' );
  }

  void updateTableData() {
    //  List listData = [
    //  {
    //     'Sr No': srNo,
    //     'Item & Description': itemController,
    //     'Qty': qtyController,
    //     'Amount': amountController,
    //  }
    //   ];

    //  List  listData = [

    //     (tableData.length + 1).toString() ,
    //     amountController,
    //     itemController,
    //     qtyController,

    //   ];
    tableData.add([
      srnoController.text.isEmpty
          ? (tableData.length + 1).toString()
          : srnoController.text,
      itemController.text,
      qtyController.text,
      amountController.text,
    ]);
    Get.snackbar(
      'Success',
      'Data Added Successfully',
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 1),
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    itemController.clear();
    srnoController.clear();
    qtyController.clear();
    amountController.clear();
    update();
  }

  deleteQrCodeImage() {
    qrCodePickedImageFile = null;
    update();
  }

  qrCodePickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    qrCodePickedImageFile = File(pickedImage!.path);
    update();
  }

  signaturePickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    signatureCodePickedImageFile = File(pickedImage!.path);
    update();
  }

  void Function() get companypickImage => companyPickImage;
  void Function() get qrcodepickImage => qrCodePickImage;
  void Function() get signaturepickImage => signaturePickImage;

  final List<PdfColor> colors = [
    PdfColors.black,
    PdfColors.grey900,
    PdfColors.green,
    PdfColors.blue,
    PdfColors.red,
  ];

  Future<File> generate(bool preview) async {
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(fontFallback: [
        pw.Font.symbol(),
      ]),
    );

// Item & Description (editable)
// Qty (editable)
// Amount
// Total (auto-calculated)
    final tableHeaders = [
      'Sr No',
      'Item & \nDescription',
      'Qty',
      'Amount',
      // 'Total',
    ];
    final font = await PdfGoogleFonts.firaSansCondensedRegular();
    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(
          fontFallback: [
            await PdfGoogleFonts.materialIcons(),
          ],
          icons: await PdfGoogleFonts.materialIcons(), // this line
        ),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            //company
            pw.Row(
              children: [
                companyPickedImageFile != null &&
                        companyPickedImageFile!.existsSync()
                    ? pw.Image(
                        pw.MemoryImage(
                            companyPickedImageFile!.readAsBytesSync()),
                        height: 60,
                        width: 60,
                        fit: pw.BoxFit.cover,
                      )
                    : pw.Container(),
                pw.SizedBox(width: 2 * PdfPageFormat.mm),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      companyNameController.text.isEmpty
                          ? ''
                          : companyNameController.text,
                      style: pw.TextStyle(
                        fontSize: 17.0,
                        fontWeight: pw.FontWeight.bold,
                        color: color.value,
                        font: fontFamily.value,
                      ),
                    ),
                    // pw.Text(
                    //   'Test',
                    //   style: pw.TextStyle(
                    //     fontSize: 15.0,
                    //     color:color.value,
                    //     font: fontFamily.value,
                    //   ),
                    // ),
                  ],
                ),
                pw.Spacer(),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      companyNameController.text.isEmpty
                          ? ''
                          : companyNameController.text,
                      style: pw.TextStyle(
                        fontSize: 15.5,
                        fontWeight: pw.FontWeight.bold,
                        color: color.value,
                        font: fontFamily.value,
                      ),
                    ),
                    pw.Text(
                      companyEmailController.text.isEmpty
                          ? ''
                          : companyEmailController.text,
                      style: pw.TextStyle(
                        fontSize: 14.0,
                        color: color.value,
                        font: fontFamily.value,
                      ),
                    ),
                    // pw.Text(
                    //   DateTime.now().toString().split(' ')[0],
                    //   style: pw.TextStyle(
                    //     fontSize: 14.0,
                    //     color:color.value,
                    //     font: fontFamily.value,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            //to bill to
            pw.Row(
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Bill To:',
                      style: pw.TextStyle(
                        fontSize: 15.0,
                        fontWeight: pw.FontWeight.bold,
                        color: color.value,
                        font: fontFamily.value,
                      ),
                    ),
                    pw.Text(
                      invoiceToName.value.isEmpty ? '' : invoiceToName.value,
                      style: pw.TextStyle(
                        fontSize: 14.0,
                        color: color.value,
                        font: fontFamily.value,
                      ),
                    ),
                    pw.Text(
                      invoiceToAddress.value.isEmpty
                          ? ''
                          : invoiceToAddress.value,
                      style: pw.TextStyle(
                        fontSize: 14.0,
                        color: color.value,
                        font: fontFamily.value,
                      ),
                    ),
                    pw.Text(
                      invoiceToContactNumber.value.isEmpty
                          ? ''
                          : invoiceToContactNumber.value,
                      style: pw.TextStyle(
                        fontSize: 14.0,
                        color: color.value,
                        font: fontFamily.value,
                      ),
                    ),
                    pw.Text(
                      invoiceToEmailController.text.isEmpty
                          ? ''
                          : invoiceToEmailController.text,
                      style: pw.TextStyle(
                        fontSize: 14.0,
                        color: color.value,
                        font: fontFamily.value,
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Invoice No:',
                      style: pw.TextStyle(
                        fontSize: 15.0,
                        fontWeight: pw.FontWeight.bold,
                        color: color.value,
                        font: fontFamily.value,
                      ),
                    ),
                    pw.Text(
                      invoiceNumber.text.isEmpty
                          ? ''
                          : "#" + invoiceNumber.text,
                      style: pw.TextStyle(
                        fontSize: 14.0,
                        color: color.value,
                        font: fontFamily.value,
                      ),
                    ),
                    pw.Text(
                      'Date:',
                      style: pw.TextStyle(
                        fontSize: 15.0,
                        fontWeight: pw.FontWeight.bold,
                        color: color.value,
                        font: fontFamily.value,
                      ),
                    ),
                    pw.Text(
                      invoiceDate.value.toString().split(' ')[0],
                      style: pw.TextStyle(
                        fontSize: 14.0,
                        color: color.value,
                        font: fontFamily.value,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),

            pw.SizedBox(height: 5 * PdfPageFormat.mm),

            ///
            /// PDF Table Create
            ///
            pw.TableHelper.fromTextArray(
              headers: tableHeaders,
              data: tableData,
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30.0,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
              },
            ),
            pw.Divider(),
            pw.Container(
              
              alignment: pw.Alignment.centerRight,
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Spacer(flex: 6),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Net total',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: color.value,
                                  font: fontFamily.value,
                                ),
                              ),
                            ),
                            pw.Text(
                              '\₹ ${tableData.fold(0, (prev, element) => prev + int.parse(element[3]))}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: color.value,
                                font: font,
                                fontFallback: [pw.Font.courier()],
                              ),
                            ),
                          ],
                        ),
                        pw.Column(
                            mainAxisSize: pw.MainAxisSize.min,
                            children: List.generate(
                              gstController.length,
                              (index) {
                                if (gstController[index].text.trim() == '0') {
                                  return pw.Container();
                                }
                                return pw.Row(
                                  children: [
                                    pw.Text(
                                      GstVar.values[index + 1]
                                          .toString()
                                          .split('.')
                                          .last,
                                      style: pw.TextStyle(
                                        // fontSize: 14.0,
                                        fontWeight: pw.FontWeight.bold,
                                        color: color.value,
                                        font: fontFamily.value,
                                      ),
                                    ),
                                    pw.Spacer(),
                                    pw.Text(
                                      '${gstController[index].text.isEmpty ? '0' : gstController[index].text.trim()}%',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: color.value,
                                        font: font,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ).toList()),
                        pw.Divider(),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Total Amount',
                                style: pw.TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: pw.FontWeight.bold,
                                  color: color.value,
                                  font: fontFamily.value,
                                ),
                              ),
                            ),
                            pw.Text(
                              '\₹ ${(tableData.fold(0, (prev, element) => prev + int.parse(element[3])) + (tableData.fold(0, (prev, element) => prev + int.parse(element[3])) * gstController.fold(0, (prev, element) => prev + int.parse(element.text.trim()) / 100))).toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: color.value,
                                font: font,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 2 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                        pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                        pw.SizedBox(height: 2 * PdfPageFormat.mm),
                        signatureCodePickedImageFile != null &&
                                signatureCodePickedImageFile!.existsSync()
                            ? pw.Image(
                                pw.MemoryImage(
                                  signatureCodePickedImageFile!
                                      .readAsBytesSync(),
                                ),
                                width: 200,
                                height: 50,
                                fit: pw.BoxFit.cover,
                              )
                            : pw.Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.Spacer(),
            pw.Container(            
                alignment: pw.Alignment.centerLeft,
            child:   qrCodePickedImageFile != null && qrCodePickedImageFile!.existsSync()
                ? pw.Image(
                    pw.MemoryImage(
                      qrCodePickedImageFile!.readAsBytesSync(),
                    ),
                    width: 60,
                    height: 60,
                    fit: pw.BoxFit.cover,
                  )
                : pw.Container(),
)
          
          ];
        },
        footer: (context) {
          return pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Divider(),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Text(
                companyNameController.text.isEmpty
                    ? ''
                    : companyNameController.text,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: color.value,
                    font: fontFamily.value),
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              companyAddressController.text.isEmpty
                  ? pw.Container()
                  : companyAddressController.text.isEmpty
                      ? pw.Container()
                      : pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              'Address: ',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: color.value,
                                  font: fontFamily.value),
                            ),
                            pw.Text(
                              companyAddressController.text.isEmpty
                                  ? ''
                                  : companyAddressController.text,
                              style: pw.TextStyle(
                                  color: color.value, font: fontFamily.value),
                            ),
                          ],
                        ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              companyEmailController.text.isEmpty
                  ? pw.Container()
                  : pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          'Email: ',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: color.value,
                              font: fontFamily.value),
                        ),
                        pw.Text(
                          companyEmailController.text,
                          style: pw.TextStyle(
                              color: color.value, font: pw.Font.courier()),
                        ),
                      ],
                    ),
            ],
          );
        },
      ),
    );

    return preview
        ? FileHandleApi.saveDocumentTolocal(name: 'temp.pdf', pdf: pdf)
        : FileHandleApi.saveDocument(
            name:
                '${fileNameController.text.isEmpty ? 'invoice' : fileNameController.text}.pdf',
            pdf: pdf);
  }
}
