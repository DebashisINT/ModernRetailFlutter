import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_retail/database/order_product_entity.dart';
import 'package:modern_retail/database/store_entity.dart';
import 'package:modern_retail/screen/order_cart_fragment.dart';
import 'package:modern_retail/utils/app_style.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utils/app_color.dart';
import '../utils/input_formatter.dart';
import '../utils/snackbar_utils.dart';

class OrderAddFragment extends StatefulWidget {
  final StoreEntity storeObj;

  const OrderAddFragment({super.key, required this.storeObj});

  @override
  _OrderAddFragment createState() => _OrderAddFragment();
}

class _OrderAddFragment extends State<OrderAddFragment> {
  final viewModel = ItemViewModel(appDatabase.orderProductDao);
  final List<TextEditingController> _qtyControllers = [];
  final List<TextEditingController> _rateControllers = [];
  final List<FocusNode> _qtyFocusNode = [];
  final List<FocusNode> _rateFocusNode = [];

  List<OrderProductEntity> orderProductL = [];

  String _amount = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    Future<void> product = loadProduct();
    List<void> results = await Future.wait([product]);
    if (orderProductL.isNotEmpty) {
      viewModel.loadItems();
    }
  }

  Future<void> loadProduct() async {
    await appDatabase.orderProductDao.deleteAll();
    await appDatabase.orderProductDao.setData();
    await appDatabase.orderProductDao.setSlNo();

    orderProductL = await appDatabase.orderProductDao.getAll();
    for (var value in orderProductL) {
      _qtyControllers.add(TextEditingController());
      _rateControllers.add(TextEditingController());
      _qtyFocusNode.add(FocusNode());
      _rateFocusNode.add(FocusNode());
    }
  }

  void _updateData() async {
    orderProductL = await appDatabase.orderProductDao.getAll();
    _qtyControllers.clear();
    _rateControllers.clear();
    _qtyFocusNode.clear();
    _rateFocusNode.clear();
    for (var value in orderProductL) {
      _qtyControllers.add(TextEditingController(text: value.qty.toString()));
      _rateControllers.add(TextEditingController(text: value.rate.toString()));
      _qtyFocusNode.add(FocusNode());
      _rateFocusNode.add(FocusNode());
    }
    var _totalAmt = await appDatabase.orderProductDao.getTotalAmt();
    setState(() {
      viewModel.loadItems(refresh: true);
      _amount = _totalAmt.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ChangeNotifierProvider<ItemViewModel>(
          create: (_) => viewModel,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Search Product",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      // Enable filling the background color
                      fillColor: AppColor.colorWhite,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppColor.colorGreenMoss), // Example: blue border when focused
                      )),
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
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: _buildProductCard(item, item.sl_no),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.white, // Example bottom widget
                height: 50,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: AppColor.colorBlue,
                        child: Center(
                          child: Text(_amount == "" ? "Amount" : "Amt : "+ (double.parse(_amount) ?.toStringAsFixed(2) ?? 0.00).toString(), style: AppStyle().textStyle.copyWith(color: AppColor.colorWhite)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final getCount = await appDatabase.orderProductDao.getProductAddedCount();
                          if (getCount! > 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OrderCartFragment(onDataChanged: _updateData, storeObj: widget.storeObj)),
                            );
                          } else {
                            SnackBarUtils().showSnackBar(context, 'Please add any product');
                          }
                        },
                        child: Container(
                          color: AppColor.colorGreenLeaf,
                          child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, // Centers horizontally
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("View Cart", style: AppStyle().textStyle.copyWith(color: AppColor.colorWhite)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    "assets/images/ic_arrow.png",
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.fill,
                                    color: AppColor.colorWhite,
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColor.colorSmokeWhite,
    );
  }

  Widget _buildProductCard(OrderProductEntity product, int index) {
    return Card(
      color: product.isAdded ? AppColor.colorGreenLight : AppColor.colorWhite,
      margin: AppStyle().cardMargin.copyWith(left: 0,right: 0,top: 0,bottom: 0),
      elevation:AppStyle().cardEvevation,
      shape: AppStyle().cardShape,
      child: Padding(
        padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
        // Set left padding to 5dp
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      chipTheme: ChipThemeData(
                        side: BorderSide.none, // Remove borders globally for this Chip
                      ),
                    ),
                    child: Chip(
                      label: Text(product.brand_name),
                      backgroundColor: AppColor.color1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18), // Adjust radius as needed
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      chipTheme: ChipThemeData(
                        side: BorderSide.none, // Remove borders globally for this Chip
                      ),
                    ),
                    child: Chip(
                      label: Text(product.category_name),
                      backgroundColor: AppColor.color2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18), // Adjust radius as needed
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      chipTheme: ChipThemeData(
                        side: BorderSide.none, // Remove borders globally for this Chip
                      ),
                    ),
                    child: Chip(
                      label: Text(product.watt_name),
                      backgroundColor: AppColor.color3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18), // Adjust radius as needed
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 5.0), // Add 16 pixels of left margin
              child: Text(
                product.product_name,
                style: AppStyle().textHeaderStyle.copyWith(color: AppColor.colorBlue),
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  width: 30, // Increase container width to accommodate padding
                  height: 30, // Increase container height to accommodate padding
                  decoration: BoxDecoration(
                    color: AppColor.colorGreyLight, // Background color
                    borderRadius: BorderRadius.circular(200), // Rounded corners
                    boxShadow: [
                      AppStyle().boxShadow,
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5.0), // Padding inside the container
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Image.asset(
                        "assets/images/ic_mrp.png", // Replace with your image path
                        fit: BoxFit.fill, // Adjust image scaling
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                    mainAxisAlignment: MainAxisAlignment.start, // Ensure text starts from the top
                    children: [
                      Text("MRP", style: AppStyle().textStyle.copyWith(color: AppColor.colorGrey)),
                      Text(product.product_mrp.toString(), style: AppStyle().textStyle.copyWith(color: AppColor.colorBlue)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
                padding: const EdgeInsets.only(left: 1.0, right: 1.0, top: 0.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildEntryDetails(product, _qtyControllers[index], _rateControllers[index], _qtyFocusNode[index], _rateFocusNode[index])],
                )),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryDetails(OrderProductEntity product, TextEditingController qtyController, TextEditingController rateController, FocusNode qtyFocusNode, FocusNode rateFocusNode) {
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
                  //height: 30,
                  alignment: Alignment.center,
                  child: Text('Quantity', textAlign: TextAlign.center,
                    style: AppStyle().textStyle.copyWith(color: AppColor.colorGrey),
                  ),
                ),
                Container(
                  height: 30, // Fixed height for text box
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: qtyController,
                    focusNode: qtyFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '',
                      border: UnderlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      InputFormatter(decimalRange: 2, beforeDecimal: 5,)
                    ],
                  ),
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
                  //height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    'Rate',
                    textAlign: TextAlign.center,
                    style: AppStyle().textStyle.copyWith(color: AppColor.colorGrey),
                  ),
                ),
                Container(
                  height: 30, // Fixed height for text box
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: rateController,
                    focusNode: rateFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '',
                      border: UnderlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      InputFormatter(decimalRange: 2, beforeDecimal: 5,)
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          ElevatedButton(
            style: AppStyle().buttonStyle.copyWith(backgroundColor: product.isAdded ? MaterialStateProperty.all(AppColor.colorGreen) : MaterialStateProperty.all(AppColor.colorButton)),
            onPressed: () async {
              final q = _qtyControllers[product.sl_no].text;
              final r = _rateControllers[product.sl_no].text;
              _qtyFocusNode[product.sl_no].unfocus();
              _rateFocusNode[product.sl_no].unfocus();
              if (q == "" || q == "0" || q == "0.0") {
                SnackBarUtils().showSnackBar(context, 'Enter quantity');
              } else if (r == "" || r == "0" || r == "0.0") {
                SnackBarUtils().showSnackBar(context, 'Enter rate');
              } else {
                await appDatabase.orderProductDao.updateAdded(double.parse(q), double.parse(r), true, product.product_id);
                final ordAmt = await appDatabase.orderProductDao.getTotalAmt();
                setState(() {
                  product.isAdded = true;
                  _amount = (ordAmt == null) ? "Amount" : ordAmt.toString();
                });
              }
            },
            child: Text(product.isAdded ? 'Added' : 'Add', style: AppStyle().textStyle.copyWith(color: AppColor.colorWhite)),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          "Select Product(s)",
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
      final newItems = await _itemDao.fetchPaginatedItemsSearch("%$query%", _pageSize, offset);

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
