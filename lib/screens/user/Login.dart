import 'package:flutter/material.dart';
import 'package:jkmapp/utils/exception.dart';
import 'package:jkmapp/services/user/AuthenticationService.dart';
import 'package:jkmapp/utils/diolog.dart';
import 'package:jkmapp/routers/app_routes.dart';



class  Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final authService = AuthenticationService();

    //發送登入請求
    try {
      await authService.login(email, password);
      Navigator.pushNamed(context, Routers.dining);
    }catch (e) {
      if(e is ClientException) {
        showErrorDialog(context, e.message);
      }
      else if (e is AuthException) {
        showErrorDialog(context, e.message);
      } else if (e is ServerException) {
        showErrorDialog(context, '伺服器錯誤');
      }else{
        showErrorDialog(context,'未知錯誤:${e.toString()}');
      }
    }
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
                      onPressed: ()  {Navigator.pushNamed(context,Routers.register);},
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
                      Navigator.pushNamed(context, Routers.forget1);
                    },
                    child: Text(
                      '忘記密碼?',
                      style: TextStyle(
                        color: Colors.black12,
                        decoration: TextDecoration.underline,
                      )
                    ),
                  ),
                ),
            ]
          ),
        ),
      ]
      )
    );
  }
}
