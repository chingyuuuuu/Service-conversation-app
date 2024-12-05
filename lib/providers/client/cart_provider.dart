import 'package:flutter/material.dart';


//用來管理購物車的狀態
class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  double _totalAmount = 0;
  List<Map<String, dynamic>> _orderHistory = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;
  double get totalAmount => _totalAmount;
  List<Map<String, dynamic>> get orderHistory => _orderHistory; // 獲取歷史訂單
  // 加入商品
  void addToCart(String item, int price,int productId) {
    //檢查是否已經有該商品在購物車中
    int index=_cartItems.indexWhere((cartItem)=>cartItem['product_id']==productId);
    if(index!=-1){
      //商品已經存在，增加數量
      _cartItems[index]['quantity']+=1;
    }else{
      //商品不存在，將其加入購物車，初始=1
      _cartItems.add({'item': item, 'price': price,'quantity':1,'product_id':productId});
    }
    //更新總金額
    _totalAmount += price;
    notifyListeners(); // 通知所有监听者更新状态
  }

  // 移除商品
  void removeFromCart(int index) {
    _totalAmount -= _cartItems[index]['price'] as int;
    _cartItems.removeAt(index);
    notifyListeners(); //通知監聽者更新狀態
  }
  //增加商品數量
  void increaseQuantity(int index){
    _cartItems[index]['quantity']+=1;
    _totalAmount+=_cartItems[index]['price'];//更新總金額
    notifyListeners();
  }
  //減少商品數量
  void decreaseQuantiy(int index){
    if(_cartItems[index]['quantity']>1){
      _cartItems[index]['quantity']-=1;
      _totalAmount-=_cartItems[index]['price'];
    }else{
      removeFromCart(index);
    }
    notifyListeners();//通知更新狀態
  }


  //清空購物車並保存訂單
  void clearCart(){
    _orderHistory.addAll(_cartItems);
    _cartItems.clear();
    _totalAmount=0;
    notifyListeners();
  }
}
