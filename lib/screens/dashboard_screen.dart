import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  State<DashboardScreen> createState() => _DashboardScreen();

}

class _DashboardScreen extends State<DashboardScreen>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
                  fontWeight: FontWeight.bold,  // Bold font weight
                ),
              ),
              SizedBox(height: 20),

              // Username TextField
            ],
          ),
        ),
      ),
    );
  }

}