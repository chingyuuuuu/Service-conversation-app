import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jkmapp/utils/SnackBar.dart';


class ClientProvider {
    Future<void> showPasswordNotification(BuildContext context) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String savedPassword = prefs.getString('password') ?? '123456';
      SnackBarutils.showSnackBar(context,'後臺密碼是:$savedPassword',Colors.blue);
    }
}