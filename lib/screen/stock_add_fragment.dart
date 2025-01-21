import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modern_retail/utils/app_message.dart';
import 'package:provider/provider.dart';

import '../api/api_service.dart';
import '../api/api_service_multipart.dart';
import '../api/response/stock_save_request.dart';
import '../database/app_database.dart';
import '../database/stock_product_entity.dart';
import '../database/stock_save_dtls_entity.dart';
import '../database/stock_save_entity.dart';
import '../database/store_entity.dart';
import '../main.dart';
import '../utils/app_color.dart';
import '../utils/app_style.dart';
import '../utils/app_utils.dart';
import '../utils/input_formatter.dart';
import '../utils/loader_utils.dart';
import '../utils/snackbar_utils.dart';

class StockAddFragment extends StatefulWidget {
  @override
  _StockAddFragment createState() => _StockAddFragment();
}

class _StockAddFragment extends State<StockAddFragment> {
  StoreEntity selectedStore = StoreEntity();
  List<DropdownMenuItem<StoreEntity>>? dropdownStores;

  final List<TextEditingController> _qtyControllers = [];
  final List<TextEditingController> _uomIDControllers = [];
  final List<TextEditingController> _uomControllers = [];
  final List<TextEditingController> _mfgDatecontrollers = [];
  final List<TextEditingController> _expDatecontrollers = [];

  String remarks = "";
  String filePath = "";

  final apiServiceMultipart = ApiServiceMultipart(Dio());

  List<StockProductEntity> stockProductL = [];

  final viewModel = ItemViewModel(appDatabase.stockProductDao);

  final apiService = ApiService(Dio());

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    Future<void> stockProduct = loadStockProduct();
    Future<void> stores = loadStores();
    List<void> results = await Future.wait([stockProduct, stores]);
    viewModel.loadItems();
  }

  Future<void> loadStockProduct() async {
    appDatabase.stockProductDao.deleteAll();
    appDatabase.stockProductDao.setData();
    appDatabase.stockProductDao.setSlNo();
    stockProductL = await appDatabase.stockProductDao.getAll();

    for (var value in stockProductL) {
      _qtyControllers.add(TextEditingController());
      _uomIDControllers.add(TextEditingController(text: value.UOM_id.toString()));
      _uomControllers.add(TextEditingController(text: value.UOM));
      _mfgDatecontrollers.add(TextEditingController());
      _expDatecontrollers.add(TextEditingController());
    }
  }

  Future<void> loadStores() async {
    List<StoreEntity> storeTypes = await getStoreTypes();
    setState(() {
      dropdownStores = storeTypes.map((storeType) {
        return DropdownMenuItem<StoreEntity>(
          value: storeType,
          child: Text(storeType.store_name),
        );
      }).toList();
    });
  }

  Future<List<StoreEntity>> getStoreTypes() async {
    final storeTypeDao = appDatabase.storeDao;
    return await storeTypeDao.getAll();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ChangeNotifierProvider<ItemViewModel>(
        create: (_) => viewModel,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50, // Set your desired height here
                decoration: BoxDecoration(
                  color: AppColor.colorWhite, // Optional: Set a background color
                  borderRadius: BorderRadius.circular(8), // Optional: Add rounded corners
                  border: Border.all(
                    color: Colors.grey[400]!, // Set your border color
                    width: 1, // Set your border width
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: Offset(0, 2), // Offset in x and y directions
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: DropdownButton<StoreEntity>(
                    isExpanded: true,
                    underline: SizedBox(),
                    value: selectedStore.store_name.isEmpty ? null : selectedStore,
                    // Default value
                    hint: Text(
                      selectedStore.store_name.isEmpty ? "Select Store" : selectedStore.store_name,
                      style: TextStyle(color: AppColor.colorBlueSteel),
                    ),
                    items: dropdownStores,
                    onChanged: (value) {
                      setState(() {
                        try {
                          // Update your selectedStore here
                          selectedStore = value!;
                        } catch (e) {
                          print(e);
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Search Product",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    // Enable filling the background color
                    fillColor: AppColor.colorWhite,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
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

                          final item = viewModel.items[index];
                          return _buildProductCard(item, index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shadowColor: Colors.black,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: Colors.black26, width: 0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  backgroundColor: AppColor.colorButton,
                ),
                onPressed: () async {
                  if (selectedStore.store_id == "") {
                    SnackBarUtils().showSnackBar(context, 'Select Store');
                  } else {
                    final qtyList = getNonEmptyControllersWithIndices(_qtyControllers);
                    //final uomList =getNonEmptyControllersWithIndices(_uomControllers);
                    //final mfgList =getNonEmptyControllersWithIndices(_mfgDatecontrollers);
                    //final expList =getNonEmptyControllersWithIndices(_expDatecontrollers);
                    if (qtyList.isEmpty) {
                      SnackBarUtils().showSnackBar(context, 'Select a product');
                    } else {
                      _showInputDialog();
                    }
                  }
                },
                child: const Text('Submit', style: TextStyle(fontSize: 18, color: AppColor.colorWhite)),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColor.colorSmokeWhite, // Set the background color to red
    );
  }

  List<MapEntry<int, TextEditingController>> getNonEmptyControllersWithIndices(List<TextEditingController> controllers) {
    return controllers
        .asMap() // Convert the list to a map with indices as keys
        .entries
        .where((entry) => entry.value.text.isNotEmpty) // Filter non-empty controllers
        .toList(); // Convert the filtered entries back to a list
  }

  Future<void> uploadFileApi(String stockID) async {
    try {
      final jsonData = '{"stock_id":"$stockID","user_id":"${pref.getString('user_id')!}"}';

      final File file = File(filePath);

      final response = await apiServiceMultipart.uploadStockFile(jsonData, file!);
      if (response.status == "200") {
        final a = 123;
        LoaderUtils().dismissLoader(context);
        showSuccessDialog();
      }
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
      SnackBarUtils().showSnackBar(context,'Something went wrong.');
    }
  }

  Future<void> submitData() async {
    try {
      LoaderUtils().showLoader(context);
      List<MapEntry<int, TextEditingController>> qtyList = getNonEmptyControllersWithIndices(_qtyControllers);
      final StockSaveEntity stock = StockSaveEntity();
      final List<StockSaveDtlsEntity> stockL = [];

      DateTime currentDateTime = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);
      final stockID = "STK_" + pref.getString('user_id')! + formattedDate.replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "");

      stock.stock_id = stockID;
      stock.save_date_time = formattedDate;
      stock.store_id = selectedStore.store_id;
      stock.remarks = remarks;

      DateFormat inputFormat = DateFormat('dd-MM-yyyy');

      for (var i = 0; i < qtyList.length; i++) {
        final selected_product_id = stockProductL[qtyList[i].key].product_id.toString();
        final selected_qty = qtyList[i].value.text.toString();
        final selected_UOMID = _uomIDControllers[qtyList[i].key].text.toString();
        final selected_UOM = _uomControllers[qtyList[i].key].text.toString();

        DateTime mfgDate = inputFormat.parse(_mfgDatecontrollers[qtyList[i].key].text.toString());
        DateTime expDate = inputFormat.parse(_expDatecontrollers[qtyList[i].key].text.toString());
        String mfgOutputDate = '${mfgDate.year}-${mfgDate.month.toString().padLeft(2, '0')}-${mfgDate.day.toString().padLeft(2, '0')}';
        String expOutputDate = '${expDate.year}-${expDate.month.toString().padLeft(2, '0')}-${expDate.day.toString().padLeft(2, '0')}';

        final selected_mfg_date = mfgOutputDate;//_mfgDatecontrollers[qtyList[i].key].text.toString();
        final selected_expire_date = expOutputDate;//_expDatecontrollers[qtyList[i].key].text.toString();
        final obj = StockSaveDtlsEntity(stock_id: stockID, product_id: int.parse(selected_product_id), product_dtls_id: i + 1, qty: double.parse(selected_qty), uom_id: int.parse(selected_UOMID), uom: selected_UOM, mfg_date: selected_mfg_date, expire_date: selected_expire_date);
        stockL.add(obj);
      }
      await appDatabase.stockSaveDao.insertStock(stock);
      await appDatabase.stockSaveDtlsDao.insertAll(stockL);
      await Future.delayed(Duration(seconds: 2));

      bool isOnline = await AppUtils().checkConnectivity();
      if (isOnline) {
        final request = StockSaveRequest(user_id: pref.getString('user_id')!, stock_id: stock.stock_id, save_date_time: stock.save_date_time, remarks: stock.remarks, store_id: stock.store_id, product_list: stockL);
        final response = await apiService.saveStock(request);
        if (response.status == "200") {
          if (filePath != "") {
            uploadFileApi(stock.stock_id);
          } else {
            LoaderUtils().dismissLoader(context);
            showSuccessDialog();
          }
        } else {
          LoaderUtils().dismissLoader(context);
          SnackBarUtils().showSnackBar(context, AppMessage().wrong);
        }
      } else {
        LoaderUtils().dismissLoader(context);
        showSuccessDialog();
      }
    } catch (e) {
      print(e);
      SnackBarUtils().showSnackBar(context, AppMessage().wrong);
    }
  }

  void showSuccessDialog() {
    AppUtils().showCustomDialog(context, "Congrats!", "Hi ${pref.getString('user_name') ?? ""}, Your Stock for ${selectedStore.store_name} has been updated successfully.", () {
      Navigator.of(context).pop();
    });
  }

  void _showInputDialog() {
    TextEditingController textController = TextEditingController();
    String? selectedFilePath;
    String? selectedFileName;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Enter Details'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          selectedFileName ?? 'No file selected(optional)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton(
                        style: AppStyle().buttonStyle,
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();
                          if (result != null && result.files.isNotEmpty) {
                            setState(() {
                              selectedFilePath = result.files.single.path;
                              selectedFileName = result.files.single.name;
                            });
                          }
                        },
                        child: Text('Attach',style: AppStyle().textStyle.copyWith(color: AppColor.colorWhite)),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: AppStyle().buttonStyle.copyWith(backgroundColor: MaterialStateProperty.all(AppColor.colorGrey)),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    //submitData();
                  },
                  child: Text('Cancel',style: AppStyle().textStyle),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shadowColor: Colors.black87,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: const BorderSide(color: Colors.black26, width: 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: AppColor.colorButton,
                  ),
                  onPressed: () {
                    remarks = textController.text;
                    if(selectedFilePath != null){
                      filePath = selectedFilePath!;
                    }
                    Navigator.of(context).pop(); // Close the dialog
                    submitData();
                  },
                  child: Text('Submit',style: AppStyle().textStyle.copyWith(color: AppColor.colorWhite)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildProductCard(StockProductEntity product, int index) {
    return Card(
      color: AppColor.colorWhite,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
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
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 5.0), // Add 16 pixels of left margin
              child: Text(
                product.product_name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.colorButton,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.only(left: 1.0, right: 1.0, top: 0.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildDetails(_qtyControllers[product.sl_no], _uomControllers[product.sl_no], _mfgDatecontrollers[product.sl_no], _expDatecontrollers[product.sl_no])],
                )),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(TextEditingController qtyController, TextEditingController uomController, TextEditingController mfgDateController, TextEditingController expDateController) {
    return Flexible(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40, // Fixed height for text box
                  alignment: Alignment.center,
                  child: Text(
                    'Quantity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.colorBlack,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 40, // Fixed height for text box
                  alignment: Alignment.center,
                  child: Text(
                    'UOM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.colorBlack,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 40, // Fixed height for text box
                  alignment: Alignment.center,
                  child: Text(
                    'Mfg. Date',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.colorBlack,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 40, // Fixed height for text box
                  alignment: Alignment.center,
                  child: Text(
                    'Exp. Date',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.colorBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45, // Fixed height for text box
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '',
                      border: UnderlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      InputFormatter(decimalRange: 0, beforeDecimal: 5,)
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  height: 45, // Fixed height for text box
                  alignment: Alignment.center,
                  child: TextFormField(
                    readOnly: true,
                    controller: uomController,
                    decoration: InputDecoration(
                      hintText: uomController.text,
                      border: UnderlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  height: 45, // Fixed height for text box
                  alignment: Alignment.center,
                  child: TextFormField(
                      readOnly: true,
                      controller: mfgDateController,
                      decoration: InputDecoration(
                        hintText: 'MM-DD-YYYY',
                        hintStyle: AppStyle().hintStyle,
                        border: UnderlineInputBorder(),
                      ),
                      textAlign: TextAlign.center,
                      onTap: () async {
                        // Open date picker when the field is tapped
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                          mfgDateController.text = formattedDate;
                        }
                      }),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  height: 45, // Fixed height for text box
                  alignment: Alignment.center,
                  child: TextFormField(
                      readOnly: true,
                      controller: expDateController,
                      decoration: InputDecoration(
                        hintText: 'MM-DD-YYYY',
                        hintStyle: AppStyle().hintStyle,
                        border: UnderlineInputBorder(),
                      ),
                      textAlign: TextAlign.center,
                      onTap: () async {
                        if(mfgDateController.text == ""){
                          SnackBarUtils().showSnackBar(context, 'Select Mfg. Date');
                          return;
                        }
                        DateTime mfgDate = DateFormat('dd-MM-yyyy').parse(mfgDateController.text);
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: mfgDate.add(const Duration(days: 1)),
                          firstDate: mfgDate.add(const Duration(days: 1)),
                          lastDate: DateTime(2100),
                        );

                        // Open date picker when the field is tapped
                       /* DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );*/
                        if (selectedDate != null) {
                          String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                          expDateController.text = formattedDate;
                        }
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          "Stock",
          style: AppStyle().toolbarTextStyle,
        ),
      ),
      backgroundColor: AppColor.colorToolbar,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white), // Back button on the left
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
  final StockProductDao _itemDao;
  List<StockProductEntity> _items = [];
  List<StockProductEntity> _filteredItems = [];
  bool _hasMoreData = true;
  LoadingState _loadingState = LoadingState.idle;
  int _page = 0;
  final int _pageSize = 20;

  ItemViewModel(this._itemDao);

  List<StockProductEntity> get items => _filteredItems.isEmpty ? _items : _filteredItems;

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
