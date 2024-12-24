import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveData() async {
  final prefs = await SharedPreferences.getInstance();

  // Save data
  await prefs.setString('userLoginID', '');
  await prefs.setString('userLoginPassword', '');
  await prefs.setString('user_id', '');
  await prefs.setString('user_name', '');
  await prefs.setBool('isLoggedIn', true);    // Save a boolean
  await prefs.setBool('isLoginRemember', false);    // Save a boolean


  //await prefs.setStringList('hobbies', ['Reading', 'Gaming']); // Save a list of strings
}

Future<void> getData() async {
  final prefs = await SharedPreferences.getInstance();

  String? username = prefs.getString('userLoginID');
  String? userLoginPassword = prefs.getString('userLoginPassword');
  String? user_id = prefs.getString('user_id');
  String? user_name = prefs.getString('user_name');
  bool? isLoggedIn = prefs.getBool('isLoggedIn');
  bool? isLoginRemember = prefs.getBool('isLoginRemember');

  //List<String>? hobbies = prefs.getStringList('hobbies');

}