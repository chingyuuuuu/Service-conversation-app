import'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jkmapp/utils/localStorage.dart';

/*優化:加載訂單到業者和客人的界面url可以是同一個*/
class OrderService{
     //儲存訂單
     static Future<bool> saveOrder(String tableNumber,List<Map<String,dynamic>> products,double totalAmount,remark)async{
         String? userId=await StorageHelper.getUserId();
         final response =await http.post(
           Uri.parse('http://127.0.0.1:5000/saveorder'),
           headers: {'Content-Type':'application/json'},
           body: jsonEncode({
                'table':tableNumber,
                'products':products,
                'total_amount':totalAmount,
                'user_id':userId,
                'remark':remark,
           }),
         );
         return response.statusCode==200;
     }

     //加載訂單資訊到客人介面
     static Future<List<dynamic>>getorderforclient(String tableNumber)async {
       try {
         final response = await http.get(
           Uri.parse('http://127.0.0.1:5000/getorderforclient/$tableNumber'),
           headers: {'Content-Type': 'application/json'},
         );
         if (response.statusCode == 200) {
           final data = json.decode(response.body); //傳回訂單數據
           return data['orders'];//從後端數據提取表單
         } else if(response.statusCode==404){
           throw Exception('尚未加入訂單');
         }else if(response.statusCode==500){
             throw Exception('網路錯誤，請稍後再試');
         }else{
            throw Exception('無法加載訂單，未知錯誤');
         }
       } catch (e) {
         throw Exception('Error:$e');
       }
     }

     //商品詳細資訊
     static Future<Map<String, dynamic>> fetchOrderDetails(int orderId) async {
       final response = await http.get(
         Uri.parse('http://127.0.0.1:5000/getorderdetail/$orderId'),
         headers: {'Content-Type': 'application/json'},
       );
       if (response.statusCode == 200) {
         return json.decode(response.body);  // 解析訂單詳情
       } else {
         throw Exception('Failed to load order details');
       }
     }

     //加載訂單到業者界面
     static Future<List<dynamic>>getorder(String? userId)async {
       try {
         final response = await http.get(
           Uri.parse('http://127.0.0.1:5000/getorder/$userId'),
           headers: {'Content-Type': 'application/json'},
         );
         if (response.statusCode == 200) {
           final data = json.decode(response.body); //傳回訂單數據
           return data;//從後端數據提取表單
         } else if(response.statusCode==404){
           throw Exception('尚未加入訂單');
         }else if(response.statusCode==500){
           throw Exception('網路錯誤，請稍後再試');
         }else{
           throw Exception('無法加載訂單，未知錯誤');
         }
       } catch (e) {
         throw Exception('Error:$e');
       }
     }

     //根據日期去調用訂單
     static Future<List<dynamic>> fetchOrdersByDate(String? userId, {String? date}) async {
       try{
           String url='http://127.0.0.1:5000/getdayorder/$userId';
           if(date!=null){
             url+'date=$date';
           }
           final response =await http.get(
             Uri.parse(url),//使用路徑參數
             headers: {'Content-Type': 'application/json'},
         );
         if (response.statusCode == 200) {
             final data = json.decode(response.body); //傳回訂單數據
             return data;//從後端數據提取表單
         } else if(response.statusCode==404){
             throw Exception('尚未加入訂單');
         }else if(response.statusCode==500){
             throw Exception('網路錯誤，請稍後再試');
         }else{
             throw Exception('無法加載訂單，未知錯誤');
         }
       } catch (e) {
             throw Exception('Error:$e');
         }
       }

     //業者可以點選結帳按鈕去更新訂單狀態
     static Future<bool> updateOrderCheckStatus(int orderId, bool isChecked) async {
       final response = await http.put(
         Uri.parse('http://127.0.0.1:5000/updateorder/$orderId'),
         headers: {'Content-Type': 'application/json'},
         body: jsonEncode({'check': isChecked}),
       );
       return response.statusCode == 200;
     }
}
