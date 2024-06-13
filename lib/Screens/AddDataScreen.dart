import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:invoice_pdf_generate/Utils/Ads.dart';
import 'package:invoice_pdf_generate/style/ConstStyle.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../Controller/pdfController.dart';
import '../Controller/sharedController.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({Key? key}) : super(key: key);

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  PdfColor themeColor = PdfColors.black;
  pw.Font font = pw.Font.courier();
  final pdfController = Get.put(PdfController());
  final shared = Get.find<SharedPref>();
  final key = GlobalKey<FormState>();
  final key2 = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  // final TextEditingController _qtyController = TextEditingController();
  // final TextEditingController _amountController = TextEditingController();
  // final TextEditingController _srno = TextEditingController();
  // final TextEditingController _itemController = TextEditingController();
  RewardedAd? _rewardedAd;
  loadAd() async {
    await RewardedAd.load(
        adUnitId: rewardAds,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            // An ad loaded successfully.
            _rewardedAd = ad;

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                // Called when ad is dismissed.
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent:
                  (RewardedAd ad, AdError error) {
                // Called when ad fails to show.
                ad.dispose();
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            // An ad failed to load.
          },
        ));
  }

  InterstitialAd? _interstitialAd;
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAds,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              // _moveToHome();
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadAd();
    _loadInterstitialAd();
    //internet checker
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Get.snackbar(
          '',
          'No Internet Connection, Please check your internet connection to access pdf',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          titleText: Container(),
        );
      }
    });
  }

//check internet function
  Future checkInternet() async {
    return await Connectivity().checkConnectivity().then((d) {
      if (d == ConnectivityResult.none) {
        Get.snackbar(
          '',
          'No Internet Connection, Please check your internet connection to access pdf',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          titleText: Container(),
        );
        return;
      }
    });
  }

  @override
  Widget build(BuildContext bcontext) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          elevation: 2,
          title: const Text('Invoice Details'),
          centerTitle: true,
          // actions: [
          //   IconButton(
          //       onPressed: () async {
          //         storagePermission();
          //         await openDownloadFolder();
          //       },
          //       icon: const Icon(Icons.download))
          // ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          )),
      body: GetBuilder<PdfController>(builder: (context) {
        return Scrollbar(
          scrollbarOrientation: ScrollbarOrientation.right,
          thumbVisibility: true,
          interactive: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: key,
              child: ListView(
                children: [
                  //info alert that you can delete datatable by clicking long press
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: primaryColor.withOpacity(0.5))),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'You can delete row by Holding long press, and you can edit datatable by clicking on edit button by scrolling row to right side.',
                            style: TextStyle(color: secondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //                 Sr No
                  // Item & Description (editable) 10 items limit and 70 auto adjust based on length of text
                  // Qty (editable)
                  // Amount
                  // Total (auto-calculated)
                  // Add Item Button
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: context.srnoController,
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return 'Enter Sr No';
                          //   }
                          //   return null;
                          // },
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Sr No',
                            label: const Text('Sr No'),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter quantity';
                            }
                            return null;
                          },
                          controller: context.qtyController,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Qty',
                            label: const Text('Qty'),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter amount';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(50),
                          ],
                          controller: context.amountController,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Amount',
                            label: const Text('Amount'),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter item & description';
                      }
                      return null;
                    },
                    controller: context.itemController,
                    maxLines: 3,
                    maxLength: 70,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Item & Description',
                      label: const Text('Item & Description'),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: secondaryColor,
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      await await checkInternet();

                      if (!key.currentState!.validate()) {
                        Get.snackbar(
                          '',
                          'Please fill all fields',
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(10),
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          titleText: Container(),
                        );
                        return;
                      }
                      context.updateTableData();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
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
                        await checkInternet();
                        // if (_interstitialAd != null) {
                        //   _interstitialAd?.show();
                        // }
                        if (context.tableData.isEmpty) {
                          Get.snackbar(
                            '',
                            'Please add some items to see preview',
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(10),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            titleText: Container(),
                          );
                          return;
                        }
                        Get.to(
                          PdfPreview(
                              enableScrollToPage: true,
                              // previewPageMargin: EdgeInsets.all(0),
                              // padding: EdgeInsets.all(0),
                              useActions: true,
                              build: (format) {
                                return pdfController
                                    .generate(true)
                                    .then((file) => file.readAsBytesSync());
                              }),
                        );
                      },
                      icon: const Icon(Icons.remove_red_eye),
                      label: const Text('Preview Invoice PDF'),
                    ),
                  ),
                  // create remove watermark button
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
                        await checkInternet();

                        await loadAd();
                        _rewardedAd?.show(
                          onUserEarnedReward: (_, reward) {
                            context.waterMark.value = false;
                            Get.snackbar(
                              '',
                              'Watermark removed successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(10),
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              titleText: Container(),
                            );
                          },
                        ); //reward ads
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Remove Watermark'),
                    ),
                  ),

                  (pdfController.tableData.isEmpty)
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: secondaryColor,
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                await checkInternet();
                                if (context.tableData.isEmpty) {
                                  Get.snackbar(
                                    '',
                                    'Please add some items to generate invoice',
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: const EdgeInsets.all(10),
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    titleText: Container(),
                                  );
                                  return;
                                }
                                //ask for file name
                                showDialog(
                                  context: bcontext,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: const Center(
                                          child: Text('Enter File Name')),
                                      contentPadding: const EdgeInsets.all(10),
                                      content: TextField(
                                        controller: context.fileNameController,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          hintText: 'Enter File Name',
                                        ),
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceAround,
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await checkInternet();

                                            _loadInterstitialAd();
                                            int currentCount = shared.getData(
                                                        key: "invoice_gen") ==
                                                    null
                                                ? 0
                                                : int.parse(shared.getData(
                                                    key: "invoice_gen")!);

                                            if (context.fileNameController.text
                                                .isEmpty) {
                                              Get.snackbar(
                                                '',
                                                'Please enter file name',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                                titleText: Container(),
                                              );
                                              return;
                                            }
                                            Get.back();

                                            // generate pdf file

                                            pdfController
                                                .generate(false)
                                                .then((pdfFile) {
                                              shared.saveData(
                                                  key: "invoice_gen",
                                                  value: shared.getData(
                                                              key:
                                                                  "invoice_gen") ==
                                                          null
                                                      ? "1"
                                                      : (int.parse(shared.getData(
                                                                  key:
                                                                      "invoice_gen")!) +
                                                              1)
                                                          .toString());

                                              // FileHandleApi.openFile(
                                              //     pdfFile);
                                            }).whenComplete(() {
                                              Get.snackbar(
                                                'Done',
                                                'PDF file Saved on Download folder',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white,
                                              );
                                              if (currentCount % 5 == 0 &&
                                                  _interstitialAd != null) {
                                                _interstitialAd?.show();
                                              }
                                            });
                                            ;

                                            // Get .back();
                                          },
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                // // generate pdf file
                                // final pdfFile = await pdfController.generate(
                                //   themeColor,
                                //   pw.Font.courier(),
                                // );

                                // // opening the pdf file
                                // FileHandleApi.openFile(pdfFile);
                              },
                              child: const Text('Download Invoice PDF'),
                            ),
                            //create restart process
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: secondaryColor,
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                pdfController.clearAllData();
                              },
                              child: const Text('Start New Invoice'),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  //header of datatable
                  (context.tableData.isEmpty)
                      ? Container()
                      : Scrollbar(
                          controller: _scrollController,

                          // interactive: true,
                          // scrollbarOrientation: ScrollbarOrientation.bottom,
                          thumbVisibility: true,
                          trackVisibility: true,
                          interactive: true,

                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Sr \nNo')),
                                DataColumn(label: Text('Item &\nDescription')),
                                DataColumn(label: Text('Qty')),
                                DataColumn(label: Text('Amount')),
                                DataColumn(label: Text(""))
                              ],
                              rows: context.tableData.map<DataRow>(
                                (data) {
                                  final index = context.tableData.indexOf(data);
                                  return DataRow(
                                    onLongPress: () {
                                      context.tableData.remove(data);
                                      context.update();
                                    },
                                    cells: [
                                      DataCell(Text(data[0])),
                                      DataCell(
                                        SingleChildScrollView(
                                          child: SizedBox(
                                            width: 200,
                                            child: ExpandableText(data[1],
                                                expandText: 'more',
                                                collapseText: 'less',
                                                maxLines: 2,
                                                linkColor: primaryColor),
                                          ),
                                        ),
                                      ),
                                      DataCell(Text(data[2])),
                                      DataCell(Text(data[3])),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            //create showbottomsheet to update value
                                            context.srnoControlleru.text =
                                                data[0];
                                            context.itemControlleru.text =
                                                data[1];
                                            context.qtyControlleru.text =
                                                data[2];
                                            context.amountControlleru.text =
                                                data[3];
                                            showModalBottomSheet(
                                                context: bcontext,
                                                builder: (s) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Form(
                                                        key: key2,
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        context
                                                                            .srnoControlleru,
                                                                    // validator: (value) {
                                                                    //   if (value!.isEmpty) {
                                                                    //     return 'Enter Sr No';
                                                                    //   }
                                                                    //   return null;
                                                                    // },
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      border: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                      hintText:
                                                                          'Sr No',
                                                                      label: const Text(
                                                                          'Sr No'),
                                                                      alignLabelWithHint:
                                                                          true,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      TextFormField(
                                                                    textInputAction:
                                                                        TextInputAction
                                                                            .next,
                                                                    inputFormatters: [
                                                                      LengthLimitingTextInputFormatter(
                                                                          50),
                                                                    ],
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return 'Enter quantity';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    controller:
                                                                        context
                                                                            .qtyControlleru,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      border: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                      hintText:
                                                                          'Qty',
                                                                      label: const Text(
                                                                          'Qty'),
                                                                      alignLabelWithHint:
                                                                          true,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      TextFormField(
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return 'Enter amount';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    textInputAction:
                                                                        TextInputAction
                                                                            .next,
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter
                                                                          .digitsOnly,
                                                                      LengthLimitingTextInputFormatter(
                                                                          50),
                                                                    ],
                                                                    controller:
                                                                        context
                                                                            .amountControlleru,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      border: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                      hintText:
                                                                          'Amount',
                                                                      label: const Text(
                                                                          'Amount'),
                                                                      alignLabelWithHint:
                                                                          true,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextFormField(
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return 'Please enter item & description';
                                                                }
                                                                return null;
                                                              },
                                                              controller: context
                                                                  .itemControlleru,
                                                              maxLines: 3,
                                                              maxLength: 70,
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                hintText:
                                                                    'Item & Description',
                                                                label: const Text(
                                                                    'Item & Description'),
                                                                alignLabelWithHint:
                                                                    true,
                                                              ),
                                                            ),
                                                            ElevatedButton.icon(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                foregroundColor:
                                                                    secondaryColor,
                                                                backgroundColor:
                                                                    primaryColor,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                if (!key2
                                                                    .currentState!
                                                                    .validate()) {
                                                                  Get.snackbar(
                                                                    '',
                                                                    'Please fill all fields',
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .BOTTOM,
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    colorText:
                                                                        Colors
                                                                            .white,
                                                                    titleText:
                                                                        Container(),
                                                                  );
                                                                  return;
                                                                }
                                                                context
                                                                    .updateTableBasedOnIndex(
                                                                        index);
                                                              },
                                                              icon: const Icon(
                                                                  Icons.add),
                                                              label: const Text(
                                                                  'Update Item'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                  // (context.tableData.isEmpty)
                  // ? Container()
                  // :
                  // SizedBox(
                  //   height: 200,
                  //   child: PdfPreview(build: (format) {
                  //     return pdfController.generate(
                  //       themeColor,
                  //       pw.Font.courier(),
                  //     ).then((file) => file.readAsBytesSync());
                  //   }),
                  // ),

                  //   Row(
                  //   children: [
                  //     Expanded(
                  //       child: Text('Sr No'),
                  //     ),
                  //     Expanded(
                  //       child: Text('Item & Description'),
                  //     ),
                  //     Expanded(
                  //       child: Text('Qty'),
                  //     ),
                  //     Expanded(
                  //       child: Text('Amount'),
                  //     ),
                  //   ],
                  // ),
                  // ListView.builder(
                  //   itemCount: context.tableData.length,
                  //   shrinkWrap: true,
                  //   itemBuilder: (_, index) {
                  //     return  Row(
                  //       children: [
                  //         Expanded(
                  //           child: Text(context.tableData[index][0])
                  //         ),
                  //         Expanded(
                  //           child: Text(context.tableData[index][1]),
                  //         ),
                  //         Expanded(
                  //           child: Text(context.tableData[index][2]),
                  //         ),
                  //         Expanded(
                  //           child: Text(context.tableData[index][3]),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
