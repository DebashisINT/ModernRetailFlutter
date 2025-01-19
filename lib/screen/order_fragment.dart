import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modern_retail/api/response/order_delete_request.dart';
import 'package:modern_retail/database/order_save_entity.dart';
import 'package:modern_retail/screen/order_edit_cart_fragment.dart';
import 'package:modern_retail/screen/order_view_fragment.dart';
import 'package:modern_retail/utils/app_message.dart';
import 'package:modern_retail/utils/app_style.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_service.dart';
import '../database/store_entity.dart';
import '../main.dart';
import '../utils/app_color.dart';
import '../utils/app_utils.dart';
import '../utils/loader_utils.dart';
import '../utils/snackbar_utils.dart';
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
  final apiService = ApiService(Dio());

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
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: ChangeNotifierProvider<ItemViewModel>(
          create: (_) => viewModel,
          child: Column(
            children: [
              _buildHeader(),
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
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
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
                            }

                            final item = viewModel.items[index];
                            return Container(margin: EdgeInsets.only(top: 20.0),
                              child: _buildCard(item),
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
    );
  }

  Widget _buildCard(OrderSaveEntity item) {
    return Card(
      color: AppColor.colorWhite,
      margin: AppStyle().cardMargin.copyWith(left: 10,right: 10,top: 10,bottom: 10),
      elevation: AppStyle().cardEvevation,
      shape: AppStyle().cardShape,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green Header Box with Order ID and Date
            Container(
              decoration: BoxDecoration(
                color: AppColor.colorGreenSteel,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Order Id : ",
                          style: AppStyle().textStyle.copyWith(color: AppColor.colorWhite),
                        ),
                        TextSpan(
                          text: item.order_id,
                          style: AppStyle().textStyle.copyWith(color: AppColor.colorCharcoal, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    AppUtils.getDateFromDateTime(item.order_date_time),
                    style: AppStyle().textStyle.copyWith(color: AppColor.colorWhite),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Amount",style: AppStyle().textStyle,),
                      Text(
                        "₹${item.order_amount ?.toStringAsFixed(2) ?? '0.00'}",
                        style: AppStyle().textStyle.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(
                    color: AppColor.colorGreyLight,
                    thickness: 1, // Slim thickness for the grey line
                    height: 20,   // Reduced height for spacing around the line
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status",
                        style: AppStyle().textStyle,
                      ),
                      Text(
                        item.order_status,
                        style: AppStyle().textStyle.copyWith(color: item.order_status == "Delivered" ? Colors.green : AppColor.colorYellow,
                            fontWeight: FontWeight.bold),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OrderEditCartFragment(orderObj: item)),
                          ).then((value) {
                            _updateData();
                          });
                        },
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Text("Edit", style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColor.colorBlue, // Set the background color to blue
                          side: BorderSide(color: AppColor.colorBlue),
                          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0), // Reduced top and bottom padding
                          minimumSize: Size(0, 28), // Minimum height for the button
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink button tap area
                        ),
                      ),
                      SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OrderViewFragment(orderObj: item)),
                          );
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
                            AppUtils().showCustomDialogOkCancel(context, "Delete Order!", "Hi ${pref.getString('user_name') ?? ""}, "
                                "Are you sure you want to delete order?", () {
                              _handleDeleteOrder(item.order_id);
                            });
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
      ),
    );
  }

  Future<void> _handleDeleteOrder(String order_id) async {
    LoaderUtils().showLoader(context);

    List<OrderDelete> orderDeleteList = [];
    orderDeleteList.add(OrderDelete(order_id: order_id));

    bool isOnline = await AppUtils().checkConnectivity();
    if (isOnline) {
      final request = OrderDeleteRequest(user_id: pref.getString('user_id')!,order_delete_list: orderDeleteList);
      final response = await apiService.deleteOrder(request);
      if (response.status == "200") {
        await appDatabase.orderSaveDao.deleteById(order_id);
        await appDatabase.orderSaveDtlsDao.deleteById(order_id);
        LoaderUtils().dismissLoader(context);
        _updateData();
      } else {
        LoaderUtils().dismissLoader(context);
        SnackBarUtils().showSnackBar(context, AppMessage().wrong);
      }
    }
    else {
      LoaderUtils().dismissLoader(context);
      SnackBarUtils().showSnackBar(context,AppMessage().no_internet,imagePath: "assets/images/ic_no_internet.png");
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Align everything at the top
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              borderRadius: BorderRadius.circular(12), // Rounded corners
              boxShadow: [
                AppStyle().boxShadow,
              ],
              image: DecorationImage(
                image: AssetImage("assets/images/store_dummy.jpg"), // Replace with your image path
                fit: BoxFit.fill, // Adjust image scaling
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.storeObj.store_name, style: AppStyle().textHeaderStyle,),
                SizedBox(height: 5), // Small space below store name before address and phone number
                GestureDetector(
                  onTap: () {
                    if (widget.storeObj.store_lat != null && widget.storeObj.store_long != null) {
                      openMapWithLatLng(widget.storeObj.store_lat, widget.storeObj.store_long);
                    } else {
                      SnackBarUtils().showSnackBar(context,"Location not available");
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/ic_location.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(widget.storeObj.store_address == null ? "" : widget.storeObj.store_address!,
                            style: AppStyle().textStyle,
                            maxLines: 2, // Ensure the address stays in one line
                            overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5), // Small space between address and phone number
                GestureDetector(
                  onTap: () {
                    _launchPhoneDialer(widget.storeObj.store_contact_number);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/ic_phone.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(widget.storeObj.store_contact_number,
                            style: AppStyle().textStyle,
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          "Order Details",
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


