import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_one/app_color.dart';
import 'package:flutter_demo_one/database/store_dao.dart';
import 'package:flutter_demo_one/database/store_entity.dart';
import 'package:flutter_demo_one/screens/store_add_screen.dart';

import '../main.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  State<StoreScreen> createState() => _StoreScreen();

}

class _StoreScreen extends State<StoreScreen> {
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;

  late final StoreDao _storeDao;
  final List<StoreEntity> _storeL = [];
  final int _pageSize = 20; // Number of items per page

  @override
  void initState() {
    super.initState();
    _storeDao = appDatabase.storeDao;
    _fetchData();
  }

  void updateData() {
    setState(() {
      _storeL.clear();
      _currentPage = 0;
      _hasMore = true;
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text('Store(s)'),
          ),
          body: ListView.builder(
            itemCount: _storeL.length + (_hasMore ? 1 : 0), // Replace with your actual item count
            itemBuilder: (context, index) {
              if (index < _storeL.length) {
                return ListTile(
                  title: Text(_storeL[index].store_name),
                );
              } else {
                // Show a loading indicator if more data is available
                _fetchData();
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StoreAddScreen(onDataChanged: updateData)),
          );
        },
        child: IconTheme(
          data: IconThemeData(color: Colors.white),
          child: Icon(Icons.add),
        ),
        backgroundColor: AppColor.colorCharcoal,)
      ),
    );
  }

  Future<void> _fetchData() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final offset = _currentPage * _pageSize;
    final stores = await _storeDao.getStorePagination(_pageSize, offset);

    setState(() {
      _storeL.addAll(stores);
      _isLoading = false;
      _hasMore = stores.length == _pageSize; // Check if there's more data
      _currentPage++;
    });
  }

}