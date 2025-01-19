import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modern_retail/utils/app_color.dart';

class SnackBarUtils {

  // Singleton instance
  static final SnackBarUtils _instance = SnackBarUtils._internal();
  factory SnackBarUtils() {
    return _instance;
  }
  SnackBarUtils._internal();
  
  void showSnackBar(BuildContext context, String msg,{String imagePath = "assets/images/ic_logo.webp"}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Image.asset(
              imagePath,
              width: 35,
              height: 35,
              fit: BoxFit.contain,
            ), // Display the image
            SizedBox(width: 10), // Add spacing between image and text
            Expanded(
              child: Text(
                msg,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ), // Customize text color
              ),
            ),
          ],
        ),
        backgroundColor: AppColor.colorGreenPastel,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(left: 30,right: 30,bottom: 100),// EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 3),
        elevation: 16.0, // Adds shadow for elevation
      ),
    );
  }


}