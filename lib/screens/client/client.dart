import 'package:flutter/material.dart';
import 'package:jkmapp/widgets/client/TypeButton.dart';
import 'package:jkmapp/utils/diolog.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:jkmapp/services/products/loadingproducts.dart';
import 'package:jkmapp/widgets/client/cart.dart';
import 'package:jkmapp/widgets/client/ProductCard.dart';
import 'package:jkmapp/providers/Notification_Provider.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/order_provider.dart';
import 'package:jkmapp/routers/app_routes.dart';

class Client extends StatefulWidget {
  @override
  ClientState createState() => ClientState();
}

class ClientState extends State<Client> {
  TextEditingController passwordController = TextEditingController();
  List<Map<String, dynamic>> products = []; // 儲存all prodcuts
  Map<String, List<Map<String, dynamic>>> categorizedProducts = {
  }; //按照types分類的商品
  List<Map<String, dynamic>> displayedProducts = []; //儲存介面上顯示的商品列表
  String selectedTypes = ''; //允許追蹤哪個按鈕被選中
  List<String>typeOptions = [];
  bool isServiceBellTapped = false;
  String tableNumber = 'A1'; //記得處理桌號問題
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //確保UI完全加載後
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showPasswordNotification(context);
    });
    _loadProducts();
  }


  //加載商品，從商品中取得type(因為儲存在資料庫中當中，所以不會不見)
  void _loadProducts() async {
    //要使用await等待
    String? userId = await StorageHelper.getUserId();
    if (userId != null) {
      List<Map<String, dynamic>> loadproducts = await ProductService
          .loadProductForClient(userId);
      //按照商品分類
      Map<String, List<Map<String, dynamic>>>categorized = {}; //按照types對商品進行分類
      Set<String> types = loadproducts.map((
          product) => product['type'] as String).toSet(); //儲存商品的types

      for (var type in types) { //遍歷all商品提取type類型
        //根據每個type，將屬於該類型的產品放入
        categorized[type] =
            loadproducts.where((product) => product['type'] == type).toList();
      }


      setState(() {
        products = loadproducts; //將產品放入這個表
        typeOptions = ['全部', ...types.toList()]; //將types保存到這個表
        categorizedProducts = categorized;
        displayedProducts = loadproducts; //預設顯示所有商品
      });
    } else {
      print('User ID not found');
    }
  }


  void _resetServiceBell() {
    //設置1分鐘後恢復
    Future.delayed(Duration(minutes: 1), () {
      setState(() {
        isServiceBellTapped = false;
      });
    });
  }

  // 根據類型篩選商品

  void _filterProductsByType(String type) {
    setState(() {
      selectedTypes = type;
      _applyFilters();
    });
  }

  // 根據搜尋框中的輸入動態過濾商品
  void _filterProducts(String query) {
    setState(() {
      _applyFilters(query: query);
    });
  }

  // 結合類型篩選和搜尋框篩選
  void _applyFilters({String query = ''}) {
    List<Map<String, dynamic>> filteredProducts = [];

    if (selectedTypes == '全部') {
      filteredProducts = products; // 顯示所有商品
    } else {
      filteredProducts = categorizedProducts[selectedTypes] ?? []; // 根據選中的類型篩選
    }

    if (query.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) =>
          product['name'].toLowerCase().contains(query.toLowerCase()))
          .toList(); // 根據搜尋框中的輸入進行篩選
    }

    setState(() {
      displayedProducts = filteredProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 35),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('訂單'),
              onTap: () {
                Provider.of<OrderProvider>(context, listen: false).fetchOrders(tableNumber, context);
                Navigator.pushNamed(context, '/Orderlistpage');
              },
            ),
            const SizedBox(height: 10),
            ListTile(
               leading:const Icon(Icons.question_answer_outlined),
               title: const Text('客服'),
               onTap:(){
                  Navigator.pushNamed(context, Routers.restaurant_qasytstem);
               }
            ),
            const SizedBox(height: 40),
            ListTile(
              leading: Icon(Icons.notifications,
                  color: isServiceBellTapped ? Colors.yellow : Colors.black),
              title: Text('服務鈴'),
              onTap: () {
                setState(() {
                  isServiceBellTapped = true;
                });
                _resetServiceBell();
                Future.delayed(Duration.zero, () {
                  Provider.of<NotificationProvider>(context, listen: false)
                      .pressServiceBell();
                });
              },
            ),
            const SizedBox(height: 10),
            ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('設定'),
            onTap: () {
            showPasswordDialog(context, passwordController, () { // 傳遞回調函數
                  Navigator.pushNamed(context, Routers.dining); // 密碼正確後導航到 dining
            });
           },
         ),
        ],
      ),
    ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.white),
            ),
            title: _isSearching
                 ?TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜尋商品...',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                _filterProducts(value); // 根據輸入的值過濾商品
              },
            )
            :null,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            actions: [
              Padding(
              padding: const EdgeInsets.only(right:16.0),
              child:IconButton(
                icon: Icon(_isSearching
                    ? Icons.close
                    : Icons.search, color: Colors.black,size:30.0),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _isSearching = false; // 關閉搜尋框
                      _searchController.clear(); // 清空搜尋框
                      _applyFilters(); // 重置顯示的商品
                    } else {
                      _isSearching = true; // 顯示搜尋框
                    }
                  });
                },
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return buildCartBottomSheet(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TypeButtonList(
                typeOptions: typeOptions,
                selectedType: selectedTypes,
                onTypeSelected: _filterProductsByType, // 點擊按鈕過濾類型
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 每行顯示兩個商品
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.9, // 控制圖片和文字的比例
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return ProudctCard(product: displayedProducts[index]);
                },
                childCount: displayedProducts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
