//ask for storage permission
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
