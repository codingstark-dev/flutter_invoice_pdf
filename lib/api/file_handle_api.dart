import 'dart:io';
import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class FileHandleApi {
  // save pdf file function
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    try {
      // await storagePermission();

      Directory directory = Directory("");
      Directory downloadDirectory = await getDownloadDirectory();

      if (Platform.isAndroid) {
        // Redirects it to download folder in android
        directory = downloadDirectory;
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      final exPath = directory.path;
      if (kDebugMode) {
        print("Saved Path: $exPath");
      }
      // await Directory(exPath).create(recursive: true);
      final bytes = await pdf.save();

      // final dir = await getApplicationDocumentsDirectory();
      // final dir = await getExternalStorageDirectory();
      final file = File("$exPath/$name");
      // await file.writeAsBytes(bytes);
    await  writeFile(newContent: bytes, name: name);
    // await openDownloadFolder();
      // readFile(FileInfo(
      //     identifier: file.path,
      //     fileName: name,
      //     persistable: false,
      //     uri: file.uri.toString()));
      // await openDownloadFolder();
      //  await openFile(file);

      //open pdf file
      return file;
    } on Exception catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      if (kDebugMode) {
        print('error: $e');
      }
      rethrow;
    }
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
    try {
      final bytes = await pdf.save();

      final dir = await getApplicationDocumentsDirectory();
      // final dir = await getExternalStorageDirectory();
      final file = File("${dir.path}/$name");
      await file.writeAsBytes(bytes);
      // await openDownloadFolder();
      // await openFile(file);

      //open pdf file
      return file;
    } on Exception catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      if (kDebugMode) {
        print('error: $e');
      }
      rethrow;
    }
  }

  static Future<File> saveDocumentTolocal({
    required String name,
    required pw.Document pdf,
  }) async {
    // await requestPermission();
    try {
      final bytes = await pdf.save();

      // final dir = await getApplicationDocumentsDirectory();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes);
      return file;
    } on Exception catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      if (kDebugMode) {
        print('error: $e');
      }
      rethrow;
    }
  }

  // open pdf file function
  static Future openFile(File file) async {
    try {
      // await storagePermission();
      final url = file.path;

      await OpenFile.open(
        url,
        type: 'application/pdf',
      );
    } on Exception catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  static Future readFile(
    // FileInfo fileInfo,
  ) async {
    
    final fileInfo = await FilePickerWritable().openFile((fileInfo, file) async {
      if (kDebugMode) {
        print('Got picker result: $fileInfo');
      }

      // now do something useful with the selected file...
      if (kDebugMode) {
        print('Got file contents in temporary file: $file');
      }
      if (kDebugMode) {
        print('fileName: ${fileInfo.fileName}');
      }
      if (kDebugMode) {
        print('Identifier which can be persisted for later retrieval:'
          '${fileInfo.identifier}');
      }
      await    openFile(file);
      return fileInfo;
    });
    if (fileInfo == null) {
      if (kDebugMode) {
        print('User canceled.');
      }
      return;
    }
  }

//
 static Future<void> writeFile({required Uint8List newContent, required String name}) async {
    // final rand = Random().nextInt(10000000);
    final fileInfo = await FilePickerWritable().openFileForCreate(
      fileName: '$name.pdf',
      writer: (file) async {
        // final content = 'File created at ${DateTime.now}\n\n';
        await file.writeAsBytes(newContent);
      },
    );
    if (fileInfo == null) {
      if (kDebugMode) {
        print('User canceled.');
      }
      return;
    }
        // await readFile();

    if (kDebugMode) {
      print('Wrote file: $fileInfo');
    }
  }
}
