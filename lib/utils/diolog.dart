import 'package:flutter/material.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'SnackBar.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
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

void showSucessDialog(BuildContext context, String title, String message, {required VoidCallback onConfirmed}){
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text('登入成功'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text('確定'),
          onPressed: () {
            Navigator.of(ctx).pop();
            onConfirmed();
          },
        ),
      ],
    ),
  );
}


Future<void> showPasswordDialog(BuildContext context,TextEditingController passwordController, VoidCallback onPasswordCorrect)async{
  //獲取保存的密碼
  String? savePassword=await StorageHelper.getPassword();
  showDialog(
      context: context,
      builder:(BuildContext context){
        return AlertDialog(
           title:const Text(
             '輸入後臺密碼',
                 style:TextStyle(color:Colors.red),
           ),
          backgroundColor: Colors.white,
          content:Container(
             color:Colors.white,
             child:TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                   hintText: '密碼',
                ),
             ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 關閉對話框
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                // 檢查密碼是否正確
                if (passwordController.text == savePassword) {
                  Navigator.of(context).pop(); // 關閉對話框
                  SnackBarutils.showSnackBar( context,'密碼正確，進入後台設定',Colors.green);
                  onPasswordCorrect();
                } else {
                  SnackBarutils.showSnackBar( context,'密碼錯誤',Colors.red);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('輸入'),
            ),
          ],
        );
      },
  );
}

