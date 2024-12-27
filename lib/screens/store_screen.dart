import 'package:flutter/material.dart';
import 'package:flutter_demo_one/app_color.dart';
import 'package:flutter_demo_one/database/store_dao.dart';
import 'package:flutter_demo_one/database/store_entity.dart';
import 'package:flutter_demo_one/screens/store_add_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 20;

  late final StoreDao _storeDao;
  final List<StoreEntity> _storeList = [];

  @override
  void initState() {
    super.initState();
    _storeDao = appDatabase.storeDao;
    _fetchData();
  }

  void _updateData() {
    setState(() {
      _storeList.clear();
      _currentPage = 0;
      _hasMore = true;
    });
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    final offset = _currentPage * _pageSize;
    final stores = await _storeDao.getStorePagination(_pageSize, offset);

    setState(() {
      _storeList.addAll(stores);
      _isLoading = false;
      _hasMore = stores.length == _pageSize;
      if (_hasMore) _currentPage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color of the screen to white
      appBar: AppBar(
        backgroundColor: AppColor.colorToolbar, // Toolbar background color
        foregroundColor: Colors.white, // Back button and icons color
        centerTitle: true, // Ensures the title is centered
        title: const Text(
          'Stores',
          style: TextStyle(
            color: Colors.white, // Title text color
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(), // Back button on the far left
        actions: [
          Row(
            children: [
              // Home icon
              IconButton(
                onPressed: () {
                  // Action for home icon
                },
                icon: const Icon(Icons.home),
              ),
              // Notification icon
              IconButton(
                onPressed: () {
                  // Action for notification icon
                },
                icon: const Icon(Icons.notifications),
              ),
            ],
          ),
        ],
      ),
      body: _buildStoreList(),
      floatingActionButton: FloatingActionButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreAddScreen(onDataChanged: _updateData),
            ),
          );
        },
        backgroundColor: AppColor.colorToolbar,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStoreList() {
    if (_storeList.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _storeList.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _storeList.length) {
          final store = _storeList[index];
          return _buildStoreCard(store);
        } else {
          _fetchData();
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _buildStoreCard(StoreEntity store) {
    return Card(
      color: Colors.white, // Set the background color of the Card to white
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0), // Margin for the card (start margin)
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 0.0, top: 15.0, bottom: 0.0), // Set left padding to 5dp
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Name and Edit Button with Icon
            Row(
              children: [
                _buildCircularIcon(
                  'assets/images/store_icon.webp', // Image
                  35, // Circle size
                  5, // Icon size
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    store.store_name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Updated Edit Icon with Grey Circle
                Padding(
                  padding: const EdgeInsets.only(right: 12.0), // Add margin to the end
                  child: Container(
                    width: 40.0, // Circle size
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.colorStoreEditIcon, // Light grey color for the circle
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/images/store_edit_icon.webp', // Path to your asset image
                        width: 24.0,  // Set the width of the image
                        height: 24.0, // Set the height of the image
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreAddScreen(onDataChanged: _updateData),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8.0),
            // Store Address
            Row(
              children: [
                _buildCircularIcon('assets/images/ic_location.png', 35, 15), // Smaller icon size
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final address = store.store_address ?? "No Address Provided";
                      final url = 'https://www.google.com/maps/search/?q=$address';

                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        // Handle the case where the URL can't be launched
                        throw 'Could not launch $url';
                      }
                    },
                    child: Text(
                      store.store_address ?? "No Address Provided",
                      style: const TextStyle(color: AppColor.colorStoreAddTxt),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            // Contact Name and Store Type Section with Equal Division
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // This will space out the contact name and store type
              children: [
                // Left side: Contact Name
                Expanded(
                  child: _buildContactInfo(
                    'assets/images/store_phone_no_icon.webp',
                    "Contact Number",
                    store.store_contact_number ?? "N/A",
                    onTap: () {
                      if (store.store_contact_number != null && store.store_contact_number!.isNotEmpty) {
                        _launchPhoneDialer(store.store_contact_number!); // Launch the dialer with the contact number
                      }
                    },
                  ),
                ),
                // Right side: Store Type
                Expanded(
                  child: _buildContactInfo(
                      'assets/images/ic_store_color.jpg',
                      "Store Type",
                      store.store_name ?? "N/A"
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            // Contact Number and Email ID Section with Equal Spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align items to start of the row
              children: [
                // Left side: Contact Number
                Expanded(
                  child: Row(
                    children: [
                      _buildCircularIcon('assets/images/whatsapp_icon.webp', 35, 10), // Phone icon
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "WhatsApp",
                            style: TextStyle(fontSize: 14.0, color: AppColor.colorStoreTxt),
                          ),
                          Text(
                            store.store_whatsapp_number ?? "N/A",
                            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Right side: Email ID
                Expanded(
                  child: Row(
                    children: [
                      _buildCircularIcon('assets/images/email_id_icon.webp', 35, 10), // Email icon
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email Id",
                            style: TextStyle(fontSize: 14.0, color: AppColor.colorStoreTxt),
                          ),
                          Text(
                            store.store_email ?? "N/A", // Assuming store email is available in your data
                            style: const TextStyle(fontSize: 14.0/*, fontWeight: FontWeight.bold*/),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out the buttons equally
              children: [
                // Add left margin for the first button
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: _buildActionButton('assets/images/operation_icon.webp', "Operation"),
                ),
                // Add margin between buttons
                _buildActionButton('assets/images/order_icon.webp', "Order"),
                _buildActionButton('assets/images/survey_icon.webp', "Survey"),
                // Add right margin for the last button
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: _buildActionButton('assets/images/activity_icon.webp', "Activity"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Method to Build Contact Info Section (Contact Name and Store Type)
  Widget _buildContactInfo(String iconPath, String label, String value, {VoidCallback? onTap}) {
    return Row(
      children: [
        _buildCircularIcon(iconPath, 35, 10), // Icon for Contact Name and Store Type
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14.0, color: AppColor.colorStoreTxt),
            ),
            GestureDetector(
              onTap: onTap, // Calls the onTap function when clicked
              child: Text(
                value,
                style: const TextStyle(fontSize: 14.0,color: AppColor.colorStoreTxtVlu /*fontWeight: FontWeight.bold*/),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        // Action for the button, if needed
      },
      child: Container(
        width: 70.0, // Define the width of the button
        height: 55.0, // Define the height of the button
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColor.colorStoreCircleBack!, Colors.white],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0), // Slight curve at the top left corner
            topRight: Radius.circular(8.0), // Slight curve at the top right corner
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 5.0,
              offset: Offset(0, 3), // Slight shadow at the bottom
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Apply blue color filter to the asset image
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColor.colorStoreIcon, // Blue color for the image
                BlendMode.srcIn, // Apply the color filter
              ),
              child: Image.asset(
                imagePath,
                width: 22.0, // Width of the image
                height: 22.0, // Height of the image
                fit: BoxFit.contain, // Ensures the image fits well
              ),
            ),
            const SizedBox(height: 2.0), // Space between image and text
            Text(
              label,
              style: const TextStyle(
                fontSize: 13.0, // Smaller text for the more compact card
                color: AppColor.colorStoreIcon, // Set the text color (optional, as you may want this to remain unchanged)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIcon(String imagePath, double circleSize, double iconSize) {
    return Container(
      width: circleSize,  // Circle size
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.colorStoreCircleBack,  // Light grey color for the circle
      ),
      child: Padding(
        padding: EdgeInsets.all((circleSize - iconSize) / 3.5), // Add padding to shrink the image inside the circle
        child: Image.asset(
          imagePath,
          width: iconSize,    // Smaller image size
          height: iconSize,   // Smaller image size
          fit: BoxFit.contain, // Ensures the image fits inside the circle without distortion
        ),
      ),
    );
  }

  void _launchPhoneDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}
