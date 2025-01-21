import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modern_retail/screen/store_add_fragment.dart';
import 'package:modern_retail/utils/app_style.dart';
import 'package:modern_retail/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/store_entity.dart';
import '../main.dart';
import '../utils/app_color.dart';
import '../utils/snackbar_utils.dart';
import 'order_fragment.dart';

class StoreFragment extends StatefulWidget {
  @override
  _StoreFragmentState createState() => _StoreFragmentState();
}

class _StoreFragmentState extends State<StoreFragment> {
  final viewModel = ItemViewModel(appDatabase.storeDao);
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    viewModel.loadItems();
  }

  void _updateData() {
    setState(() {
      viewModel.loadItems(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(0.0),
        child: ChangeNotifierProvider<ItemViewModel>(
          create: (_) => viewModel,
          child: Column(
            children: [
              Expanded(
                child: Consumer<ItemViewModel>(
                  builder: (context, viewModel, child) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await viewModel.loadItems(refresh: true);
                      },
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!viewModel.hasMoreData || viewModel.loadingState == LoadingState.loading) {
                            return false;
                          }
                          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                            viewModel.loadItems();
                          }
                          return true;
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 150.0),
                          itemCount: viewModel.items.length + (viewModel.hasMoreData ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == viewModel.items.length) {
                              if (viewModel.loadingState == LoadingState.error) {
                                return Center(
                                  child: ElevatedButton(
                                    onPressed: () => viewModel.loadItems(),
                                    child: Text('Retry'),
                                  ),
                                );
                              } else if (viewModel.loadingState == LoadingState.loading) {
                                return Center(child: CircularProgressIndicator()); // Show loader while loading
                              } else if (viewModel.loadingState == LoadingState.idle && viewModel.items.isEmpty) {
                                // When idle and no items, show a message
                                //return Center(child: Text("No items available"));
                                return SizedBox.shrink();
                              } else if (viewModel.loadingState == LoadingState.idle) {
                                // Idle state but items are loaded, just return an empty container or nothing
                                return SizedBox.shrink(); // No loader, no retry button
                              }
                              //return Center(child: CircularProgressIndicator());
                            }
                            final item = viewModel.items[index];
                            return _buildCard(item);
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
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StoreAddFragment(onDataChanged: _updateData)),
          );
        },
        backgroundColor: AppColor.colorToolbar,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: AppColor.colorSmokeWhite,
    );
  }

  Widget _buildCard(StoreEntity store) {
    return Card(
      color: AppColor.colorWhite,
      margin: EdgeInsets.only(
        left: 15,
        right: 15,
        top: 5,
        bottom: 5,
      ),
      elevation: AppStyle().cardEvevation,
      shape: AppStyle().cardShape,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                _buildCircularIcon('assets/images/ic_store_color.jpg', 35, 10, AppColor.colorSmokeWhite),
                SizedBox(width: 10),
                Expanded(
                    child: Text(
                  store.store_name,
                  style: AppStyle().textHeaderStyle,
                )),
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoreAddFragment(
                                onDataChanged: _updateData,
                                editStoreObj: store,
                              )),
                    );
                  },
                  child: _buildCircularIcon('assets/images/ic_edit.png', 35, 10, AppColor.colorSmokeWhite),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                _buildCircularIcon('assets/images/ic_location.png', 35, 10, AppColor.colorSmokeWhite), // Smaller icon size
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (store.store_lat != null && store.store_long != null) {
                        openMapWithLatLng(store.store_lat, store.store_long);
                      } else {
                        SnackBarUtils().showSnackBar(context, "Location not available");
                      }
                    },
                    child: Text(
                      store.store_address ?? "No Address Provided",
                      style: AppStyle().textStyle,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: AppColor.colorGreyLight,
              thickness: 1, // Slim thickness for the grey line
              height: 20, // Reduced height for spacing around the line
            ),
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
                    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading..."); // Display while fetching data
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}'); // Handle error
                      } else if (snapshot.hasData && snapshot.data != null) {
                        String storeTypeName = snapshot.data!;
                        return _buildContactInfo('assets/images/ic_store_color.jpg', "Store Type", storeTypeName);
                      } else {
                        return _buildContactInfo('assets/images/ic_store_color.jpg', "Store Type", "");
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
                    onTap: () {
                      _openWhatsApp(store.store_whatsapp_number!);
                    },
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
            SizedBox(height: 0.0),
            Container(
              height: 75.0, // Adjust based on the height of your buttons
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 5),
                    _buildActionButton('assets/images/ic_operation.webp', "Operation"),
                    SizedBox(width: 10),
                    _buildActionButton('assets/images/ic_order.webp', "Order", onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderFragment(storeObj: store)),
                      );
                    }),
                    SizedBox(width: 10),
                    _buildActionButton('assets/images/ic_operation.webp', "Survey"),
                    SizedBox(width: 10),
                    _buildActionButton('assets/images/ic_order.webp', "Activity"),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIcon(String imagePath, double circleSize, double iconSize, Color color) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          AppStyle().boxShadow,
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

  Widget _buildActionButton(String imagePath, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
          constraints: BoxConstraints(
            minWidth: 80.0, // Set the minimum width
            maxWidth: double.infinity, // Allow for dynamic width
          ),
          height: 45.0, // Define the height of the button
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColor.color1, AppColor.color1.withOpacity(0.5), AppColor.colorSmokeWhite],
            ),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              AppStyle().boxShadowLargeView,
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
                  width: 18.0, // Width of the image
                  height: 18.0, // Height of the image
                  fit: BoxFit.fill, // Ensures the image fits well
                ),
              ),
              const SizedBox(height: 2.0), // Space between image and text
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppStyle().textStyle.copyWith(fontSize: 12),
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
          const SizedBox(width: 10),
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyle().textStyle.copyWith(color: AppColor.colorBlue),
                ),
                Text(
                  content,
                  style: AppStyle().textStyle.copyWith(color: AppColor.colorGrey),
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

  void _openWhatsApp(String phoneNumber) async {
    // Replace with the phone number you want to use
    final whatsappUrl = "https://wa.me/$phoneNumber";
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $whatsappUrl";
    }
  }

  void openMapWithLatLng(String? latitudeStr, String? longitudeStr) async {
    double? latitude = double.tryParse(latitudeStr ?? '');
    double? longitude = double.tryParse(longitudeStr ?? '');

    if (latitude == null || longitude == null) {
      throw 'Invalid latitude or longitude: $latitudeStr, $longitudeStr';
    }
    String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    try {
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not open Google Maps.';
      }
    } catch (e) {
      debugPrint('Error opening map: $e');
    }
  }

  /*AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          "Store(s)",
          style: AppStyle().toolbarTextStyle,
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
  }*/

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.colorToolbar,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context); // Navigate back
        },
      ),
      title: _isSearching ? SizedBox(
              height: 35, // Adjust height to fit nicely within the app bar
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Store",
                  hintStyle: AppStyle().hintStyle,
                  prefixIcon: Icon(Icons.search, color: AppColor.colorGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // No visible border
                  ),
                  filled: true,
                  fillColor: AppColor.colorWhite,
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                ),
                onChanged: (query) {
                  // Trigger the search logic
                  viewModel.loadItems(refresh: true, query: query);
                },
              ),
            )
          : Center(child: Text("Store(s)", style: AppStyle().toolbarTextStyle,),),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white,),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching; // Toggle the search box visibility
              viewModel.loadItems(refresh: true);
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ],
    );
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
      final newItems = await _itemDao.fetchPaginatedItemsSearch("%$query%", _pageSize, offset);

      if (newItems.isEmpty) {
        _hasMoreData = false;
      } else {
        _items.addAll(newItems);
        _page++;
      }

      // Apply search filter if query is provided
      if (query.isNotEmpty) {
        _filteredItems = _items.where((item) => item.store_name.toLowerCase().contains(query.toLowerCase())).toList();
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
