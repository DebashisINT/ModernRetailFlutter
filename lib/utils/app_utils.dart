import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

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

  void showCustomDialogWithOrderId(BuildContext context, String title, String msg, String orderId, VoidCallback callback) {
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
          content: Column(
            mainAxisSize: MainAxisSize.min, // Adjust to content size
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: 50, // Minimum height for the main message
                ),
                child: Center(
                  child: Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Add spacing between the message and the Order ID
              Container(
                constraints: BoxConstraints(
                  minHeight: 30, // Minimum height for the Order ID
                ),
                child: Center(
                  child: Text(
                    "Order ID: #$orderId",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColor.colorGreenLeaf, // Set the color of the Order ID text here
                    ),
                  ),
                ),
              ),
            ],
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


  static void showOrderDeleteDialog({
    required BuildContext context,
    required String title,
    required String msg,
    required String orderId,
    required VoidCallback onCancel,
    required VoidCallback onDelete,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 320), // Adjust max width as needed
          child: AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20), // Reduce space on left and right
            title: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            content: SingleChildScrollView(
              child: Center(
                child: Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shadowColor: Colors.black87,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: Colors.black26, width: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: AppColor.colorGrey,
                ),
                onPressed: onCancel,
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 14, color: AppColor.colorBlack),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shadowColor: Colors.black87,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: Colors.black26, width: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: AppColor.colorButton,
                ),
                onPressed: onDelete,
                child: Text(
                  'Delete',
                  style: TextStyle(fontSize: 14, color: AppColor.colorWhite),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  static String getDateFromDateTime(String dateTimeString) {
    try {
      // Parse the datetime string
      DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString);
      // Format to extract only the date
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      // Handle invalid format or parsing error
      return '';
    }
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
