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
}
