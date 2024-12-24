import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_one/app_color.dart';
import 'package:flutter_demo_one/screens/store_add_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  State<StoreScreen> createState() => _StoreScreen();

}

class _StoreScreen extends State<StoreScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StoreAddScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,)
      ),
    );
  }

}