import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jkmapp/utils/SnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jkmapp/utils/localStorage.dart';


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
                     'product_id':product['product_id'],
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

    static Future<Map<String,dynamic>?> loadProductDetails(BuildContext context,int productId)async{
      final url = Uri.parse('http://127.0.0.1:5000/getproducts/$productId');
      try{
          final response = await http.get(url,headers: {'Content-Type':'application/json'});
          if (response.statusCode == 200){
            return json.decode(response.body);
          }else if(response.statusCode ==404){
            //找不到商品
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('商品未找到')));
          }else{
            //其他錯誤
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('加載商品失败')));
            return null;
          }
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('發生錯誤')));
        return null;
      }
    }

    static Future<void>updateProduct(
            BuildContext context,
            int productId,
            String name,
            String type,
            double price,
            double cost,
            int quantity
        )async{
         //透過url將productId傳到後端
         final url = Uri.parse('http://127.0.0.1:5000/update_product/$productId');
         final headers = {'Content-Type': 'application/json'};
         final body = json.encode({//傳遞給後端
           'name': name,
           'type': type,
           'price': price,
           'cost': cost,
           'quantity': quantity,
         });
         try{
            //response 是由後端回應的數據
            final response =await http.put(url,headers:headers,body: body);
            if(response.statusCode==200){
              SnackBarutils.showSnackBar(context, '商品更新成功', Colors.green);
              Navigator.pop(context);//回到menu
            }else if(response.statusCode==404){
               //商品不存在
              SnackBarutils.showSnackBar(context, '商品未找到', Colors.red);

            }else{
              //其他錯誤
              SnackBarutils.showSnackBar(context, '商品更新失败', Colors.red);

            }

         }catch(e){
           SnackBarutils.showSnackBar(context, '發生錯誤，稍後重試', Colors.red);
         }
    }
    //刪除商品
    static Future<bool>deleteProduct(BuildContext context, int productId) async {
      final url = Uri.parse('http://127.0.0.1:5000/delete_product/$productId');
      try {
        final response = await http.delete(
            url, headers: {'Content-Type': 'application/json'});
        if (response.statusCode == 200) {
          //刪除成功
          SnackBarutils.showSnackBar(context, '商品刪除成功', Colors.green);

          return true;
        } else if (response.statusCode == 404) {
          //商品未找到
          SnackBarutils.showSnackBar(context, '商品未找到', Colors.red);

          return false;
        } else {
          //其他錯誤
          SnackBarutils.showSnackBar(context, '商品刪除失敗', Colors.red);
          return false;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('發生錯誤，稍後重試')));
            return false;
      }
    }

    //載入商品資訊到客人頁面
   static Future<List<Map<String, dynamic>>> loadProductForClient(String userId) async {
        try{
              //發送get請求，並將userid作為查詢參數
              final response = await http.get(
                Uri.parse('http://127.0.0.1:5000/getprodctsinClient/?user_id=$userId'),
              );

              if(response.statusCode==200){
                  List<dynamic>products = json.decode(response.body);

                  List<Map<String, dynamic>> productList = products.map((product) {
                    return {
                      'product_id':product['product_id'],//正確傳遞productid提供saveorder使用
                      'name': product['name'],
                      'price': product['price'],
                      'image': product['image'],
                      'type': product['type'], // 如果需要展示商品类型，可以保留这个字段
                    };
                  }).toList();
                  //將所有type暫存
                  List<String> types = productList.map((product) => product['type'] as String).toSet().toList();
                  await StorageHelper.saveDBtype(types);
                  //按type 分類並暫存
                  Map<String, List<Map<String, dynamic>>> productsByType = {};
                  for (var product in productList) {
                    String type = product['type'];
                    if (!productsByType.containsKey(type)) {
                      productsByType[type] = []; // 使用變量type
                    }
                    productsByType[type]!.add({'name': product['name'], 'price': product['price']});
                  }
                  await StorageHelper.saveProductsByType(productsByType);
                  Map<String, List<Map<String, dynamic>>> savedProductsByType = await StorageHelper.getProductsByType();
                  print('已存储的商品信息: $savedProductsByType');
                  return productList;
              } else {
                print('Failed to load products. Status code: ${response.statusCode}');
                return [];
              }
        } catch (e) {
          print('Error: $e');
          return [];
        }
   }

 }
