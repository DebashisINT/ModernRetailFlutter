import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modern_retail/database/store_entity.dart';
import 'package:modern_retail/utils/app_color.dart';
import 'package:provider/provider.dart';

import '../database/order_save_entity.dart';
import '../main.dart';
import '../utils/app_style.dart';
import 'order_add_fragment.dart';

class PlanogramSelfFragment extends StatefulWidget {
  @override
  _PlanogramSelfFragment createState() => _PlanogramSelfFragment();
}

class _PlanogramSelfFragment extends State<PlanogramSelfFragment> {

  final viewModel = ItemViewModel(appDatabase.orderSaveDao);

  StoreEntity storeObj = StoreEntity();
  List<DropdownMenuItem<StoreEntity>>? dropdownStore;

  @override
  void initState() {
    super.initState();
    _loadStores();
    viewModel.loadItems();
  }

  Future<void> _loadStores() async {
    final storeDao = appDatabase.storeDao;
    List<StoreEntity> storeL = await storeDao.getAll();
    setState(() {
      dropdownStore = storeL.map((obj) {
        return DropdownMenuItem<StoreEntity>(
          value: obj,
          child: Text(obj.store_name),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: ChangeNotifierProvider<ItemViewModel>(
          create: (_) => viewModel,
          child: Column(
            children: [
              buildInputFieldDropdownStore('Store'),
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
        },
        backgroundColor: AppColor.colorToolbar,
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      backgroundColor: AppColor.colorSmokeWhite,
    );
  }

  Widget _buildCard(OrderSaveEntity item) {
    return Card(
      color: AppColor.colorWhite,
      margin: AppStyle().cardMargin.copyWith(left: 0,right: 0,top: 0,bottom: 0),
      elevation: AppStyle().cardEvevation,
      shape: AppStyle().cardShape,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0), // Add 16 pixels of left margin
              child: Text(
                "xyz\nopsjod",
                style: AppStyle().textHeaderStyle.copyWith(color: AppColor.colorBlue),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildInputFieldDropdownStore(String hint) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 0),
      constraints: BoxConstraints(
        minHeight: 55.0, // Minimum height of the container
      ),
      decoration: BoxDecoration(
        color: AppColor.colorWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color with opacity
            spreadRadius: 1, // Spread the shadow
            blurRadius: 2, // Blur effect for the shadow
            offset: Offset(0, 3), // Shadow position (x, y)
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Expanded(
            child: DropdownButton<StoreEntity>(
              isExpanded: true,
              underline: SizedBox(),
              value:  storeObj.store_name.isEmpty ? null : storeObj,
              // Default value
              hint: Text(
                storeObj.store_name.isEmpty ? "Select $hint" : storeObj.store_name,
                style: TextStyle(color: Colors.grey[700]),
              ),
              items: dropdownStore,
              onChanged: (value) {
                setState(() {
                  try {
                    storeObj = value!;
                  } catch (e) {
                    print(e);
                  }
                });
              },
            )),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          "Planogram",
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
