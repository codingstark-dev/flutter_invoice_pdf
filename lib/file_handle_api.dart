import 'dart:io';
import 'package:downloadsfolder/downloadsfolder.dart';
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
    await storagePermission();

    Directory _directory = Directory("");
    Directory downloadDirectory = await getDownloadDirectory();

    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = downloadDirectory;
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
    // await openDownloadFolder();
   await openFile(file);

    //open pdf file
    return file;
  }

static Future<File> saveTempDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    // await storagePermission();

    // Directory _directory = Directory("");
  
    // final exPath = _directory.path;
    // print("Saved Path: $exPath");
    // await Directory(exPath).create(recursive: true);
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    // final dir = await getExternalStorageDirectory();
    final file = File("${dir.path}/$name");
    await file.writeAsBytes(bytes);
    // await openDownloadFolder();
   // await openFile(file);

    //open pdf file
    return file;
  }
  static Future<File> saveDocumentTolocal({
    required String name,
    required pw.Document pdf,
  }) async {
    // await requestPermission();
    final bytes = await pdf.save();

    // final dir = await getApplicationDocumentsDirectory();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  // open pdf file function
  static Future openFile(File file) async {
    try {
      await storagePermission();
      final url = file.path;

      await OpenFile.open(
        url,
        type: 'application/pdf',
      );
    } on Exception catch (e) {
      print('error: $e');
    }
  }
}
