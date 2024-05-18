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
  Get.showSnackbar(GetBar(
    message: 'Permission granted',
    duration: Duration(seconds: 2),
  ));
  }
  else {
    Get.showSnackbar(GetBar(
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
      //..... as needed
    ].request(); //import 'package:permission_handler/permission_handler.dart';

    havePermission = request.values.every((status) => status == PermissionStatus.granted);
  } else {
    final status = await Permission.storage.request();
    havePermission = status.isGranted;
  }

  if (!havePermission) {
    // if no permission then open app-setting
    await openAppSettings();
  }

  return havePermission;
}