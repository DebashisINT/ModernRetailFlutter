import 'package:dio/dio.dart';
import 'package:fl/api/response/login_request.dart';
import 'package:fl/api/response/user_id_request.dart';
import 'package:fl/database/order_save_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/api_service.dart';
import '../database/state_pin_entity.dart';
import '../main.dart';
import '../utils/app_color.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isChecked = false;
  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  late TextEditingController usernameController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  String _appVersion = '';
  final apiService = ApiService(Dio());

  @override
  void initState() {
    super.initState();
    if(pref.getBool('isLoginRemember') ?? false){
      usernameController = TextEditingController(text: pref.getString('userLoginID') ?? '');
      passwordController = TextEditingController(text: pref.getString('userLoginPassword') ?? '');
      _isChecked = true;
    }
    _getAppVersion();
    _requestPermissions();
  }


  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      //_appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      _appVersion = '${packageInfo.version}';
    });
  }

  @override
  void dispose() {
    try {
      usernameController.dispose();
      passwordController.dispose();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Set the status bar color
        statusBarIconBrightness: Brightness.light, // Use light or dark icons
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter, // Aligns this child at the bottom
            child: Container(
              color: Colors.transparent, // Example bottom widget
              height: MediaQuery.of(context).size.width * 0.6,
              width: double.infinity,
              child: Center(
                child: Image.asset(
                  'assets/images/login_bottom.webp', // Path to the bottom image asset
                  width: double.infinity, // Makes the image stretch across the width
                  //height: MediaQuery.of(context).size.height *.15, // Set the height of the bottom image
                  fit: BoxFit.fill, // You can adjust this as needed
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/login_top.webp",
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height:10),
                      Image.asset(
                        "assets/images/ic_logo.webp",
                        height: 55,
                        width: 135,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height:20),
                      TextField(
                        controller: usernameController,
                        focusNode: usernameFocusNode,
                        decoration: InputDecoration(
                          hintText: "Username",
                          prefixIcon:  Padding(
                            padding: const EdgeInsets.all(12.0), // Optional: to add padding around the image
                            child: Image.asset(
                              'assets/images/ic_user.png', // Your custom icon image
                              width: 14, // You can set width and height to fit
                              height: 14,
                              fit: BoxFit.contain,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 1.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0), // Inactive (unfocused) color
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon:  Padding(
                            padding: const EdgeInsets.all(12.0), // Optional: to add padding around the image
                            child: Image.asset(
                              'assets/images/ic_lock.png', // Your custom icon image
                              width: 14, // You can set width and height to fit
                              height: 14,
                              fit: BoxFit.contain,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off, // Toggle icon
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible; // Change visibility
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 1.0), // Active (focused) color
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0), // Inactive (unfocused) color
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: _toggleCheckbox,
                            activeColor: AppColor.colorButton, // Change the color when selected
                            checkColor: Colors.white,
                          ),
                          Text('Remember Me'),
                        ],
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        height: 55, // 20% of screen height
                        width: MediaQuery.of(context).size.width * 1, // 50% of screen width
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            side: const BorderSide(color: Colors.black26, width: 0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            backgroundColor: AppColor.colorButton,
                          ),
                          onPressed: () async {
                            usernameFocusNode.unfocus();
                            passwordFocusNode.unfocus();
                            String loginID = usernameController.text;
                            String password = passwordController.text;
                            if(loginID == ""){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter Username')));
                            }else if(password == ""){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter Password')));
                            }else{
                              if(_isChecked){
                                await pref.setString('userLoginID', loginID);
                                await pref.setString('userLoginPassword', password);
                                await pref.setBool('isLoginRemember', true);
                              }else{
                                await pref.setString('userLoginID', "");
                                await pref.setString('userLoginPassword', "");
                                await pref.setBool('isLoginRemember', false);
                              }
                              FocusScope.of(context).unfocus();
                              doLogin(loginID,password);
                            }
                          },
                          child: const Text('Login', style: TextStyle(color: AppColor.colorWhite)),
                        ),
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'App Version: $_appVersion',
                          style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.normal, // Bold font weight
                          ),
                        ),
                      ),
                      SizedBox(height: 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> doLogin(loginID,password) async {
    try {
      showDialog(context: context, builder: (context) {
        return Center(child: CircularProgressIndicator());
      },);
      final loginRequest = LoginRequest(login_id: loginID,login_password: password,app_version: "1.0.1",device_token: "");
      final loginResponse = await apiService.doLogin(loginRequest);
      if(loginResponse.status == "200"){
        await pref.setString('user_id', loginResponse.user_id);
        await pref.setString('user_name', loginResponse.user_name);
        fetchData();
      }else{
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loginResponse.message)),);
      }

    } catch (error) {
      Navigator.of(context).pop();
      print('Error: $error');
    }
  }

  void fetchData() async {
    try {
      Future<void> storeType = apiCallStoreType();
      Future<void> store = apiCallStore();
      Future<void> statePin = apiCallStatePin();
      Future<void> product = apiCallProduct();
      Future<void> productRate = apiCallProductRate();
      Future<void> dummy = dummyOrder();
      // Wait for all of them to complete
      List<void> results = await Future.wait([storeType,store,statePin,product,productRate,dummy]);
      Navigator.of(context).pop();
      pref.setBool('isLoggedIn', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> apiCallStoreType() async {
    try {
      final itemDao = appDatabase.storeTypeDao;
      final storeTypeL = await itemDao.getAll();
      if(storeTypeL.isEmpty) {
        final userRequest = UserIdRequest(user_id: pref.getString('user_id') ?? "");
        final response = await apiService.getStoreType(userRequest);
        if (response.status == "200") {
          await itemDao.deleteAll();
          await itemDao.insertAll(response.storeTypeList);
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> apiCallStore() async {
    try {
      final itemDao = appDatabase.storeDao;
      final storeTypeL = await itemDao.getAll();
      if(storeTypeL.isEmpty) {
        final userRequest = UserIdRequest(user_id: pref.getString('user_id') ?? "");
        final response = await apiService.getStore(userRequest);
        if (response.status == "200") {
          await itemDao.deleteAll();
          await itemDao.insertAll(response.storeList);
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> apiCallStatePin() async {
    try {
      final itemDao = appDatabase.statePinDao;
      final statePinL = await itemDao.getAll();
      if(statePinL.isEmpty){
        final userRequest = UserIdRequest(user_id: pref.getString('user_id') ?? "");
        final response = await apiService.getStatePin(userRequest);
        if(response.status == "200"){
          await itemDao.deleteAll();
          await itemDao.insertAll(response.statePinList);
        }
      }
      print("flow_chk apiCallStatePin end");
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> apiCallProduct() async {
    try {
      final itemDao = appDatabase.productDao;
      final productL = await itemDao.getAll();
      if(productL.isEmpty){
        final userRequest = UserIdRequest(user_id: pref.getString('user_id') ?? "");
        final response = await apiService.getProduct(userRequest);
        if(response.status == "200"){
          await itemDao.deleteAll();
          await itemDao.insertAll(response.productList);
        }
      }
      print("flow_chk apiCallStatePin end");
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> apiCallProductRate() async {
    try {
      final itemDao = appDatabase.productRateDao;
      final productL = await itemDao.getAll();
      if(productL.isEmpty){
        final userRequest = UserIdRequest(user_id: pref.getString('user_id') ?? "");
        final response = await apiService.getProductRate(userRequest);
        if(response.status == "200"){
          await itemDao.deleteAll();
          await itemDao.insertAll(response.productList);
        }
      }
      print("flow_chk apiCallStatePin end");
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> dummyOrder() async {
    try {
      final itemDao = appDatabase.orderSaveDao;
      final dataL = await itemDao.getAll();
      if(dataL.isEmpty){
        await itemDao.deleteAll();
        final obj1 = OrderSaveEntity(order_id: "ord_11223344",
        store_id: "3_20250107111347",order_date_time: "2025-01-07 10:22:23",
        order_amount: "2000",order_status: "Pending");
        final obj2 = OrderSaveEntity(order_id: "ord_11223345",
            store_id: "3_20250107111347",order_date_time: "2025-01-07 10:22:24",
            order_amount: "200000",order_status: "Approved");

        var dataList = List<OrderSaveEntity>.empty(growable: true);
        dataList.add(obj1);
        dataList.add(obj2);
        await itemDao.insertAll(dataList);
      }
      print("flow_chk apiCallStatePin end");
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
    ].request();

    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.location]!.isGranted) {
      // Permissions granted, proceed with camera and location usage
    } else {
      // Handle permission denial
    }
  }

}
