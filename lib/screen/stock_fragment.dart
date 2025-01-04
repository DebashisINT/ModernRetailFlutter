import 'dart:async';

import 'package:fl/database/product_entity.dart';
import 'package:fl/database/stock_save_dtls_entity.dart';
import 'package:fl/database/stock_save_entity.dart';
import 'package:fl/database/store_entity.dart';
import 'package:fl/database/store_type_entity.dart';
import 'package:fl/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../utils/app_color.dart';
import '../utils/app_utils.dart';

class StockFragment extends StatefulWidget {
  @override
  _StockFragment createState() => _StockFragment();
}

class _StockFragment extends State<StockFragment> {

  StoreEntity selectedStore = StoreEntity();
  List<DropdownMenuItem<StoreEntity>>? dropdownStores;

  final List<TextEditingController> _qtyControllers = [];
  final List<TextEditingController> _uomControllers = [];
  final List<TextEditingController> _mfgDatecontrollers = [];
  final List<TextEditingController> _expDatecontrollers = [];

  List<ProductEntity> productL = [];

  final viewModel = ItemViewModel(appDatabase.productDao);

  @override
  void initState() {
    super.initState();
    setController();
    loadStores();
  }

  Future<void> loadStores() async{
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

  Future<dynamic> setController() async {
    productL = await appDatabase.productDao.getAll();
    for (var value in productL) {
      _qtyControllers.add(TextEditingController());
      _uomControllers.add(TextEditingController(text: value.UOM));
      _mfgDatecontrollers.add(TextEditingController());
      _expDatecontrollers.add(TextEditingController());
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ChangeNotifierProvider<ItemViewModel>(
        create: (_) {
          viewModel.loadItems(); // Call loadItems here
          return viewModel;
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50, // Set your desired height here
                decoration: BoxDecoration(
                  color: AppColor.colorSmokeWhite, // Optional: Set a background color
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
                    value: selectedStore.store_name.isEmpty ? null : selectedStore, // Default value
                    hint: Text(
                      selectedStore.store_name.isEmpty ? "Select Store" : selectedStore.store_name,
                      style: TextStyle(color: Colors.grey[700]),
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
                  if(selectedStore.store_id == ""){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Select Store")),);
                  }else{
                    final qtyList =getNonEmptyControllersWithIndices(_qtyControllers);
                    //final uomList =getNonEmptyControllersWithIndices(_uomControllers);
                    //final mfgList =getNonEmptyControllersWithIndices(_mfgDatecontrollers);
                    //final expList =getNonEmptyControllersWithIndices(_expDatecontrollers);
                    if(qtyList.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Select a product")),);
                    }else{
                      submitData(qtyList);
                    }
                  }
                },
                child: const Text('Submit', style: TextStyle(fontSize: 18,color: AppColor.colorWhite)),
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

  Future<void> submitData(List<MapEntry<int, TextEditingController>> qtyList) async {
    try {
      showDialog(context: context, builder: (context) {
        return Center(child: CircularProgressIndicator());
      },);

      final StockSaveEntity stock=StockSaveEntity();
      final List<StockSaveDtlsEntity> stockL = [];

      DateTime currentDateTime = DateTime.now();
      String formattedDate =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);
      final stockID = pref.getString('user_id')! +
          formattedDate
              .replaceAll(" ", "")
              .replaceAll("-", "")
              .replaceAll(":", "");

      stock.stock_id = stockID;
      stock.save_date_time=formattedDate;
      stock.store_id = selectedStore.store_id;

      for (var i = 0; i < qtyList.length; i++) {
            final selected_product_id = productL[qtyList[i].key].product_id.toString();
            final selected_qty = qtyList[i].value.text.toString();
            final selected_UOM = _uomControllers[qtyList[i].key].text.toString();
            final selected_mfg_date = _mfgDatecontrollers[qtyList[i].key].text.toString();
            final selected_expire_date = _expDatecontrollers[qtyList[i].key].text.toString();
            final obj = StockSaveDtlsEntity(stock_id: stockID,product_id: selected_product_id,
              qty: selected_qty,uom: selected_UOM,mfg_date: selected_mfg_date,
                expire_date: selected_expire_date
            );
            stockL.add(obj);
          }
      await appDatabase.stockSaveDao.insertStock(stock);
      await appDatabase.stockSaveDtlsDao.insertAll(stockL);
      await Future.delayed(Duration(seconds: 5));
      Navigator.of(context).pop();
      AppUtils().showCustomDialog(context,"Congrats!","Hi ${pref.getString('user_name') ?? ""}, Your Stock for ${selectedStore.store_name} has been updated successfully.",(){
        Navigator.of(context).pop();
      });
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
    }

  }


  Widget _buildProductCard(ProductEntity product,int index) {
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
                  SizedBox(width: 10,),
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
                  SizedBox(width: 10,),
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
            Padding(padding: const EdgeInsets.only(left: 1.0, right: 1.0, top: 0.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetail(product,'Quantity', _qtyControllers[index].text,TextInputType.number,context,false, _qtyControllers[index]),
                    SizedBox(width: 10),
                    _buildDetail(product,'UOM', _uomControllers[index].text,TextInputType.text,context,false, _uomControllers[index]),
                    SizedBox(width: 10),
                    _buildDetail(product,'Mfg. Date', _mfgDatecontrollers[index].text,TextInputType.text,context,true,_mfgDatecontrollers[index]),
                    SizedBox(width: 10),
                    _buildDetail(product,'Exp. Date', _expDatecontrollers[index].text,TextInputType.text,context,true, _expDatecontrollers[index]),
                    SizedBox(width: 10),
                  ],
                )
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(ProductEntity product,String title, String value, TextInputType inputType, BuildContext context,bool isReadOnly,TextEditingController controller) {
    controller.text = value;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: AppColor.colorCharcoal,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: inputType,
            inputFormatters: [
              //DecimalTextInputFormatter(decimalRange: 2, maxLength: 10), // Allow 2 decimals, max length 5
            ],
            textAlign: TextAlign.center,
            //initialValue: value,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            readOnly: isReadOnly, // Prevents the keyboard from appearing
            onTap: () async {
              if(isReadOnly){
                // Open date picker when the field is tapped
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (selectedDate != null) {
                  String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                  controller.text = formattedDate;
                }
              }
            },
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
          style: TextStyle(color: AppColor.colorWhite, fontSize: 20),
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
  final ProductDao _itemDao;
  List<ProductEntity> _items = [];
  List<ProductEntity> _filteredItems = [];
  bool _hasMoreData = true;
  LoadingState _loadingState = LoadingState.idle;
  int _page = 0;
  final int _pageSize = 20;

  ItemViewModel(this._itemDao);

  List<ProductEntity> get items => _filteredItems.isEmpty ? _items : _filteredItems;
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
            item.product_name.toLowerCase().contains(query.toLowerCase()))
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