import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref extends GetxController {
  //save image logo, company name,company address, signature image, qrcode image, gst percentage
 final SharedPreferences prefs;

  SharedPref({required this.prefs});

 

  void saveData({
    required String key,
    required String value,
  }) async {
    await prefs.setString(key, value);
  }
  //get image logo, company name,company address, signature image, qrcode image, gst percentage
  String? getData({
    required String key,
  })  {
    return prefs.getString(key);
  }
  //remove image logo, company name,company address, signature image, qrcode image, gst percentage
  void removeData({
    required String key,
  }) async {
    await prefs.remove(key);
  }
  //clear all data
  void clearData() async {
    await prefs.clear();
  }
}