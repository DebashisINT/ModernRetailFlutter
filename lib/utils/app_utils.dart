import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'app_color.dart';

class AppUtils {
  // Singleton instance
  static final AppUtils _instance = AppUtils._internal();
  factory AppUtils() {
    return _instance;
  }
  AppUtils._internal();

  Future<String> getAddress(double latitude, double longitude) async {
    String address = "";
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0]; // Get the first placemark

        address = placemark.street! +
            ', ' +
            placemark.locality! +
            ', ' +
            placemark.administrativeArea! +
            ', ' +
            placemark.country!;
        String pincode = placemark.postalCode!;
        return address;
      } else {
        return address;
      }
    } catch (e) {
      print('Error getting address and pincode: $e');
      return address;
    }
  }

  Future<String> getPincode(double latitude, double longitude) async {
    String address = "";
    String pincode = "";
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0]; // Get the first placemark

        address = placemark.street! +
            ', ' +
            placemark.locality! +
            ', ' +
            placemark.administrativeArea! +
            ', ' +
            placemark.country!;
         pincode = placemark.postalCode!;
        return pincode;
      } else {
        return pincode;
      }
    } catch (e) {
      print('Error getting address and pincode: $e');
      return pincode;
    }
  }

  void showCustomDialog(BuildContext context, String title, String msg, VoidCallback callback) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Center(
            child: Text(
              title,
              textAlign: TextAlign.center, // Center the title
              style: const TextStyle(fontSize: 18),
            ),
          ),
          content: Container(
            constraints: BoxConstraints(
              minHeight: 100, // Minimum height for content
            ),
            child: Center(
              child: Text(
                msg,
                textAlign: TextAlign.center, // Center the content
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: AppColor.colorButton, // Background color for the button
                borderRadius: BorderRadius.circular(0), // Rounded corners
              ),
              child: CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  callback();
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> checkConnectivity() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.mobile) {
      return true;
    } else if (result == ConnectivityResult.wifi) {
      return true;
    } else if (result == ConnectivityResult.ethernet) {
      return true;
    } else if (result == ConnectivityResult.none) {
      return false;
    }else{
      return false;
    }
  }

}
