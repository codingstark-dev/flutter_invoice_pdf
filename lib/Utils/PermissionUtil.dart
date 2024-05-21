//ask for storage permission
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      Permission.photos,
      // Permission.storage,
      Permission.manageExternalStorage,
    ].request(); //import 'package:permission_handler/permission_handler.dart';
  request.values.forEach((status) {
      debugPrint('Permission status: $status');
    });
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