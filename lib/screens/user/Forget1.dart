import 'package:flutter/material.dart';
import 'dart:convert'; //用於解析json數據
import 'package:jkmapp/utils/localStorage.dart';
import 'package:jkmapp/routers/app_routes.dart';
import 'package:jkmapp/services/user/AuthenticationService.dart';


class Forget1 extends StatefulWidget {
  @override
  _Forget1State createState() => _Forget1State();
}

class _Forget1State extends State<Forget1> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSending = false;
  String _message = '';

  Future<void> _storeEmail(String email) async {
    await StorageHelper.saveEmail(email);
  }

  Future<void> _sendResetCode() async {
    final email = _emailController.text;

    if (email.isEmpty) {
      setState(() {
        _message = 'Email is required';
      });
      return;
    }

    setState(() {
      _isSending = true;
      _message = '';
    });

    final response = await AuthenticationService.sendResetCode(email);

    setState(() {
      _isSending = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        _message = 'Reset code sent successfully!';
      });
      await _storeEmail(email); // Store email

      Navigator.pushNamed(context,Routers.forget2);
    } else {
      final responseData = jsonDecode(response.body);
      setState(() {
        _message = 'Failed to send reset code: ${responseData['message']}';
      });
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '驗證',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _sendResetCode,
                    child: _isSending ? CircularProgressIndicator() : Text('確認'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF36FDE6),
                      foregroundColor: Colors.white,
                      minimumSize: Size(80, 50),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                if (_message.isNotEmpty)
                  Center(
                    child: Text(
                      _message,
                      style: TextStyle(
                        color: _message.startsWith('Failed') ? Colors.red : Colors.green,
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