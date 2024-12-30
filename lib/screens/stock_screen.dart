import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_demo_one/database/product_dao.dart';
import 'package:flutter_demo_one/database/product_entity.dart';
import 'package:flutter_demo_one/database/repo/product_repo.dart';

import '../app_color.dart';
import '../decimal_text_input_formatter.dart';
import '../main.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  State<StockScreen> createState() => _StockScreen();
}

class _StockScreen extends State<StockScreen> {
  //final ProductRepo repository = MyRepository(myDaoInstance);
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 20;

  late final ProductDao _productDao;
  final List<ProductEntity> _productList = [];

  @override
  void initState() {
    super.initState();
    _productDao = appDatabase.productDao;
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    setState(() {
      _isLoading = true;
    });
    final offset = _currentPage * _pageSize;
    final stores = await _productDao.getProductPagination(_pageSize, offset);
    setState(() {
      _productList.addAll(stores);
      _isLoading = false;
      _hasMore = stores.length == _pageSize;
      if (_hasMore) _currentPage++;
    });
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
      body: _buildProductList(),
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
          return _buildProductCard(product);
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

  Widget _buildProductCard(ProductEntity product) {
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
                _buildDetail('Quantity', '',TextInputType.number),
                SizedBox(width: 10),
                _buildDetail('UOM', product.UOM,TextInputType.text),
                SizedBox(width: 10),
                _buildDetail('Mfg. Date', '',TextInputType.text),
                SizedBox(width: 10),
                _buildDetail('Expire Date', '',TextInputType.text),
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

  Widget _buildDetail(String title, String value,TextInputType inputType) {
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
            keyboardType : inputType,
            inputFormatters: [
              DecimalTextInputFormatter(decimalRange: 2, maxLength: 10), // Allow 2 decimals, max length 5
            ],
            textAlign: TextAlign.center,
            initialValue: value,
            decoration: InputDecoration(
              //hintText: value,
              border: const UnderlineInputBorder(),
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
