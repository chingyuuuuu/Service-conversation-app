import 'package:flutter/material.dart';
import 'package:jkmapp/utils/SnackBar.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:jkmapp/services/products/loadingproducts.dart';

class ClientProvider with ChangeNotifier{
    List<Map<String, dynamic>> products = []; // 儲存all prodcuts
    Map<String, List<Map<String, dynamic>>> categorizedProducts = {}; //按照types分類的商品
    List<Map<String, dynamic>> displayedProducts = []; //儲存介面上顯示的商品列表
    List<String>typeOptions = [];
    String selectedTypes = '全部'; //允許追蹤哪個按鈕被選中
    bool isServiceBellTapped = false;

    Future<void> showPasswordNotification(BuildContext context) async {
      String? savedPassword=await StorageHelper.getPassword();
      SnackBarutils.showSnackBar(context,'後臺密碼是:$savedPassword',Colors.blue);
    }

    //加載商品，從商品中取得type(因為儲存在資料庫中當中，所以不會不見)
    Future<void> loadProducts() async {
      try {
        String? userId = await StorageHelper.getUserId();
        if (userId != null) {
          List<Map<String, dynamic>> loadedProducts = await ProductService.loadProductForClient(userId);
          // 按類型分類商品
          Map<String, List<Map<String, dynamic>>> categorized = {};
          Set<String> types = loadedProducts.map((product) => product['type'] as String).toSet();
          for (var type in types) {
                categorized[type] = loadedProducts.where((product) => product['type'] == type).toList();
          }

          // 更新狀態
          products = loadedProducts; //將產品放入這個表
          categorizedProducts = categorized;
          typeOptions = ['全部', ...types.toList()]; //將types保存到這個表
          displayedProducts = loadedProducts; //預設顯示所有商品

          notifyListeners();
        } else {
          print('User ID not found');
        }
      }catch(e){
          print('加載商品時出現錯誤:$e');
      }
    }
    
    // 根據類型篩選商品
    void filterProductsByType(String type) {
      selectedTypes = type;
      applyFilters();
    }

    // 根據搜尋框中的輸入動態過濾商品
    void filterProducts(String query) {
      applyFilters(query: query);//根據傳入的query進行篩選
    }

    // 結合類型篩選和搜尋框篩選
    void applyFilters({String query = ''}) {
      List<Map<String, dynamic>> filteredProducts;
      if (selectedTypes == '全部') {
        filteredProducts = products;
      } else {
        filteredProducts = categorizedProducts[selectedTypes] ?? [];
        print('Filtered Products for type $selectedTypes: $filteredProducts');
      }

      if (query.isNotEmpty) {
        filteredProducts = filteredProducts
            .where((product) =>
            product['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      displayedProducts = filteredProducts;
      notifyListeners();
    }

    void toggleServiceBell() {
      isServiceBellTapped = true;
      notifyListeners();//通知更新
      Future.delayed(const Duration(seconds:20), () {//過了20秒之後關閉
        isServiceBellTapped = false;
        notifyListeners();//通知更新
      });
    }

}