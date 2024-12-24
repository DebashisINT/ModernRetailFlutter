import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_color.dart';

class StoreAddScreen extends StatefulWidget {
  const StoreAddScreen({super.key});

  State<StoreAddScreen> createState() => _StoreAddScreen();

}

class _StoreAddScreen extends State<StoreAddScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Form'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner with an image and a circular camera icon
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner Image
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/store_dummy.jpg'), // Replace with your image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Camera Icon
                Positioned(
                  bottom: -35,
                  left: MediaQuery.of(context).size.width / 2 - 35,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.teal,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50), // Space to avoid overlap

            // Input Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  buildInputField(Icons.store, 'Store type', isDropdown: true),
                  buildInputField(Icons.store, 'Store Name'),
                  buildInputField(Icons.location_on, 'Address'),
                  buildInputField(Icons.pin_drop, 'Pincode'),
                  buildInputField(Icons.person, 'Contact Name'),
                  buildInputField(Icons.phone, 'Contact Number'),
                  buildInputField(Icons.phone, 'Alternet Contact Number'),
                  buildInputField(Icons.phone, 'Whatsapp Number'),
                  buildInputField(Icons.phone, 'Email'),
                  buildInputField(Icons.phone, 'Size/Area'),
                  buildInputField(Icons.phone, 'remarks'),

                  //  Button
                  SizedBox(height: 20.0),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shadowColor: Colors.black87,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: const BorderSide(color: Colors.black26, width: 0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        backgroundColor: AppColor.colorButton,
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                      },
                      child: const Text('Login', style: TextStyle(color: AppColor.colorWhite)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to Build Input Fields
  Widget buildInputField(IconData icon, String hint, {bool isDropdown = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 12),
          Expanded(
            child: isDropdown
                ? DropdownButton<String>(
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(
                hint,
                style: TextStyle(color: Colors.grey[700]),
              ),
              items: [
                DropdownMenuItem(value: 'Type1', child: Text('Type1')),
                DropdownMenuItem(value: 'Type2', child: Text('Type2')),
              ],
              onChanged: (value) {},
            )
                : TextField(
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0), // Optional: to add padding around the image
                  child: Image.asset(
                    'assets/images/icuser.png', // Your custom icon image
                    width: 14, // You can set width and height to fit
                    height: 14,
                    fit: BoxFit.contain,
                  ),
                ),
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ),
        ],
      ),
    );
  }

}