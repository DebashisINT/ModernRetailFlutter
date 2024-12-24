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
      home: Scaffold(
        appBar: AppBar(title: Text('Dashboard')),
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              // First Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCustomCard(Icons.store, 'Stores'),
                  buildCustomCard(Icons.inventory, 'Stock'),
                ],
              ),
              SizedBox(height: 30),

              // Second Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCustomCard(Icons.grid_on, 'Planogram'),
                  buildCustomCard(Icons.feedback, 'Complaint & Feedback'),
                ],
              ),
              SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomCard(IconData icon, String title) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background card
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Stores',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        // Positioned circle icon
        Positioned(
          top: -25,
          left: 50,
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

}


