import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_one/app_color.dart';
import 'package:flutter_demo_one/screens/store_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardScreen(),
  ));
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        //statusBarColor: Colors.white, // Set status bar color to white
        statusBarIconBrightness: Brightness.light, // Set icons to dark (black)
      ),
    );
    return Scaffold(
      drawer: Drawer(
        child: Container(  // Add a Container to wrap ListView
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColor.colorToolbar,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Puja Basak",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "puja.basak@indusnet.co.in",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            buildCustomListTile(context, 'Home', 'assets/images/home.jpg'),
            buildCustomListTile(context, 'Store', 'assets/images/store.jpg'),
            buildCustomListTile(context, 'Stock', 'assets/images/stock.jpg'),
            buildCustomListTile(context, 'Logout', 'assets/images/log_out.jpg'),
          ],
        ),
        )
      ),
      body: Column(
        children: [
          buildTopLayout(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 35),
                    buildRow(context, [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StoreScreen()),
                          );
                        },
                        child: buildCustomCard(
                          context,
                          'assets/images/ic_store_color.jpg',
                          'Stores',
                          Color(0xff88bfff),
                          'assets/images/dashboard_img_1.jpg',
                        ),
                      ),
                      buildCustomCard(
                        context,
                        'assets/images/ic_stock.jpg',
                        'Stock',
                        Color(0xffe79bfe),
                        'assets/images/dashboard_img_2.jpg',
                      ),
                    ]),
                    SizedBox(height: 35),
                    buildRow(context, [
                      buildCustomCard(
                        context,
                        'assets/images/ic_planogram.jpg',
                        'Planogram',
                        Color(0xffc1ea87),
                        'assets/images/dashboard_img_3.jpg',
                      ),
                      buildCustomCard(
                        context,
                        'assets/images/ic_complaint.jpg',
                        'Complaint & Feedback',
                        Color(0xffe1d683),
                        'assets/images/dashboard_img_4.jpg',
                      ),
                    ]),
                    SizedBox(height: 35),
                    buildRow(context, [
                      buildCustomCard(
                        context,
                        'assets/images/ic_order_color.jpg',
                        'Order',
                        Color(0xff79dbb5),
                        'assets/images/dashboard_img_5.jpg',
                      ),
                      buildCustomCard(
                        context,
                        'assets/images/ic_survey_color.jpg',
                        'Survey',
                        Color(0xfffdccbc),
                        'assets/images/dashboard_img_6.jpg',
                      ),
                    ]),
                    SizedBox(height: 35),
                    buildRow(context, [
                      buildCustomCard(
                        context,
                        'assets/images/ic_merchandise.jpg',
                        'Merchandising Operations',
                        Color(0xfffeda77),
                        'assets/images/dashboard_img_7.jpg',
                      ),
                      buildCustomCard(
                        context,
                        'assets/images/ic_calender.jpg',
                        'Daily Activity',
                        Color(0xffd3b2fe),
                        'assets/images/dashboard_img_8.jpg',
                      ),
                    ]),
                    SizedBox(height: 35),
                    buildRow(context, [
                      buildCustomCard(
                        context,
                        'assets/images/ic_catalog.jpg',
                        'Product Catalog',
                        Color(0xfff887d7),
                        'assets/images/dashboard_img_9.jpg',
                      ),
                      buildCustomCard(
                        context,
                        'assets/images/ic_sales_promotion.jpg',
                        'Sales Promotion/Offer/Scheme/Discount',
                        Color(0xff93db75),
                        'assets/images/dashboard_img_10.jpg',
                      ),
                    ]),
                    SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }

  Widget buildTopLayout() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: AppColor.colorToolbar,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),

      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar with Menu Icon and Bell Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // Opens the drawer
                    },
                  ),
                ),
                Icon(Icons.notifications, color: Colors.white, size: 28),
              ],
            ),
            SizedBox(height: 20),
            // Welcome Text and Username
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 35.0), // Adds left margin (20dp)
                  width: 60, // Width of the rectangle
                  height: 60, // Height of the rectangle
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the rectangle
                    borderRadius: BorderRadius.circular(10), // Slightly rounded corners
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColor.colorToolbar,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome,",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "User Name",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }


  Widget buildRow(BuildContext context, List<Widget> children) {
    return Row(
      children: children
          .map(
            (child) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Space between cards
            child: child,
          ),
        ),
      )
          .toList(),
    );
  }

  Widget buildCustomCard(BuildContext context, String icon, String title, Color backgroundColor, String imagePath) {
    double cardWidth = MediaQuery.of(context).size.width * 0.45; // Ensures dynamic width
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background card with image
        Container(
          width: cardWidth,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // Positioned circle icon
        Positioned(
          top: -25,
          left: (cardWidth / 2) - 25,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: backgroundColor,
            child: ClipOval(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  icon,
                  fit: BoxFit.cover,
                  width: 45,
                  height: 45,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ListTile buildCustomListTile(BuildContext context, String title, String iconPath) {
    return ListTile(
      contentPadding: EdgeInsets.zero, // Remove default padding from ListTile
      title: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0), // Left and right margin
        padding: EdgeInsets.all(10), // Padding around the content
        decoration: BoxDecoration(
          color: Colors.white, // White background
          borderRadius: BorderRadius.circular(8), // Slight curved corners
          border: Border.all(
            color: Colors.grey[300]!, // Light gray border color
            width: 1.5, // Border width
          ),
        ),
        child: Row(
          children: [
            // Icon
            Image.asset(
              iconPath, // Path to the icon image
              width: 30, // Icon width
              height: 30, // Icon height
              fit: BoxFit.cover, // Ensure the icon fits properly
            ),
            SizedBox(width: 15), // Space between the icon and title text
            // Title text
            Text(
              title,
              style: TextStyle(fontSize: 16), // Title style
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer or perform an action
      },
    );
  }
}
