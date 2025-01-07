import 'package:fl/screen/login_screen.dart';
import 'package:fl/screen/order_fragment.dart';
import 'package:fl/screen/stock_add_fragment.dart';
import 'package:fl/screen/store_fragment.dart';
import 'package:fl/utils/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import '../main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  State<DashboardScreen> createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {

  final _drawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColor.colorBluePeacock,AppColor.colorGreenMoss]
          )
        ),
      ),
      controller: _drawerController,

      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 350),
      animateChildDecoration: true,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color : AppColor.colorCharcoal,
            blurRadius: 100
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      drawer: SafeArea(
          child:ListTileTheme(
            textColor: AppColor.colorWhite,
              iconColor: AppColor.colorGrey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(100), // Half of the width/height for a circle
                      color: AppColor.colorSmokeWhite, // Make the Material background transparent
                      child: Container(
                        width: 110,
                        height: 110,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(
                            'assets/images/ic_user_color.png',
                            fit: BoxFit.fill,
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(pref.getString('user_name') ?? 'User',
                    style: TextStyle(color: AppColor.colorWhite,fontSize: 18,fontWeight: FontWeight.bold,),),

                  SizedBox(height: 10,),

                  buildCustomMenu(context,'assets/images/ic_home_color.png',"Home", () {
                    _drawerController.hideDrawer();
                    },
                  ),
                  buildCustomMenu(context,'assets/images/ic_store_color.jpg',"Store", () {
                    _drawerController.hideDrawer();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StoreFragment()),);
                  },
                  ),
                  buildCustomMenu(context,'assets/images/ic_stock.png',"Stock", () {
                    _drawerController.hideDrawer();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StockAddFragment()),);
                    },
                  ),
                  buildCustomMenu(context,'assets/images/ic_logout.png',"Logout", () {
                    _drawerController.hideDrawer();
                    pref.setBool('isLoggedIn', false);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
                  },
                  ),
                  /*const Spacer(),
                  DefaultTextStyle(
                      style: const TextStyle(fontSize: 14,color : Colors.white54),
                      child: const Text("Privacy Policy")),
                  SizedBox(height: 100,)*/
                ],
              )
          )
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Home",
              style: TextStyle(color: AppColor.colorWhite,fontSize: 20),
            ),
          ),
          backgroundColor: AppColor.colorToolbar,
          leading: IconButton(
              onPressed: _handleMenuButton,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _drawerController,
                builder: (_,value,__){
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key:ValueKey<bool>(value.visible),
                      color: Colors.white,
                    ),
                  );
                },
              ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications,color: AppColor.colorWhite, // Set the icon color here
                  size: 25.0),
              onPressed: () {
                // Handle notification icon press
              },
            ),
          ],
        ),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  height: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.colorToolbar,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 40.0), // Adds left margin (20dp)
                        width: 40, // Width of the rectangle
                        height: 40, // Height of the rectangle
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
                      Expanded( // Use Expanded to allow the Column to take available space
                        child: Align(
                          alignment: Alignment.centerLeft,// Center the Column horizontally
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Center the text vertically
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome,",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                pref.getString('user_name') ?? 'User',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin:  EdgeInsets.only(top: 20.0),
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 20),
                            buildRow(context, [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoreFragment()),);
                                },
                                child: buildCustomCard(
                                  context,
                                  'assets/images/ic_store_color.jpg',
                                  'Stores',
                                  Color(0xff88bfff),
                                  'assets/images/dashboard_img_1.png',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => StockAddFragment()),);
                                },
                                child: buildCustomCard(
                                  context,
                                  'assets/images/ic_stock.png',
                                  'Stock',
                                  Color(0xffe79bfe),
                                  'assets/images/dashboard_img_2.png',
                                ),
                              ),
                            ]),
                            SizedBox(height: 40),
                            buildRow(context, [
                              GestureDetector(
                                onTap: () {

                                },
                                child: buildCustomCard(
                                  context,
                                  'assets/images/ic_planogram.png',
                                  'Planogram',
                                  Color(0xff88bfff),
                                  'assets/images/dashboard_img_3.png',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {

                                },
                                child: buildCustomCard(
                                  context,
                                  'assets/images/ic_stock.png',
                                  'Complaint & Feedback',
                                  Color(0xffe79bfe),
                                  'assets/images/dashboard_img_4.png',
                                ),
                              ),
                            ]),
                            SizedBox(height: 40),
                            buildRow(context, [
                              GestureDetector(
                                onTap: () {
                                },
                                child: buildCustomCard(
                                  context,
                                  'assets/images/ic_order_color.png',
                                  'Order',
                                  Color(0xff88bfff),
                                  'assets/images/dashboard_img_5.png',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {

                                },
                                child: buildCustomCard(
                                  context,
                                  'assets/images/ic_survey_color.png',
                                  'Survey',
                                  Color(0xffe79bfe),
                                  'assets/images/dashboard_img_6.png',
                                ),
                              ),
                            ]),
                            SizedBox(height: 40),
                            buildRow(context, [
                              GestureDetector(
                                onTap: () {

                                },
                                child: buildCustomCard(
                                  context,
                                  'assets/images/ic_merchandise.png',
                                  'Merchandising Operations',
                                  Color(0xff88bfff),
                                  'assets/images/dashboard_img_7.png',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {

                                },
                                child: buildCustomCard(
                                  context,
                                  'assets/images/ic_calender.png',
                                  'Daily Activity',
                                  Color(0xffe79bfe),
                                  'assets/images/dashboard_img_8.png',
                                ),
                              ),
                            ]),
                            SizedBox(height: 40),
                            buildRow(context, [
                              GestureDetector(
                                onTap: () {

                                },
                                child: buildCustomCard(
                                  context,
                                  'assets/images/ic_catalog.png',
                                  'Product Catalog',
                                  Color(0xff88bfff),
                                  'assets/images/dashboard_img_9.png',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {

                                },
                                child: buildCustomCard(
                                  context,
                                  'assets/images/ic_sales_promotion.png',
                                  'Sales Promotion/Offer/Scheme/Discount',
                                  Color(0xffe79bfe),
                                  'assets/images/dashboard_img_10.png',
                                ),
                              ),
                            ]),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
      ),
    );
  }

  ListTile buildCustomMenu(BuildContext context,String iconPath,String title,VoidCallback onTapAction){
    return ListTile(
      onTap: (){
        onTapAction();
      },
      leading: Image.asset(
        iconPath,
        width: 24,
        height: 24,
      ),
      title: Text(title),
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
        Align(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            widthFactor: 0.25, // Adjust as needed (e.g., 0.2 for 20% of card width)
            child: Transform.translate(
              offset: const Offset(0, -25), // Adjust as needed
              child: CircleAvatar(
                radius: 25,
                backgroundColor: backgroundColor,
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      icon,
                      fit: BoxFit.fill,
                      width: 45,
                      height: 45,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildRow(BuildContext context, List<Widget> children) {
    return Row(
      children: children
          .map(
            (child) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0), // Space between cards
            child: child,
          ),
        ),
      )
          .toList(),
    );
  }

  void _handleMenuButton(){
    _drawerController.showDrawer();
  }
  
}