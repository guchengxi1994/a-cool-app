import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static Future<void> saveColorData(List<String> ls) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("colorData", ls);
  }
}
