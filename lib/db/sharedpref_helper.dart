import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferHelper {
  static Future<void> saveData(Map<String, dynamic> map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    map.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  static Future<dynamic> getData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static Future<dynamic> removeData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
