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
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: Scaffold(
        appBar: AppBar(title: Text('Dashboard')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Horizontal margin
          child: SingleChildScrollView( // Make the page scrollable
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 35),
                // First Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCustomCard(Icons.store, 'Stores'),
                    buildCustomCard(Icons.inventory, 'Stock'),
                  ],
                ),
                SizedBox(height: 35),

                // Second Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCustomCard(Icons.grid_on, 'Planogram'),
                    buildCustomCard(Icons.feedback, 'Complaint & Feedback'),
                  ],
                ),
                SizedBox(height: 35),

                // Third Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCustomCard(Icons.store, 'Order'),
                    buildCustomCard(Icons.inventory, 'Survey'),
                  ],
                ),
                SizedBox(height: 35),

                // Fourth Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCustomCard(Icons.store, 'Merchandising Operations'),
                    buildCustomCard(Icons.inventory, 'Daily Activity'),
                  ],
                ),
                SizedBox(height: 35),

                // Fifth Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCustomCard(Icons.store, 'Product Catalog'),
                    buildCustomCard(Icons.inventory, 'Sales Promotion/Offer/Scheme/Discount'),
                  ],
                ),
                SizedBox(height: 35),

                // Fifth Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCustomCard(Icons.store, 'Product Catalog'),
                    buildCustomCard(Icons.inventory, 'Sales Promotion/Offer/Scheme/Discount'),
                  ],
                ),
                SizedBox(height: 35)
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildCustomCard(IconData icon, String title) {
    return Stack(
      clipBehavior: Clip.none, // Allows the icon to overflow the card boundaries
      children: [
        // Background card
        Container(
          width: 170,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        // Positioned circle icon
        Positioned(
          top: -25, // Moves the icon upwards, outside the card
          left: 60, // Horizontally centers the icon relative to the card
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
            child: Icon(
              icon,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }


/*
  Widget buildCustomCard(IconData icon, String title) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background card
        Container(
          width: 170,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        // Positioned circle icon
        Positioned(
          top: -25,
          left: 60,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.store, // Use a store-related icon
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
*/

}


