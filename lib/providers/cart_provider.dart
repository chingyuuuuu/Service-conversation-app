import 'package:flutter/material.dart';


//用來管理購物車的狀態
class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  int _totalAmount = 0;
  List<Map<String, dynamic>> _orderHistory = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;
  int get totalAmount => _totalAmount;
  List<Map<String, dynamic>> get orderHistory => _orderHistory; // 獲取歷史訂單
  // 加入商品
  void addToCart(String item, int price) {
    _cartItems.add({'item': item, 'price': price});
    _totalAmount += price;
    notifyListeners(); // 通知所有监听者更新状态
  }

  // 移除商品
  void removeFromCart(int index) {
    _totalAmount -= _cartItems[index]['price'] as int;
    _cartItems.removeAt(index);
    notifyListeners(); //通知監聽者更新狀態
  }
  //清空購物車並保存訂單
  void clearCart(){
    _orderHistory.addAll(_cartItems);
    _cartItems.clear();
    _totalAmount=0;
    notifyListeners();
  }

}
