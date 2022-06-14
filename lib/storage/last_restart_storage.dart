import 'package:shared_preferences/shared_preferences.dart';

class LastRestartStorage {
  static const FIELD = 'last.restart';

  static Future save() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(FIELD, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<DateTime> load() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int timestamp = preferences.getInt(FIELD) ?? 0;

    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}
