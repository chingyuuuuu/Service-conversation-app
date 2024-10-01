import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jkmapp/utils/SnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<String?> _getUserId() async {
  // 從暫存中獲取user_id
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_id');
}

class ProductService{//定義一個加載數據的方法
    static Future<List<Map<String,dynamic>>> loadProdcuts(BuildContext context)async{
       try{
            String? userId =await _getUserId();

            if(userId == null){
              SnackBarutils.showSnackBar(context, "未找到用戶id", Colors.red);
              return[];
            }
            //發送get請求，並將userid作為查詢參數
           final response = await http.get(
              Uri.parse('http://127.0.0.1:5000/getProducts?user_id=$userId'),
              headers: {'Content-Type':'application/json'},
           );

            if(response.statusCode == 200){
              List<dynamic> products = json.decode(response.body);
              //將每個商品轉換為map<string,dynamic
              return products.map<Map<String,dynamic>>((product){
                   return{
                     'name': product['name'],
                     'type': product['type'],
                     'price': product['price'],
                     'cost': product['cost'],
                     'quantity': product['quantity'],
                     'image': product['image'],
                   };
              }).toList();
            }else{
              SnackBarutils.showSnackBar(context, "加載商品失敗", Colors.red);
              return [];
            }
       }catch(e){
           SnackBarutils.showSnackBar(context, "發生錯誤", Colors.red);
           return [];
       }
    }

}
