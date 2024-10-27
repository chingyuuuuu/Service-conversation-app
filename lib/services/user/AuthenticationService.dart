import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jkmapp/utils/exception.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:jkmapp/routers/app_routes.dart';


class AuthenticationService {
  //登入
  Future<String> login(String email, String password) async {
    final url = Uri.parse('http://127.0.0.1:5000/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'account': email, 'password': password}),
      );


      if (response.statusCode == 200) {
        // 獲取user_id
        final responseData = json.decode(response.body);
        String userId = responseData['user_id'];
        //暫存
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userId);
        return userId;
      } else if (response.statusCode == 400) {
        final responseData = json.decode(response.body);
        throw ClientException(responseData['message']);
      } else if (response.statusCode == 401) {
        final responseData = json.decode(response.body);
        throw AuthException(responseData['message']);
      } else if (response.statusCode == 500) {
        throw ServerException("System error.");
      } else {
        throw Exception(
            'Unknown error occurred with status code: ${response.statusCode}');
      }
    }


  //註冊
  Future<String> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'account': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
       return 'Register successful';
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      throw ClientException(responseData['message'] );
    } else if (response.statusCode == 500) {
      final responseData = json.decode(response.body);
      throw ServerException(responseData['message']);
    } else if(response.statusCode==409){
      final responseData = json.decode(response.body);
      throw AuthException(responseData['message']);
    } else {
      final responseData = json.decode(response.body);
      throw Exception( responseData['message'] ?? 'Unkown error');
    }
  }

  //忘記密碼
  static Future<http.Response>sendResetCode(String email) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/forget_password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response;
  }

}