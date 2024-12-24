import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  State<DashboardScreen> createState() => _DashboardScreen();

}

class _DashboardScreen extends State<DashboardScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Left container (Stores)
            Expanded(
              child: Container(
                child: Stack(
                  alignment: Alignment.center,  // Align the image at the center
                  children: [
                    // CardView for the text "Stores" slightly down
                    Positioned(
                      top: 20, // Slightly push the CardView down
                      child: Container(
                        width: 175,  // CardView width
                        height: 95, // CardView height
                        decoration: BoxDecoration(
                          color: Color(0xEBEFE0),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2), // Shadow color
                              blurRadius: 0, // Soft shadow
                              offset: Offset(0, 0), // Shadow offset
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Stores",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // Circular ImageView at the top center
                    Positioned(
                      top: 0, // Position it at the top
                      child: Container(
                        width: 50, // Diameter of the circle (fixed size)
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF88BFFF), // Background color
                          shape: BoxShape.circle, // Circle shape
                        ),
                        child: Center( // This will center the image inside the circle
                          child: Image.asset(
                            'assets/images/ic_store_color.jpg', // Your image file
                            width: 30, // You can set the size of the image (optional)
                            height: 30, // You can set the size of the image (optional)
                            fit: BoxFit.contain, // Keeps the aspect ratio intact and ensures the image fits within the circle
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10), // Space between the two containers
            // Right container (Stock)
            Expanded(
              child: Container(
                child: Stack(
                  alignment: Alignment.center,  // Align the image at the center
                  children: [
                    // CardView for the text "Stock" slightly down
                    Positioned(
                      top: 20, // Slightly push the CardView down
                      child: Container(
                        width: 175,  // CardView width
                        height: 95, // CardView height
                        decoration: BoxDecoration(
                          color: Color(0xEBEFE0), // Card background color (Light grey)
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2), // Shadow color
                              blurRadius: 0, // Soft shadow
                              offset: Offset(0, 0), // Shadow offset
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Stock",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // Circular ImageView at the top center
                    Positioned(
                      top: 0, // Position it at the top
                      child: Container(
                        width: 50, // Diameter of the circle (fixed size)
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF88BFFF), // Background color (Blue)
                          shape: BoxShape.circle, // Circle shape
                        ),
                        child: Center( // This will center the image inside the circle
                          child: Image.asset(
                            'assets/images/ic_stock.jpg', // Your image file
                            width: 30, // Image width inside the circle
                            height: 30, // Image height inside the circle
                            fit: BoxFit.contain, // Ensures the image fits inside the circle
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}


