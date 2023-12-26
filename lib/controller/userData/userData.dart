import 'package:shared_preferences/shared_preferences.dart';

userData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('sid', '');
  prefs.setString('login', 'true');
  String? hotelName = prefs.getString('hotelName');
  String? phoneno = prefs.getString('phoneno');
}

getId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('sid');
}
