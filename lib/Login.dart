import 'package:flutter/material.dart';
import 'Forget1.dart';
import 'Choose.dart';
import 'Register.dart';
import 'dart:convert';
import 'package:dio/dio.dart';//用於發送網路請求
import 'package:shared_preferences/shared_preferences.dart';




class  Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    var dio = Dio();

    try {
      final response = await dio.post(
        'http://127.0.0.1:5000/login',
        options: Options(
          headers: {'Content-type': 'application/json'},
        ),
        data: json.encode({'account': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        //獲取uesr_id
         String userId = response.data['user_id'];

        //暫存user_id
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userId);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Choose()),
        );
      } else {
        final responseData = json.decode(response.data);
        _showErrorDialog(context, responseData['message']);
      }
    } catch (e) {
      print('Error occurred: $e');
      _showErrorDialog(context, '帳號密碼未輸入');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('登入失敗'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('確定'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
  void _register(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Center(
              child: Text(
                'Service',
                style: TextStyle(
                  fontSize: 120,
                  fontFamily: 'Kapakana',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF223888),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '登入',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: UnderlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => _register(context),
                      child: Text('註冊'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(150, 50),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    ElevatedButton(
                      onPressed: () => _login(context),
                      child: Text('登入'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF36FDE6),
                        foregroundColor: Colors.black,
                        minimumSize: Size(150, 50),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(right: 50.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Forget1()),
                      );
                    },
                    child: Text(
                      '忘記密碼?',
                      style: TextStyle(
                        color: Colors.black12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
