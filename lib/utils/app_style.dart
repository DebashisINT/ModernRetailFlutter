import 'package:flutter/material.dart';
import 'package:modern_retail/utils/app_color.dart';

class AppStyle {
  // Singleton instance
  static final AppStyle _instance = AppStyle._internal();
  factory AppStyle() {
    return _instance;
  }
  AppStyle._internal();

  TextStyle toolbarTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColor.colorWhite,
  );

  TextStyle textStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColor.colorBlack,
  );

  TextStyle textHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColor.colorBlack,
  );

  TextStyle orderHeaderStyle = TextStyle(
    fontSize: 15,
    color: AppColor.colorDeepGreen,
  );

  TextStyle labelStyle = TextStyle(
    color: AppColor.colorGrey, // Color for the label text
    fontSize: 14, // Optional: adjust font size
    fontWeight: FontWeight.normal, // Optional: adjust font weight
  );

  TextStyle hintStyle = TextStyle(
    color: AppColor.colorGrey, // Color for the label text
    fontSize: 14, // Optional: adjust font size
    fontWeight: FontWeight.normal, // Optional: adjust font weight
  );

  EdgeInsets cardMargin = EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0);
  double cardEvevation = 5.0;
  RoundedRectangleBorder cardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(15.0),
  );

  ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColor.colorButton, // Background color
    foregroundColor: AppColor.colorWhite, // Text color
    shadowColor: AppColor.colorGrey, // Shadow color
    elevation: 5, // Elevation for shadow effect
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // Rounded corners
    ),
    textStyle: const TextStyle(
      fontSize: 16, // Text size
      fontWeight: FontWeight.normal, // Text weight
      color: AppColor.colorWhite, // Text color (use this if you want to override foregroundColor)
    ),
  );

  BoxShadow boxShadow = BoxShadow(
  color: AppColor.colorGrey, // Shadow color
  blurRadius: 2, // Blur radius
  spreadRadius: 1, // Spread radius
  offset: Offset(0, 1), // Shadow offset
  );

  BoxShadow boxShadowLargeView = BoxShadow(
    color: AppColor.colorGrey, // Shadow color
    blurRadius: 4, // Blur radius
    spreadRadius: 1, // Spread radius
    offset: Offset(0, 1), // Shadow offset
  );
}