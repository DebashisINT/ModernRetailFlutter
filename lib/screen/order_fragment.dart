import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class OrderFragment extends StatefulWidget {
  @override
  _OrderFragment createState() => _OrderFragment();
}

class _OrderFragment extends State<OrderFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        blurRadius: 10, // Blur radius
                        spreadRadius: 2, // Spread radius
                        offset: Offset(4, 4), // Shadow offset
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage("assets/images/store_dummy.jpg"), // Replace with your image path
                      fit: BoxFit.fill, // Adjust image scaling
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Column(
                  children: [
                    Text(
                      'Store Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.colorBlack,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 40, // Fixed height for text box
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Store Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.colorBlack,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5.0,
        onPressed: () {},
        backgroundColor: AppColor.colorToolbar,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: AppColor.colorSmokeWhite,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          "Order Details",
          style: TextStyle(color: AppColor.colorWhite, fontSize: 20),
        ),
      ),
      backgroundColor: AppColor.colorToolbar,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        // Back button on the left
        onPressed: () {
          Navigator.pop(context); // Navigate back
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.home, color: Colors.white), // Home icon on the right
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ],
    );
  }
}
