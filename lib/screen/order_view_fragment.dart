import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modern_retail/database/store_entity.dart';
import 'package:provider/provider.dart';

import '../database/order_product_entity.dart';
import '../database/order_save_entity.dart';
import '../main.dart';
import '../utils/app_color.dart';

class OrderViewFragment extends StatefulWidget {
  final OrderSaveEntity orderObj;
  const OrderViewFragment({super.key,required this.orderObj});

  @override
  _OrderViewFragment createState() => _OrderViewFragment();
}

class _OrderViewFragment extends State<OrderViewFragment> {

  final viewModel = ItemViewModel(appDatabase.orderProductDao);

  StoreEntity? storeObj = StoreEntity();

  String _totalQty = "";
  String _totalAmount = "";

  final List<TextEditingController> _qtyControllers = [];
  final List<TextEditingController> _rateControllers = [];

  @override
  void initState() {
    super.initState();
    setData();
  }

  Future<void> setData() async {
    storeObj = await appDatabase.storeDao.getByID(widget.orderObj.store_id);
    if(storeObj!=null){
      final orderDtlsL = await appDatabase.orderSaveDtlsDao.getDtlsById(widget.orderObj.order_id);
      if(orderDtlsL.isNotEmpty){
        var qty = 0;
        var amt = 0.0;
        for (var value in orderDtlsL) {
          _qtyControllers.add(TextEditingController(text: value.qty.toString()));
          _rateControllers.add(TextEditingController(text: value.rate.toString()));
          qty = qty + double.parse(value.qty).toInt();
          amt = amt + (double.parse(value.qty).toInt() * double.parse(value.rate));
        }
        setState(() {
          _totalQty = qty.toString();
          _totalAmount = amt.toString();
        });
        viewModel.loadItems();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false; // Prevent default behavior
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: ChangeNotifierProvider<ItemViewModel>(
          create: (_) => viewModel,
          child: Column(
            children: [
              Container(
                color: Colors.transparent, // Example bottom widget
                height: 50,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 0.0, top: 0.0, bottom: 0.0),
                        child: Container(
                          color: AppColor.colorTransparent,
                          child: Text(storeObj == null ? "Store Name" : storeObj!.store_name ,style: TextStyle(color: AppColor.colorBlack,fontSize: 20,fontWeight: FontWeight.bold), ),
                        ),
                      ),
                    ),
                  ],
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

                            var item = viewModel.items[index];
                            return _buildProductCard(item, index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.white, // Example bottom widget
                //height: 100,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: AppColor.colorButton,
                              child: Center(
                                child: Text(_totalQty == "" ? "Total Qty(s)" : "Total Qty(s)\n" + _totalQty, style: TextStyle(color: AppColor.colorWhite), textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Expanded(
                            child: Container(
                              color: AppColor.colorButton,
                              child: Center(
                                child: Text(_totalAmount == "" ? "Total Value" : "Total Value\n" + _totalAmount, style: TextStyle(color: AppColor.colorWhite), textAlign: TextAlign.center),
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
        ),
        backgroundColor: AppColor.colorSmokeWhite,
      ),
    );
  }

  Widget _buildProductCard(OrderProductEntity product, int index) {
    return Card(
      color: product.isAdded ? AppColor.colorWhite : AppColor.colorWhite,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0), // Add 5 pixels of left margin
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes space between text and icon
                children: [
                  Expanded(
                    child: Text(
                      product.product_name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColor.colorButton,
                      ),
                      overflow: TextOverflow.clip, // Ensures the text wraps properly
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.only(left: 1.0, right: 1.0, top: 0.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildEntryDetails(product, _qtyControllers[index], _rateControllers[index])],
                )),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryDetails(OrderProductEntity product, TextEditingController qtyController, TextEditingController rateController) {
    return Flexible(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    'Quantity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.colorGrey,
                    ),
                  ),
                ),
                Container(
                  height: 30, // Fixed height for text box
                  alignment: Alignment.center,
                  child: TextFormField(
                    enabled: false,
                      style: TextStyle(
                        color: Colors.black, // Set the text color
                        fontSize: 16,       // Optional: Adjust font size
                      ),
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '',
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.center,
                      onChanged: (text) {

                      }),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    'Rate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.colorGrey,
                    ),
                  ),
                ),
                Container(
                  height: 30, // Fixed height for text box
                  alignment: Alignment.center,
                  child: TextFormField(
                      enabled: false,
                      style: TextStyle(
                        color: Colors.black, // Set the text color
                        fontSize: 16,       // Optional: Adjust font size
                      ),
                      controller: rateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '',
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.center,
                      onChanged: (text) {

                      }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          "View Order",
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


enum LoadingState { idle, loading, error }

class ItemViewModel extends ChangeNotifier {
  final OrderProductDao _itemDao;
  List<OrderProductEntity> _items = [];
  List<OrderProductEntity> _filteredItems = [];
  bool _hasMoreData = true;
  LoadingState _loadingState = LoadingState.idle;
  int _page = 0;
  final int _pageSize = 20;

  ItemViewModel(this._itemDao);

  List<OrderProductEntity> get items => _filteredItems.isEmpty ? _items : _filteredItems;

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
      final newItems = await _itemDao.fetchPaginatedItemsAdded(_pageSize, offset);

      if (newItems.isEmpty) {
        _hasMoreData = false;
      } else {
        _items.addAll(newItems);
        _page++;
      }

      // Apply search filter if query is provided
      if (query.isNotEmpty) {
        _filteredItems = _items.where((item) => item.product_name.toLowerCase().contains(query.toLowerCase())).toList();
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