import 'package:flutter/material.dart';
import'package:jkmapp/services/order/order_service.dart';
import 'package:jkmapp/utils/SnackBar.dart';
import 'package:jkmapp/utils/localStorage.dart';

class OrderProvider with ChangeNotifier {
  List<dynamic> _orders = [];  // 用來存放訂單的列表
  bool _isLoading = false;  // 加載狀態
  bool _hasError = false;

  List<dynamic> get orders => _orders;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  // 獲取訂單並更新狀態
  Future<void> fetchOrders(String tableNumber,BuildContext context) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();  // 通知 UI 進行更新

    try {
      List<dynamic> orders = await OrderService.getorderforclient(tableNumber);
      _orders = orders;  // 更新訂單列表

      if (orders.isEmpty) {
        // 僅當頁面首次進入並且 orders 為空時顯示
        if (_orders.isEmpty && !_hasError) {
          SnackBarutils.showSnackBar(context, "尚未加入訂單", Colors.red);
        }
      }else{
          _orders=orders;//更新訂單
      }
    } catch (e) {
      // 根據捕獲的錯誤顯示不同的提示
      _hasError = true;

      if (e.toString().contains('尚未加入訂單')) {
        SnackBarutils.showSnackBar(context, "尚未加入訂單", Colors.red);
      } else if (e.toString().contains('網路錯誤')) {
        SnackBarutils.showSnackBar(context, "網路錯誤，請稍後再試", Colors.red);
      } else {
        SnackBarutils.showSnackBar(context, "未知錯誤，請稍後再試", Colors.red);
      }
    } finally {
      _isLoading = false;
      notifyListeners();  // 最終狀態更新，通知 UI 更新
    }
  }


  //獲取所有訂單(業者)
  Future<void>getallorders(String? userId,BuildContext context)async{
    String? userId= await StorageHelper.getUserId();
     _isLoading=true;
     _hasError = false;
     notifyListeners();
    try{
        List<dynamic> orders = await OrderService.getorder(userId);
        _orders = orders;  // 更新訂單列表
        if (orders.isEmpty) {
          SnackBarutils.showSnackBar(context, "尚未加入訂單", Colors.red);
        }else{
          _orders=orders;//更新訂單
        }
      } catch (e) {
        // 根據捕獲的錯誤顯示不同的提示
        _hasError = true;

        if (e.toString().contains('尚未加入訂單')) {
          SnackBarutils.showSnackBar(context, "尚未加入訂單", Colors.red);
        } else if (e.toString().contains('網路錯誤')) {
          SnackBarutils.showSnackBar(context, "網路錯誤，請稍後再試", Colors.red);
        } else {
          SnackBarutils.showSnackBar(context, "未知錯誤，請稍後再試", Colors.red);
        }
      } finally {
        _isLoading = false;
        notifyListeners();  // 最終狀態更新，通知 UI 更新
    }
  }

  Future<bool>clearTodayOrder(BuildContext context)async{
    String? userId=await StorageHelper.getUserId();
    _isLoading=true;
    notifyListeners();
    bool success=await OrderService.clearTodayOrder(userId);
    notifyListeners();
    return success;
  }
}