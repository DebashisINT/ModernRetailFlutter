import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modern_retail/database/order_save_entity.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/store_entity.dart';
import '../main.dart';
import '../utils/app_color.dart';
import '../utils/app_utils.dart';
import 'order_add_fragment.dart';

class OrderFragment extends StatefulWidget {
  final VoidCallback? onDataChanged;
  final StoreEntity storeObj;
  const OrderFragment({super.key, this.onDataChanged,required this.storeObj});

  @override
  _OrderFragment createState() => _OrderFragment();
}

class _OrderFragment extends State<OrderFragment> {

  final viewModel = ItemViewModel(appDatabase.orderSaveDao);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<OrderSaveEntity>  data = await appDatabase.orderSaveDao.getAll();
    if(data.isNotEmpty){
      viewModel.loadItems();
    }
  }

  void _updateData() {
    setState(() {
      viewModel.loadItems(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ItemViewModel>(
      create: (_) => viewModel,//ItemViewModel(appDatabase.orderSaveDao),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Consumer<ItemViewModel>(
                  builder: (context, viewModel, child) {
                    // Load items initially when the widget is built
                   /* if (viewModel.items.isEmpty && viewModel.loadingState == LoadingState.idle) {
                      viewModel.loadItems();
                    }*/
                    return RefreshIndicator(
                      onRefresh: () async {
                        await viewModel.loadItems(refresh: true);
                      },
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!viewModel.hasMoreData || viewModel.loadingState == LoadingState.loading) {
                            return false;
                          }
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                            viewModel.loadItems();
                          }
                          return true;
                        },
                        child: ListView.builder(
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
                            return Container(
                              margin: const EdgeInsets.only(top: 20.0),  // Top margin of 20 dp
                              child: _buildStoreCard(item),
                            );
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
              MaterialPageRoute(builder: (context) => OrderAddFragment(storeObj: widget.storeObj)),
            ).then((value) {
              _updateData();
            });
          },
          backgroundColor: AppColor.colorToolbar,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        backgroundColor: AppColor.colorSmokeWhite,
      ),
    );
  }

  Widget _buildStoreCard(OrderSaveEntity item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Green Header Box with Order ID and Date
          Container(
            decoration: BoxDecoration(
              color: AppColor.colorGreenSteel,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
            ),
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Order Id: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White color for "Order Id:"
                        ),
                      ),
                      TextSpan(
                        text: "${item.order_id}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.colorYellow, // Your desired color for order ID value
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  AppUtils.getDateFromDateTime(item.order_date_time),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Content below the header
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reduced space between Amount and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Amount (${item.order_amount} items)"),
                    Text(
                      "₹${double.tryParse(item.order_amount ?? '0')?.toStringAsFixed(2) ?? '0.00'}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 2), // Reduced space between Amount and Status

                // Grey slim line
                Divider(
                  color: Colors.grey,
                  thickness: 1, // Slim thickness for the grey line
                  height: 16,   // Reduced height for spacing around the line
                ),
                SizedBox(height: 2), // Reduced space below the line

                // Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      item.order_status,
                      style: TextStyle(
                        color: item.order_status == "Delivered" ? Colors.green : AppColor.colorYellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6), // Reduced space after Status

                // View and Delete Buttons in the right side
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Align both buttons to the right
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Add action for View button
                        print("View details for order ${item.order_id}");
                      },
                      icon: Icon(Icons.info, color: Colors.white),
                      label: Text("View", style: TextStyle(color: Colors.white)),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColor.colorBlue, // Set the background color to blue
                        side: BorderSide(color: AppColor.colorBlue),
                        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0), // Reduced top and bottom padding
                        minimumSize: Size(0, 28), // Minimum height for the button
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink button tap area
                      ),
                    ),
                    SizedBox(width: 8), // Add reduced spacing between View and Delete buttons

                    // Smaller delete circle size
                    CircleAvatar(
                      radius: 18, // Smaller size for the delete circle
                      backgroundColor: AppColor.colorRed, // Circular red background for delete button
                      child: IconButton(
                        onPressed: () {
                          // Add action for Delete button
                          print("Delete order ${item.order_id}");
                        },
                        icon: Icon(Icons.delete, color: Colors.white), // White delete icon
                        iconSize: 20, // Smaller icon size
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row for Store Image and Store Name
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align everything at the top
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
            SizedBox(width: 10),
            // Store Name aligned at the top right side of the image
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.storeObj.store_name}",
                    style: TextStyle(
                      color: AppColor.colorBlack,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4), // Small space below store name before address and phone number
                  // Address Row with icon
                  GestureDetector(
                    onTap: () {
                      // Launch the address in Google Maps
                      openMapWithLatLng(widget.storeObj.store_lat,widget.storeObj.store_long);
                    },
                    child: Row(
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
                              image: AssetImage("assets/images/ic_location.png"), // Icon for location
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
                              style: TextStyle(
                                color: AppColor.colorBlack,
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1, // Ensure the address stays in one line
                              overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4), // Small space between address and phone number
                  // Phone Number Row with icon
                  GestureDetector(
                    onTap: () {
                      // Action when phone number is clicked (e.g., initiate a call)
                      _launchPhoneDialer(widget.storeObj.store_contact_number);
                    },
                    child: Row(
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
                              image: AssetImage("assets/images/ic_phone.png"), // Icon for phone
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
                              style: TextStyle(
                                color: AppColor.colorBlack,
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  void _launchPhoneDialer(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
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
}

enum LoadingState { idle, loading, error }
class ItemViewModel extends ChangeNotifier {
  final OrderSaveDao _itemDao;
  List<OrderSaveEntity> _items = [];
  List<OrderSaveEntity> _filteredItems = [];
  bool _hasMoreData = true;
  LoadingState _loadingState = LoadingState.idle;
  int _page = 0;
  final int _pageSize = 20;

  ItemViewModel(this._itemDao);

  List<OrderSaveEntity> get items => _filteredItems.isEmpty ? _items : _filteredItems;
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
      final newItems = await _itemDao.fetchPaginatedItems(_pageSize, offset);

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
            item.order_id.toLowerCase().contains(query.toLowerCase()))
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


