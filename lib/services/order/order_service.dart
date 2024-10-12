import'package:http/http.dart' as http;
import 'dart:convert';

class OrderService{
     static Future<bool> saveOrder(String tableNumber,List<Map<String, dynamic>> products,double totalAmount)async{
         final response =await http.post(
           Uri.parse('http://127.0.0.1:5000/saveorder'),
           headers: {'Content-Type':'application/json'},
           body: jsonEncode({
                'table':tableNumber,
                'products':products,
                'total_amount':totalAmount,
           }),
         );
         return response.statusCode==200;
     }

     static Future<List<dynamic>>getorderforclient(String tableNumber)async {
       try {
         final response = await http.get(
           Uri.parse('http://127.0.0.1:5000/getorderforclient/$tableNumber'),//使用路徑參數
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
}
