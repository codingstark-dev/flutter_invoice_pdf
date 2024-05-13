import 'dart:io';
import 'package:invoice_pdf_generate/Utils/PermissionUtil.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class FileHandleApi {
  // save pdf file function
  static Future<File> saveDocument({
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
    final url = file.path;

    await OpenFile.open(url);
  }
}
