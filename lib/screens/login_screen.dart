import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_one/api/login_type_req.dart';
import 'package:flutter_demo_one/database/app_database.dart';
import 'package:http/http.dart' as http;
import '../api/api_service.dart';
//import '../api/login_request.dart';
import '../api/store_type_req.dart';
import '../app_color.dart';
import '../database/store_type_entity.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  State<LoginScreen> createState() => _LoginScreen();

}

class _LoginScreen extends State<LoginScreen>{
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 60, // Set desired width for the image
                  height: 60, // Set desired height for the image
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.jpg'), // Path to your image asset
                      fit: BoxFit.cover, // This will cover the entire container, cropping if necessary
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Fixed height of 60 pixels from the top

              Text(
                'Login',
                style: TextStyle(
                  fontSize: 34.0,  // Custom font size
                  fontWeight: FontWeight.bold,  // Bold font weight
                ),
              ),
              SizedBox(height: 20),

              // Username TextField
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0), // Spacing between fields

              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true, // Hides the text for password input
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0), // Spacing before the button

              // Login Button
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: const BorderSide(color: Colors.black26, width: 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    // Handle button press
                    String username = usernameController.text;
                    String password = passwordController.text;
                    if(username == ""){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter username')),);
                    }else if (password == ""){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter password')),);
                    }else{
                      doLogin(username,password);
                      //makePostRequestOne();
                    }
                    /*ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Username: $username, Password: $password')),
                  );*/
                  },
                  child: const Text('Login',style: TextStyle(color: AppColor.colorWhite),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> doLogin(username,password) async {
    try {

      final dio = Dio();
      final apiService = ApiService(dio);
      final userRequest = LoginTypeReq(login_id: username,login_password: password,app_version: "1.0.1",device_token: "" );
      final userResponse = await apiService.doLogin(userRequest);

      print("User login response: ${userResponse.status}");

    } catch (error) {
      print('Error: $error');
    }
  }


  Future<void> apiCall() async {
    try {
      /*  final database = await $FloorAppDatabase
          .databaseBuilder('app_database.db')
          .build();*/
      //final itemDao = database.storeTypeDao;
      //final newItem = StoreTypeEntity(title: 'T1',desc: 'Desc t1');
      //await itemDao.insertStoreType(newItem);

      final dio = Dio(); // Provide a Dio instance
      final apiService = ApiService(dio);
      final userRequest = StoreTypeReq(user_id: "11707");
      final response = await apiService.getStoreType(userRequest);

      if(response.status == "200"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      }else{
        print("User Created: ${response.status}");
      }


    } catch (error) {
      print('Error: $error');
    }
  }
}