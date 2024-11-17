import 'package:flutter/material.dart';
import 'package:jkmapp/providers/order_provider.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SnackBar.dart';
import 'package:provider/provider.dart';

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

Future<void> showPasswordNotification(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedPassword = prefs.getString('password') ?? '123456';
  SnackBarutils.showSnackBar(context,'後臺密碼是:$savedPassword',Colors.blue);
}


Future<void> showConfirmationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text('每日刷新',style: TextStyle(color:Colors.black),),
        content: Text('請問確定要刪除今天的訂單?此操作無法還原',style: TextStyle(color:Colors.red),),
        actions: [
          TextButton(
            child: Text('取消',style: TextStyle(color:Colors.grey),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('確定',style: TextStyle(color:Colors.black)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () async {
              Navigator.of(context).pop();
              final orderProvider = Provider.of<OrderProvider>(context, listen: false);
              bool success = await orderProvider.clearTodayOrder(context);
              if (success) {
                SnackBarutils.showSnackBar(context, "已刷新今日訂單", Colors.green);
              } else {
                SnackBarutils.showSnackBar(context, "刷新失敗", Colors.red);
              }
            },
          ),
        ],
      );
    },
  );
}
