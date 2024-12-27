import 'package:flutter/material.dart';
import 'package:flutter_demo_one/database/app_database.dart';
import 'package:flutter_demo_one/screens/login_screen.dart';
import 'package:flutter_demo_one/screens/splash_screen.dart';
import 'package:flutter_demo_one/screens/store_add_screen.dart';
import 'package:flutter_demo_one/screens/store_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final AppDatabase appDatabase;
late SharedPreferences pref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initSharedPreferences();
  appDatabase = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

initSharedPreferences() async{
  pref = await SharedPreferences.getInstance();
}

