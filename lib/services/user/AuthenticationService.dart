import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jkmapp/utils/exception.dart';

class AuthenticationService {
  final Dio _dio = Dio();
  //登入
  Future<String> login(String email, String password) async {
    final response = await _dio.post(
      'http://127.0.0.1:5000/login',
      options: Options(
        headers: {'Content-type': 'application/json'},
      ),
      data: json.encode({'account': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // 獲取user_id
      String userId = response.data['user_id'];
      //暫存
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
      return userId;
    }
    else if (response.statusCode == 401) {
      throw AuthException("Unauthorized. Please check your login details.");
    }
    else if (response.statusCode == 500) {
      throw ServerException("System error.");
    } else {
      throw Exception('Failed in unknown reason');
    }
  }

  //註冊
  Future<String> register(String email,String password)async{
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/register'),
          headers:{'Content-Type':'application/json'},
          body: json.encode({
          'account': email,
          'password': password,
          }),
      );
      if(response.statusCode == 200|| response.statusCode == 201){
         return 'Register successful';
      }else if(response.statusCode == 400){
          throw ClientException('No data provided');
      }else if(response.statusCode ==500){
        throw ServerException('System error.');
      }else{
         final reponseData = json.decode(response.body);
         throw Exception(reponseData['message']?? 'Unkown error');
      }
  }
}