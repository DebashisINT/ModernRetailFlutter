import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_one/api/login_type_req.dart';
import 'package:flutter_demo_one/database/app_database.dart';
import 'package:flutter_demo_one/screens/dashboard_screen.dart';
import 'package:http/http.dart' as http;
import '../api/api_service.dart';
//import '../api/login_request.dart';
import '../api/store_type_req.dart';
import '../app_color.dart';
import '../database/store_type_entity.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  State<LoginScreen> createState() => _LoginScreen();

}

class _LoginScreen extends State<LoginScreen>{
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final dio = Dio();

  bool _isChecked = false;
  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Set the status bar color
        statusBarIconBrightness: Brightness.dark, // Use light or dark icons
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
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
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black45, // Shadow color
                          offset: Offset(2, 2), // Horizontal and vertical offset
                          blurRadius: 2, // Blur radius for a softer shadow
                        ),
                      ],// Bold font weight
                    ),
                  ),
                  SizedBox(height: 40),

                  // Username TextField
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0), // Active (focused) color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0), // Inactive (unfocused) color
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0), // Spacing between fields

                  // Password TextField
                  TextField(
                    controller: passwordController,
                    obscureText: true, // Hides the text for password input
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0), // Active (focused) color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0), // Inactive (unfocused) color
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0), // Spacing before the button

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: _toggleCheckbox,
                        activeColor: Colors.blue, // Change the color when selected
                        checkColor: Colors.white,
                      ),
                      Text('Remember Me'),
                    ],
                  ),
                  SizedBox(height: 10.0),

                  // Login Button
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shadowColor: Colors.black87,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: const BorderSide(color: Colors.black26, width: 0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        backgroundColor: AppColor.colorButton,
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        // Handle button press
                        String username = usernameController.text;
                        String password = passwordController.text;
                        if (username == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter username')));
                        } else if (password == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter password')));
                        } else {
                          if(_isChecked){
                            await pref.setString('userLoginID', username);
                            await pref.setString('userLoginPassword', password);
                          }else{
                            await pref.setString('userLoginID', "");
                            await pref.setString('userLoginPassword', "");
                          }
                          doLogin(username, password);
                        }
                      },
                      child: const Text('Login', style: TextStyle(color: AppColor.colorWhite)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/loginbanner.jpg', // Path to the bottom image asset
              width: double.infinity, // Makes the image stretch across the width
              height: 100, // Set the height of the bottom image
              fit: BoxFit.cover, // You can adjust this as needed
            ),
          ),
        ],
      ),
    );
  }

  Future<void> doLogin(username,password) async {
    try {
      final apiService = ApiService(dio);
      final userRequest = LoginTypeReq(login_id: username,login_password: password,app_version: "1.0.1",device_token: "" );
      final userResponse = await apiService.doLogin(userRequest);

      if(userResponse.status == "200"){
        await pref.setString('user_id', userResponse.user_id);
        await pref.setString('user_name', userResponse.user_name);
        apiCallShopType();
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(userResponse.message)),);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> apiCallShopType() async {
    try {
      final apiService = ApiService(dio);
      final userRequest = StoreTypeReq(user_id: pref.getString('user_id') ?? "");
      final response = await apiService.getStoreType(userRequest);

      if(response.status == "200"){
        final itemDao = appDatabase.storeTypeDao;
        for(int i = 0; i<response.storeTypeList.length;i++){
          await itemDao.insertStoreType(StoreTypeEntity(type_id: response.storeTypeList[i].typeId,type_name: response.storeTypeList[i].typeName));
        }
      }else{
        print("User Created: ${response.status}");
      }

    } catch (error) {
      print('Error: $error');
    }
  }
  Future<void> apiCallProduct() async {
    try {
      final apiService = ApiService(dio);
      final userRequest = StoreTypeReq(user_id: pref.getString('user_id') ?? "");
      final response = await apiService.getStoreType(userRequest);

      if(response.status == "200"){
        final itemDao = appDatabase.storeTypeDao;
        for(int i = 0; i<response.storeTypeList.length;i++){
          await itemDao.insertStoreType(StoreTypeEntity(type_id: response.storeTypeList[i].typeId,type_name: response.storeTypeList[i].typeName));
        }
      }else{
        print("User Created: ${response.status}");
      }

    } catch (error) {
      print('Error: $error');
    }
  }
}