import 'package:flutter/material.dart';
import 'package:jkmapp/utils/diolog.dart';
import 'package:jkmapp/services/user/AuthenticationService.dart';
import 'package:jkmapp/utils/exception.dart' as custom_exceptions;
import 'package:jkmapp/routers/app_routes.dart';


class Register extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();

  Future<void> _register(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await _authService.register(email, password);
      showSucessDialog(
          context, '成功註冊','你已經成功註冊了!', onConfirmed: () {
        Navigator.pushNamed(context, Routers.Login);
      });
    }catch(e){
      if (e is custom_exceptions.AuthException) {
        showErrorDialog(context, e.message);
      }else if(e is custom_exceptions.ClientException){
        showErrorDialog(context, e.message);
      } else if (e is custom_exceptions.ServerException) {
        showErrorDialog(context, e.message);
      } else {
        showErrorDialog(context, '未知錯誤: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回到上一个页面
          },
        ),
      ),
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
                  '註冊',
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
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _register(context),
                  child: Text('註冊'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xD367FF7F),
                    foregroundColor: Colors.white,
                    minimumSize: Size(150, 50),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
