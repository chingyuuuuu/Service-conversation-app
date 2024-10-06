import 'package:flutter/material.dart';


//用來管理購物車的狀態
class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  int _totalAmount = 0;

  List<Map<String, dynamic>> get cartItems => _cartItems;
  int get totalAmount => _totalAmount;

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
}
