import 'dart:io';
import 'package:invoice_pdf_generate/Utils/PermissionUtil.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class FileHandleApi {
  // save pdf file function
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    await requestPermission();
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }
    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    final bytes = await pdf.save();

    // final dir = await getApplicationDocumentsDirectory();
    // final dir = await getExternalStorageDirectory();
    final file = File("$exPath/$name");
    await file.writeAsBytes(bytes);
    //open pdf file
    return file;
  }

  static Future<File> saveDocumentTolocal({
    required String name,
    required pw.Document pdf,
  }) async {
    await requestPermission();
    final bytes = await pdf.save();

    // final dir = await getApplicationDocumentsDirectory();
    final dir = await getExternalStorageDirectory();
    final file = File('${dir?.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  // open pdf file function
  static Future openFile(File file) async {
    try {
      await requestPermission();
      final url = file.path;
      

      await OpenFile.open(url);
    } on Exception catch (e) {
      print('error: $e');
    }
  }

  static Future requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
