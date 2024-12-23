import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_color.dart';


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
        title: Center(
          child: Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,// Set the text color to white
            ),
          ),
        ),
        backgroundColor: AppColor.colorToolbar, // Custom toolbar color
        foregroundColor: Colors.white, // Set icon color to white (for any icons in the AppBar)
        actions: [
          IconButton(
            icon: Icon(Icons.notifications), // The notification icon
            onPressed: () {
              print('Notification icon pressed');
            },
          ),
        ],
      ),
      drawer: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Removes curved corners
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // User Account Drawer Header
            UserAccountsDrawerHeader(
              accountName: Text('Puja Basak'),
              accountEmail: Text('puja@indusnet.co.in'),
              currentAccountPicture: Padding(
                padding: const EdgeInsets.only(top: 0.0, left: 0.0), // Adjust margin for the Circle Avatar
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: AppColor.colorToolbar, size: 50),
                ),
              ),
              decoration: BoxDecoration(
                color: AppColor.colorToolbar, // Background color of the header
              ),
            ),
            // Individual Rectangular Boxes
            Container(
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Spacing around the rectangle
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue[100], // Background color for Home
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: ListTile(
                leading: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/images/home.jpg'), // Custom home icon
                ),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.green[100], // Background color for Store
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                leading: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/images/store.jpg'), // Custom home icon
                ),
                title: Text('Store'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.orange[100], // Background color for Stock
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                leading: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/images/stock.jpg'), // Custom home icon
                ),
                title: Text('Stock'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
             /* child: ListTile(
                leading: Icon(Icons.storage, color: Colors.orange[800]),
                title: Text('Stock'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),*/
            ),
            // Logout ListTile
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0), // Add top margin here
        padding: const EdgeInsets.only(left: 16.0, right: 16.0), // Adding top margin and horizontal padding
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 35),
              // First Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCustomCard('assets/images/ic_store_color.jpg', 'Stores', Color(0xff88bfff), 'assets/images/dashboard_img_1.jpg'),
                  buildCustomCard('assets/images/ic_stock.jpg', 'Stock', Color(0xffe79bfe), 'assets/images/dashboard_img_2.jpg'),
                ],
              ),
              SizedBox(height: 35),
              // Second Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCustomCard('assets/images/ic_planogram.jpg', 'Planogram', Color(0xffc1ea87), 'assets/images/dashboard_img_3.jpg'),
                  buildCustomCard('assets/images/ic_complaint.jpg', 'Complaint & Feedback', Color(0xffe1d683), 'assets/images/dashboard_img_4.jpg'),
                ],
              ),
              SizedBox(height: 35),
              // Third Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCustomCard('assets/images/ic_order_color.jpg', 'Order', Color(0xff79dbb5), 'assets/images/dashboard_img_5.jpg'),
                  buildCustomCard('assets/images/ic_survey_color.jpg', 'Survey', Color(0xfffdccbc), 'assets/images/dashboard_img_6.jpg'),
                ],
              ),
              SizedBox(height: 35),
              // Fourth Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCustomCard('assets/images/ic_merchandise.jpg', 'Merchandising Operations', Color(0xfffeda77), 'assets/images/dashboard_img_7.jpg'),
                  buildCustomCard('assets/images/ic_calender.jpg', 'Daily Activity', Color(0xffd3b2fe), 'assets/images/dashboard_img_8.jpg'),
                ],
              ),
              SizedBox(height: 35),
              // Fifth Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCustomCard('assets/images/ic_catalog.jpg', 'Product Catalog', Color(0xfff887d7), 'assets/images/dashboard_img_9.jpg'),
                  buildCustomCard('assets/images/ic_sales_promotion.jpg', 'Sales Promotion/Offer/Scheme/Discount', Color(0xff93db75), 'assets/images/dashboard_img_10.jpg'),
                ],
              ),
              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomCard(String icon, String title, Color backgroundColor, String imagePath) {
    return Stack(
      clipBehavior: Clip.none, // Allows the icon to overflow the card boundaries
      children: [
        // Background card with image
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.grey[200], // Fallback color in case image is not loaded
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imagePath), // Dynamically set background image
              fit: BoxFit.cover, // Adjust how the image fits inside the card
            ),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center, // Ensures the text is horizontally centered
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white to make it visible on dark backgrounds
              ),
            ),
          ),
        ),
        // Positioned circle icon
        Positioned(
          top: -25, // Moves the icon upwards, outside the card
          left: (170 / 2) - 25, // Dynamically centers the icon horizontally
          child: CircleAvatar(
            radius: 25,
            backgroundColor: backgroundColor, // Dynamic background color
            child: ClipOval(
              child: Padding(
                padding: EdgeInsets.all(10), // Adjust padding as needed
                child: Image.asset(
                  icon,
                  fit: BoxFit.cover, // Ensures the image fits within the circle
                  width: 45,  // Set the width of the image smaller
                  height: 45, // Set the height of the image smaller
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


