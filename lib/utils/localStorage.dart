import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class StorageHelper{
  static const String storeNameKey = 'storeName';
  static const String passwordKey = 'password';
  static const String savedTypesKey = 'savedTypes';
  static const String dataTypesKey='categories';
  static const String emailKey='user_email';
  static const String DBtypeskEY='types';
  static const String Products='product';
  //暫存email
  static Future<void> saveEmail(String email) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    await prefs.setString(emailKey, email);
  }
  //獲取店家名稱
  static Future<String?> getStoreName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(storeNameKey) ?? '店家';
  }
  //暫存店家名稱
  static Future<void> saveStoreName(String storeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(storeNameKey, storeName);
  }
  //獲取密碼
  static Future<String?> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(passwordKey) ?? '123456';  // 默认密码
  }
  //暫存密碼
  static Future<void> savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(passwordKey, password);
  }

  //獲得types列表==加載已保存的types列表
  static Future<List<String>> getTypes()async{
     SharedPreferences prefs =await SharedPreferences.getInstance();
     return prefs.getStringList(savedTypesKey) ?? [];
  }
  //暫存type列表
 static Future<void>saveTypes(List<String> types)async{
     //獲取暫存的types
     SharedPreferences prefs= await SharedPreferences.getInstance();
     //將types列表儲存到本地
     await prefs.setStringList(savedTypesKey, types);
 }

  static Future<String?> getUserId() async {
    // 從暫存中獲取user_id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  // 暫存客服資料的 type
  static Future<void> saveDataTypes(List<String> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(dataTypesKey, categories);
  }

  // 獲取暫存的 type 列表
  static Future<List<String>?> getDataTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(dataTypesKey);
  }

  //載入備註的狀態
  static Future<bool>loadRemarkEnabled()async{
     final prefs=await SharedPreferences.getInstance();
     return prefs.getBool('enable_remark')??false;//預設是false
  }
  //儲存備註的狀態
  static Future<void>saveRemarkEnabled(bool isEnabled)async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setBool('enable_remark', isEnabled);
  }
  //暫存真實儲存在資料庫中商品的type
  static Future<void>saveDBtype(List<String>types)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(DBtypeskEY, types);
  }
  //獲取已經存儲的types
   static Future<List<String>>getDBtypes()async{
       SharedPreferences prefs=await SharedPreferences.getInstance();
       return prefs.getStringList(DBtypeskEY) ??[];
   }
   //暫存商品資訊
  static Future<void> saveProductsByType(Map<String, List<Map<String, dynamic>>> productsByType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedProducts = json.encode(productsByType);
    await prefs.setString(Products, encodedProducts);
  }
  //獲取商品-讀取時需要將json.encode轉成map
  static Future<Map<String, List<Map<String, dynamic>>>> getProductsByType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedProducts = prefs.getString(Products);
    if (encodedProducts != null) {
      Map<String, dynamic> decodedProducts = json.decode(encodedProducts);
      return decodedProducts.map((key, value) => MapEntry(
          key, List<Map<String, dynamic>>.from(value as List<dynamic>)));
    }
    return {};
  }
}