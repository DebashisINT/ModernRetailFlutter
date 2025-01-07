import 'package:fl/screen/order_add_fragment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database/store_entity.dart';
import '../utils/app_color.dart';

class OrderFragment extends StatefulWidget {
  final StoreEntity storeObj;
  const OrderFragment({super.key, required this.storeObj});

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
          children: [
            _buildHeader(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderAddFragment()),
          );
        },
        backgroundColor: AppColor.colorToolbar,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: AppColor.colorSmokeWhite,
    );
  }

  Widget _buildHeader(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 70,
              height: 70,
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
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                mainAxisAlignment: MainAxisAlignment.start, // Ensure text starts from the top
                children: [
                  Text(
                    "${widget.storeObj.store_name}",
                    style: TextStyle(color: AppColor.colorBlack,fontSize: 22.0,
                      fontWeight: FontWeight.bold,),
                  ),
                  SizedBox(height: 10), // Add spacing between text fields
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.transparent, // Background color
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3), // Shadow color
                              blurRadius: 10, // Blur radius
                              spreadRadius: 2, // Spread radius
                              offset: Offset(4, 4), // Shadow offset
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage("assets/images/ic_location.png"), // Replace with your image path
                            fit: BoxFit.fill, // Adjust image scaling
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${widget.storeObj.store_address}",
                            style: TextStyle(color: AppColor.colorBlack,fontSize: 15.0,
                              fontWeight: FontWeight.normal,),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.transparent, // Background color
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3), // Shadow color
                              blurRadius: 10, // Blur radius
                              spreadRadius: 2, // Spread radius
                              offset: Offset(4, 4), // Shadow offset
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage("assets/images/ic_phone.png"), // Replace with your image path
                            fit: BoxFit.fill, // Adjust image scaling
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${widget.storeObj.store_contact_number}",
                            style: TextStyle(color: AppColor.colorBlack,fontSize: 15.0,
                              fontWeight: FontWeight.normal,),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
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

