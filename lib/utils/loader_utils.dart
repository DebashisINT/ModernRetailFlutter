import 'package:flutter/material.dart';
import 'package:modern_retail/utils/app_color.dart';

class LoaderUtils {
  // Singleton instance
  static final LoaderUtils _instance = LoaderUtils._internal();
  factory LoaderUtils() {
    return _instance;
  }
  LoaderUtils._internal();

  void showLoader(BuildContext context, {String loadingText = "Loading..."}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent dismissing by back button
          child: Dialog(
            backgroundColor: Colors.transparent, // Make the dialog background transparent
            insetPadding: const EdgeInsets.all(50), // Add padding around the dialog
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Light grey background
                borderRadius: BorderRadius.circular(22.0), // Rounded corners
              ),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Wrap content horizontally
                children: [
                  SizedBox(width: 20),
                  SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(
                      color: Colors.black87, // Dark grey progress indicator
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      loadingText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void dismissLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

// Usage Example
// To show the loader:
// CustomLoader.showLoader(context, loadingText: "Please wait...");

// To hide the loader:
// CustomLoader.hideLoader(context);
