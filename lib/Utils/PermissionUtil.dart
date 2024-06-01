//ask for storage permission
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:media_storage/media_storage.dart';
import 'package:permission_handler/permission_handler.dart';
Future<void> requestPermission() async {
  final permissionStatus = await Permission.storage.status;
  if (permissionStatus.isDenied) {
    await Permission.storage.request();
    
    
  }
  else if (permissionStatus.isPermanentlyDenied) {
    
    await openAppSettings();
  }
  else if (permissionStatus.isRestricted) {
    await openAppSettings();
  }
  else if (permissionStatus.isLimited) {
    await openAppSettings();
  }
  else if (permissionStatus.isGranted) {
  Get.showSnackbar(const GetBar(
    message: 'Permission granted',
    duration: Duration(seconds: 2),
  ));
  }
  else {
    Get.showSnackbar(const GetBar(
      message: 'Permission denied',
      duration: Duration(seconds: 2),
    ));
  }
  
}
Future<bool> storagePermission() async {
  final DeviceInfoPlugin info = DeviceInfoPlugin(); // import 'package:device_info_plus/device_info_plus.dart';
  final AndroidDeviceInfo androidInfo = await info.androidInfo;
  debugPrint('releaseVersion : ${androidInfo.version.release}');
  final int androidVersion = int.parse(androidInfo.version.release);
  bool havePermission = false;

  if (androidVersion >= 13) {
    final request = await [
      // Permission.photos,
      // Permission.storage,
      Permission.manageExternalStorage,
    ].request(); //import 'package:permission_handler/permission_handler.dart';
  for (var status in request.values) {
      debugPrint('Permission status: $status');
    }
    havePermission = request.values.every((status) => status == PermissionStatus.granted || status == PermissionStatus.limited);
  } else {
    final status = await Permission.storage.request();
    havePermission = status.isGranted;
        debugPrint('Permission status: $status');

  }

  if (!havePermission) {
    Get.showSnackbar(const GetSnackBar(
      message: 'Permission denied to access storage files. Please enable it from settings.',
      duration: Duration(seconds: 2),
    ));
    await openAppSettings();
  }

  return havePermission;
}

//request for storage only download using media storage
// Future<void> requestStoragePermission() async {
// final path = await MediaStorage.getExternalStorageDirectories();
// print(path);

// }

Future<void> readFile() async {
  final fileInfo = await FilePickerWritable().openFile((fileInfo, file) async {
    print('Got picker result: $fileInfo');

    // now do something useful with the selected file...
    print('Got file contents in temporary file: $file');
    print('fileName: ${fileInfo.fileName}');
    print('Identifier which can be persisted for later retrieval:'
        '${fileInfo.identifier}');
    return fileInfo;
  });
  if (fileInfo == null) {
    print('User canceled.');
    return;
  }
}

//
Future<void> writeFile({
  required  content 
}) async {
  final rand = Random().nextInt(10000000);
final fileInfo = await FilePickerWritable().openFileForCreate(
  fileName: 'newfile.$rand.pdf',
  writer: (file) async {
    final content = 'File created at ${DateTime.now()}\n\n';
    await file.writeAsString(content);
  },
);
if (fileInfo == null) {
  print('User canceled.');
  return;
}
// final data = await _appDataBloc.store.load();
// await _appDataBloc.store
//     .save(data.copyWith(files: data.files + [fileInfo]));

}