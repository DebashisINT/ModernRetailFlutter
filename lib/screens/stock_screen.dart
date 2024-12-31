import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_demo_one/database/product_dao.dart';
import 'package:flutter_demo_one/database/product_entity.dart';
import 'package:flutter_demo_one/database/repo/product_repo.dart';
import 'package:intl/intl.dart';

import '../app_color.dart';
import '../decimal_text_input_formatter.dart';
import '../main.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  State<StockScreen> createState() => _StockScreen();
}

class _StockScreen extends State<StockScreen> {
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 20;

  late final ProductDao _productDao;
  final List<ProductEntity> _productList = [];

  final List<SavedProduct> _savedProductList = [];

  final List<TextEditingController> _mfgDatecontrollers = [];
  final List<TextEditingController> _expDatecontrollers = [];
  final List<TextEditingController> _qtyControllers = [];
  final List<TextEditingController> _uomControllers = [];

  @override
  void initState() {
    super.initState();
    _productDao = appDatabase.productDao;
    setController();
    _fetchData();
  }

  Future<dynamic> setController() async {
    final productL = await _productDao.getAll();
    for (var value in productL) {
      _qtyControllers.add(TextEditingController());
      _uomControllers.add(TextEditingController(text: value.UOM));
      _mfgDatecontrollers.add(TextEditingController());
      _expDatecontrollers.add(TextEditingController());
    }
  }

  Future<void> _fetchData() async {
    if (_isLoading || !_hasMore) return; // Prevent fetching if already loading or no more data
    setState(() => _isLoading = true);

    try {
      final offset = _currentPage * _pageSize;
      final stores = await _productDao.getProductPagination(_pageSize, offset);

      setState(() {
        _productList.addAll(stores);
        _isLoading = false;
        _hasMore = stores.length == _pageSize; // If returned data is less than _pageSize, no more data
        if (_hasMore) _currentPage++; // Increment page only if there are more results
      });
    } catch (error) {
      setState(() => _isLoading = false);
      // Optionally, show an error message
      print("Error fetching data: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_productList.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      // Set the background color of the screen to white
      appBar: AppBar(
        backgroundColor: AppColor.colorToolbar,
        // Toolbar background color
        foregroundColor: Colors.white,
        // Back button and icons color
        centerTitle: true,
        // Ensures the title is centered
        title: const Text(
          'Stock',
          style: TextStyle(
            color: Colors.white, // Title text color
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(),
        // Back button on the far left
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
      body: Column(
        children: [
          Expanded(
            child: _buildProductList(), // List view here
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shadowColor: Colors.black87,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: const BorderSide(color: Colors.black26, width: 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                backgroundColor: AppColor.colorButton,
              ),
              onPressed: () async {

              },
              child: const Text('Submit', style: TextStyle(fontSize: 18,color: AppColor.colorWhite)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    if (_productList.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: _productList.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _productList.length) {
          final product = _productList[index];
          return _buildProductCard(product,index);
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

  Widget _buildProductCard(ProductEntity product,int index) {
    return Card(
      color: AppColor.colorGreyLight,
      // Set the background color of the Card to white
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      // Margin for the card (start margin)
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 0.0),
        // Set left padding to 5dp
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Chip(
                    label: Text(product.brand_name),
                    backgroundColor: Colors.blue[50],
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(product.category_name),
                    backgroundColor: Colors.red[50],
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(product.watt_name),
                    backgroundColor: Colors.green[50],
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
                _buildDetail(product,'Expire Date', _expDatecontrollers[index].text,TextInputType.text,context,true, _expDatecontrollers[index]),
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
              color: AppColor.colorStoreTxt,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: inputType,
            inputFormatters: [
              DecimalTextInputFormatter(decimalRange: 2, maxLength: 10), // Allow 2 decimals, max length 5
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

}


class SavedProduct{
    final int product_id;
    final double qty;
    final String UOM;
    final String mfg_date;
    final String exp_date;

    SavedProduct({required this.product_id,required this.qty,required this.UOM,
      required this.mfg_date,required this.exp_date});

}