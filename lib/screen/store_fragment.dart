import 'package:fl/database/store_entity.dart';
import 'package:fl/screen/store_add_fragment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../utils/app_color.dart';

class StoreFragment extends StatefulWidget {
  @override
  _StoreFragmentState createState() => _StoreFragmentState();
}

class _StoreFragmentState extends State<StoreFragment> {

  final viewModel = ItemViewModel(appDatabase.storeDao);

  void _updateData() {
    setState(() {
      viewModel.loadItems(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ChangeNotifierProvider<ItemViewModel>(
        create: (_) {
          //final viewModel = ItemViewModel(appDatabase.storeDao);
          viewModel.loadItems(); // Call loadItems here
          return viewModel;
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Store",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true, // Enable filling the background color
                  fillColor: AppColor.colorWhite,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: AppColor.colorGreenMoss), // Example: blue border when focused
                    )
                ),
                onChanged: (query) {
                  viewModel.loadItems(refresh: true, query: query);
                },
              ),
            ),
            Expanded(
              child: Consumer<ItemViewModel>(
                builder: (context, viewModel, child) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await viewModel.loadItems(refresh: true);
                    },
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!viewModel.hasMoreData ||
                            viewModel.loadingState == LoadingState.loading) {
                          return false;
                        }
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          viewModel.loadItems();
                        }
                        return true;
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 150.0),
                        itemCount: viewModel.items.length +
                            (viewModel.hasMoreData ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == viewModel.items.length) {
                            if (viewModel.loadingState == LoadingState.error) {
                              return Center(
                                child: ElevatedButton(
                                  onPressed: () => viewModel.loadItems(),
                                  child: Text('Retry'),
                                ),
                              );
                            }else if (viewModel.loadingState == LoadingState.loading) {
                              return Center(child: CircularProgressIndicator());  // Show loader while loading
                            } else if (viewModel.loadingState == LoadingState.idle && viewModel.items.isEmpty) {
                              // When idle and no items, show a message
                              //return Center(child: Text("No items available"));
                              return SizedBox.shrink();
                            } else if (viewModel.loadingState == LoadingState.idle) {
                              // Idle state but items are loaded, just return an empty container or nothing
                              return SizedBox.shrink();  // No loader, no retry button
                            }
                            //return Center(child: CircularProgressIndicator());
                          }

                          final item = viewModel.items[index];
                          return _buildStoreCard(item);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
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
                    StoreAddFragment(onDataChanged: _updateData)),
          );
        },
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
          "Store",
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

  Widget _buildStoreCard(StoreEntity store) {
    return Card(
      color: AppColor.colorWhite,
      // Set the background color of the Card to white
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      // Margin for the card (start margin)
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        // Set left padding to 5dp
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildCircularIcon('assets/images/ic_store_color.jpg', 40, 10,
                    AppColor.colorSmokeWhite),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    store.store_name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StoreAddFragment(onDataChanged: _updateData,editStoreObj: store,)),
                    );
                  },
                  child: _buildCircularIcon('assets/images/ic_edit.png', 35, 10,
                      AppColor.colorSmokeWhite),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                _buildCircularIcon('assets/images/ic_location.png', 35, 15,
                    AppColor.colorSmokeWhite), // Smaller icon size
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {},
                    child: Text(
                      store.store_address ?? "No Address Provided",
                      style: TextStyle(color: AppColor.colorCharcoal),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Container(
              height: 1, // Adjust the thickness as needed
              width: double.infinity, // Adjust the width as needed
              color: AppColor.colorGreyLight,
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // This will space out the contact name and store type
              children: [
                // Left side: Contact Name
                Expanded(
                  child: _buildContactInfo(
                    'assets/images/ic_phone.png',
                    "Contact Number",
                    store.store_contact_number ?? "",
                    onTap: () {
                      if (store.store_contact_number != null && store.store_contact_number!.isNotEmpty) {
                        _launchPhoneDialer(store.store_contact_number!); // Launch the dialer with the contact number
                      }
                    },
                  ),
                ),
                // Right side: Store Type (Now wrapped with FutureBuilder)
                Expanded(
                  child: FutureBuilder<String?>(
                    future: appDatabase.storeTypeDao.getStoreTypeById(store.store_type.toString()),
                    // Fetch store type by store_id
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                            "Loading..."); // Display while fetching data
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}'); // Handle error
                      } else if (snapshot.hasData && snapshot.data != null) {
                        String storeTypeName = snapshot.data!;
                        return _buildContactInfo(
                          'assets/images/ic_store_color.jpg',
                          "Store Type",
                          storeTypeName, // Display the store type name
                        );
                      } else {
                        return _buildContactInfo(
                          'assets/images/ic_store_color.jpg',
                          "Store Type",
                          "", // Default if no data found
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // This will space out the contact name and store type
              children: [
                // Left side: Contact Name
                Expanded(
                  child: _buildContactInfo(
                    'assets/images/ic_whatsapp.png',
                    "Whatsapp",
                    store.store_whatsapp_number ?? "",
                    onTap: () {},
                  ),
                ),
                // Right side: Store Type (Now wrapped with FutureBuilder)
                Expanded(
                  child: _buildContactInfo(
                    'assets/images/ic_mail.png',
                    "Email",
                    store.store_email ?? "",
                    onTap: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              height: 75.0, // Adjust based on the height of your buttons
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    _buildActionButton('assets/images/ic_operation.webp', "Operation"),
                    SizedBox(width: 10),
                    _buildActionButton('assets/images/ic_order.webp', "Order"),
                    SizedBox(width: 10),
                    _buildActionButton('assets/images/ic_operation.webp', "Survey"),
                    SizedBox(width: 10),
                    _buildActionButton('assets/images/ic_order.webp', "Activity"),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIcon(
      String imagePath, double circleSize, double iconSize, Color color) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: AppColor.colorGrey, // Shadow color
            spreadRadius: 1, // How far the shadow spreads
            blurRadius: 1, // The blurriness of the shadow
            offset: Offset(0, 1), // The position of the shadow (x, y)
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all((circleSize - iconSize) / 3.5),
        child: Image.asset(
          imagePath,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildActionButton(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        // Action for the button, if needed
      },
      child: IntrinsicWidth(
        child: Container(
          constraints: BoxConstraints(
            minWidth: 80.0, // Set the minimum width
            maxWidth: double.infinity, // Allow for dynamic width
          ),
          height: 55.0, // Define the height of the button
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColor.colorSmokeWhite, AppColor.colorSmokeWhite.withOpacity(0.5)],
            ),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: AppColor.colorGrey, // Shadow color
                spreadRadius: 1, // How far the shadow spreads
                blurRadius: 1, // The blurriness of the shadow
                offset: Offset(0, 1),// Slight shadow at the bottom
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  AppColor.colorCharcoal, // Blue color for the image
                  BlendMode.srcIn, // Apply the color filter
                ),
                child: Image.asset(
                  imagePath,
                  width: 22.0, // Width of the image
                  height: 22.0, // Height of the image
                  fit: BoxFit.fill, // Ensures the image fits well
                ),
              ),
              const SizedBox(height: 2.0), // Space between image and text
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14.0, // Smaller text for the more compact card
                  color: AppColor.colorCharcoal, // Set the text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(String iconPath, String title, String content, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          // Icon
          _buildCircularIcon(iconPath, 35, 10, AppColor.colorSmokeWhite),
          const SizedBox(width: 8),
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  content,
                  style: TextStyle(fontSize: 14,color: AppColor.colorCharcoal),
                  overflow: TextOverflow.ellipsis, // Ensures text truncates when too long
                  maxLines: 2, // Limits to one line
                  softWrap: false, // Prevents wrapping
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchPhoneDialer(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

enum LoadingState { idle, loading, error }
class ItemViewModel extends ChangeNotifier {
  final StoreDao _itemDao;
  List<StoreEntity> _items = [];
  List<StoreEntity> _filteredItems = [];
  bool _hasMoreData = true;
  LoadingState _loadingState = LoadingState.idle;
  int _page = 0;
  final int _pageSize = 20;

  ItemViewModel(this._itemDao);

  List<StoreEntity> get items => _filteredItems.isEmpty ? _items : _filteredItems;
  bool get hasMoreData => _hasMoreData;
  LoadingState get loadingState => _loadingState;

  Future<void> loadItems({bool refresh = false, String query = ""}) async {
    if (_loadingState == LoadingState.loading) return;

    if (refresh) {
      _items.clear();
      _page = 0;
      _hasMoreData = true;
      _filteredItems.clear();
    }

    _loadingState = LoadingState.loading;
    notifyListeners();

    try {
      final offset = _page * _pageSize;
      final newItems = await _itemDao.fetchPaginatedItemsSearch("%$query%",_pageSize, offset);

      if (newItems.isEmpty) {
        _hasMoreData = false;
      } else {
        _items.addAll(newItems);
        _page++;
      }

      // Apply search filter if query is provided
      if (query.isNotEmpty) {
        _filteredItems = _items
            .where((item) =>
            item.store_name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        _filteredItems.clear();
      }

    } catch (e) {
      _loadingState = LoadingState.error;
    } finally {
      _loadingState = LoadingState.idle;
      notifyListeners();
    }
  }

  void clearSearch() {
    _filteredItems.clear();
    notifyListeners();
  }
}
