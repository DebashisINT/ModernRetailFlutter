import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modern_retail/database/order_save_entity.dart';
import 'package:provider/provider.dart';

import '../api/api_service.dart';
import '../api/response/order_save_request.dart';
import '../database/order_product_entity.dart';
import '../database/order_save_dtls_entity.dart';
import '../database/store_entity.dart';
import '../main.dart';
import '../utils/app_color.dart';
import '../utils/app_style.dart';
import '../utils/app_utils.dart';
import '../utils/input_formatter.dart';
import '../utils/loader_utils.dart';
import '../utils/snackbar_utils.dart';

class OrderEditCartFragment extends StatefulWidget {
  final OrderSaveEntity orderObj;

  const OrderEditCartFragment({super.key, required this.orderObj});

  @override
  _OrderEditCartFragment createState() => _OrderEditCartFragment();
}

class _OrderEditCartFragment extends State<OrderEditCartFragment> {
  final apiService = ApiService(Dio());
  final viewModel = ItemViewModel(appDatabase.orderProductDao);

  final List<TextEditingController> _qtyControllers = [];
  final List<TextEditingController> _rateControllers = [];
  final List<FocusNode> _qtyFocusNode = [];
  final List<FocusNode> _rateFocusNode = [];
  List<bool> _visibilityControllers = [];

  String _totalQty = "";
  String _totalAmount = "";
  bool _isTickVisible = false;

  List<OrderProductEntity> orderProductL = [];

  @override
  void initState() {
    super.initState();
    setData();
  }

  Future<void> setData() async {
    await appDatabase.orderProductDao.deleteAll();
    await appDatabase.orderProductDao.setData();
    await appDatabase.orderProductDao.setSlNo();

    final orderDtls = await appDatabase.orderSaveDtlsDao.getDtlsById(widget.orderObj.order_id);
    for(var value in orderDtls){
      await appDatabase.orderProductDao.updateAdded(value.qty, value.rate, true, value.product_id);
    }
    loadData();
  }

  Future<void> loadData() async {
    orderProductL = await appDatabase.orderProductDao.getAllAdded();
    var qty = 0.0;
    var amt = 0.0;
    for (var value in orderProductL) {
      _qtyControllers.add(TextEditingController(text: value.qty.toString()));
      _rateControllers.add(TextEditingController(text: value.rate.toString()));
      _qtyFocusNode.add(FocusNode());
      _rateFocusNode.add(FocusNode());
      _visibilityControllers.add(false);
      qty = qty + value.qty;
      amt = amt + (value.qty * value.rate);
    }
    setState(() {
      _totalQty = qty.toString();
      _totalAmount = amt.toString();
    });
    viewModel.loadItems();
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
                height: 100,
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
                                child: Text(_totalQty == "" ? "Total Qty(s)" : "Total Qty(s)\n" + (double.parse(_totalQty) ?.toStringAsFixed(2) ?? 0.00).toString() ,
                                    style: AppStyle().textStyle.copyWith(color: AppColor.colorWhite), textAlign: TextAlign.center),
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
                                child: Text(_totalAmount == "" ? "Total Value" : "Total Value\n" + (double.parse(_totalAmount) ?.toStringAsFixed(2) ?? 0.00).toString() ,
                                    style: AppStyle().textStyle.copyWith(color: AppColor.colorWhite), textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: GestureDetector(
                        onTap: () async {
                          final getCount = await appDatabase.orderProductDao.getProductAddedCount();

                          if (getCount! > 0) {
                            _showRemarksDialog();
                          } else {
                            //SnackBarUtils().showSnackBar(context, 'There is no product in Cart');
                          }
                        },
                        child: Container(
                          color: AppColor.colorGreenLeaf,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center, // Centers horizontally
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Edit Order",
                                style: AppStyle().textHeaderStyle.copyWith(color: AppColor.colorWhite),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Image.asset(
                                "assets/images/ic_arrow.png",
                                height: 30,
                                width: 30,
                                fit: BoxFit.fill,
                                color: AppColor.colorWhite,
                              ),
                            ],
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
        backgroundColor: AppColor.colorSmokeWhite,
      ),
    );
  }

  Widget _buildProductCard(OrderProductEntity product, int index) {
    return Card(
      color: AppColor.colorWhite,
      margin: AppStyle().cardMargin.copyWith(left: 15,right: 15,top: 15,bottom: 15),
      elevation: AppStyle().cardEvevation,
      shape: AppStyle().cardShape,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(0), // Add 5 pixels of left margin
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes space between text and icon
                children: [
                  Expanded(
                    child: Text(
                      product.product_name,
                      style: AppStyle().textHeaderStyle.copyWith(color: AppColor.colorBlue),
                      overflow: TextOverflow.clip, // Ensures the text wraps properly
                      softWrap: true,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      print("Container clicked");
                      // Perform the delete operation
                      await appDatabase.orderProductDao.discardProduct(false, product.product_id);
                      _qtyControllers.clear();
                      _rateControllers.clear();
                      _qtyFocusNode.clear();
                      _rateFocusNode.clear();
                      loadData();
                      List<OrderProductEntity> updatedProducts = await appDatabase.orderProductDao.getAllAdded();
                      setState(() {
                        product.isAdded = false; // Update product state
                        viewModel._items = updatedProducts; // Update the product list
                      });
                    },
                    child: Container(
                      width: 30, // Increase container width to accommodate padding
                      height: 30, // Increase container height to accommodate padding
                      decoration: BoxDecoration(
                        color: AppColor.colorRed, // Background color
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
                            "assets/images/ic_delete.png", // Replace with your image path
                            fit: BoxFit.fill,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
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
                      Text(
                        "MRP",
                        style: AppStyle().textStyle.copyWith(color: AppColor.colorGrey),
                      ),
                      Text(
                        product.product_mrp.toString(),
                        style: AppStyle().textStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 1),
            Padding(
                padding: const EdgeInsets.only(left: 1.0, right: 1.0, top: 0.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildEntryDetails(product, _qtyControllers[index], _rateControllers[index], _qtyFocusNode[index], _rateFocusNode[index],index)],
                )),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryDetails(OrderProductEntity product, TextEditingController qtyController, TextEditingController rateController, FocusNode qtyFocusNode, FocusNode rateFocusNode,int index) {
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
                        InputFormatter(decimalRange: 2, beforeDecimal: 5,) // Maximum of 5 digits
                      ],
                      onChanged: (text) {
                        setState(() {
                          _visibilityControllers[index] = true;
                        });
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
                        InputFormatter(decimalRange: 2, beforeDecimal: 5,), // Maximum of 5 digits
                      ],
                      onChanged: (text) {
                        // Handle text changes here
                        setState(() {
                          _visibilityControllers[index] = true;
                        });
                      }
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Visibility(
              visible: _visibilityControllers[index],
              child: GestureDetector(
                onTap: () {
                  if (qtyController.text.isEmpty || qtyController.text == "0" || qtyController.text == "0.0") {
                    SnackBarUtils().showSnackBar(context, 'Enter Quantity');
                  }else if(rateController.text.isEmpty || rateController.text == "0" || rateController.text == "0.0"){
                    SnackBarUtils().showSnackBar(context, 'Enter rate');
                  }else {
                    commitChange(product, qtyController.text, rateController.text);
                    setState(() {
                      _visibilityControllers[index] = false;
                    });
                  }
                },
                child: Image.asset(
                  "assets/images/ic_tick.png",
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill,
                ),
              )),
        ],
      ),
    );
  }

  Future<void> commitChange(OrderProductEntity product,String qty,String rate) async {
    await appDatabase.orderProductDao.updateAddedInCart(double.parse(qty), double.parse(rate), product.product_id);
    var totalQty =await appDatabase.orderProductDao.getTotalQty();
    var totalAmt =await appDatabase.orderProductDao.getTotalAmt();
    setState(() {
      _totalQty = totalQty.toString();
      _totalAmount = totalAmt.toString();
    });
  }

  void _showRemarksDialog() {
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Enter Details',style: AppStyle().textStyle,),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text Input Field
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: 'Remarks(optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Attachment Selection
                ],
              ),
              actions: [
                ElevatedButton(
                  style: AppStyle().buttonStyle.copyWith(backgroundColor: MaterialStateProperty.all(AppColor.colorGrey)),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    //onSubmit_handlePlaceOrder("");
                  },
                  child: Text('Cancel', style: AppStyle().textStyle),
                ),
                ElevatedButton(
                  style: AppStyle().buttonStyle,
                  onPressed: () {
                    String userInput = textController.text;
                    Navigator.of(context).pop(); // Close the dialog
                    onSubmit_handlePlaceOrder(userInput);
                  },
                  child: Text('Submit', style: AppStyle().textStyle.copyWith(color: AppColor.colorWhite)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> onSubmit_handlePlaceOrder(String remarks) async {
    try {
      LoaderUtils().showLoader(context);

      OrderSaveEntity orderObj = OrderSaveEntity();
      List<OrderSaveDtlsEntity> orderDtlsL = [];

      DateTime currentDateTime = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);

      final ordAmt = await appDatabase.orderProductDao.getTotalAmt();

      orderObj.store_id =  widget.orderObj.store_id;
      orderObj.order_id = widget.orderObj.order_id;
      orderObj.order_date_time = formattedDate;
      orderObj.order_amount = ordAmt!;
      orderObj.order_status = "";
      orderObj.remarks = remarks;

      final productL = await appDatabase.orderProductDao.getAllAdded();
      for (var value in productL) {
        OrderSaveDtlsEntity obj = OrderSaveDtlsEntity();
        obj.order_id = orderObj.order_id;
        obj.product_id = value.product_id;
        obj.product_name = value.product_name.toString();
        obj.qty = value.qty;
        obj.rate = value.rate;
        orderDtlsL.add(obj);
      }


      await Future.delayed(Duration(seconds: 2));

      bool isOnline = await AppUtils().checkConnectivity();
      if (isOnline) {
        final request = OrderSaveRequest(user_id: pref.getString('user_id')!, store_id: orderObj.store_id, order_id: orderObj.order_id, order_date_time: formattedDate, order_amount: ordAmt.toString(), order_status: '', remarks: remarks, order_details_list: orderDtlsL);
        final response = await apiService.editOrder(request);
        if (response.status == "200") {
          await appDatabase.orderSaveDao.deleteById(orderObj.order_id);
          await appDatabase.orderSaveDtlsDao.deleteById(orderObj.order_id);

          await appDatabase.orderSaveDao.insert(orderObj);
          await appDatabase.orderSaveDtlsDao.insertAll(orderDtlsL);
          LoaderUtils().dismissLoader(context);
          showSuccessDialog(orderObj.order_id);
        } else {
          LoaderUtils().dismissLoader(context);
          SnackBarUtils().showSnackBar(context, 'Something went wrong.');
        }
      } else {
        LoaderUtils().dismissLoader(context);
        showSuccessDialog(orderObj.order_id);
      }
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  void showSuccessDialog(String orderID) {
    AppUtils().showCustomDialogWithOrderId(context, "Congrats!", "Hi ${pref.getString('user_name') ?? ""}, Your Order has been edited successfully.", orderID, () {
      Navigator.of(context).pop();
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          "Edit Order",
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