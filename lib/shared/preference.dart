import 'package:shared_preferences/shared_preferences.dart';

mixin SharedPref {
  static const String event = 'SAVED_EVENT';

  static Future<double?> getEventStart() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final double? _year = preferences.getDouble(event);
    if (_year == -1) {
      return null;
    }
    return _year;
  }

  static Future<void> setEventStart({required double year}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble(event, year);
  }

  static Future<void> resetEventStart() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble(event, -1);
  }
}
