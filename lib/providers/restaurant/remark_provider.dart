import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:jkmapp/utils/localStorage.dart';

class RemarkProvider extends ChangeNotifier{
     bool _isRemarkEnabled=false;//初始化關閉

     bool get isRemarkEnabled =>_isRemarkEnabled;
     void setRemarkEnabled(bool value){
        _isRemarkEnabled=value;
        notifyListeners();
     }
     //從本地加載狀態
     Future<void>loadRemarkStatus()async{
       _isRemarkEnabled = await StorageHelper.loadRemarkEnabled() ?? false;
       notifyListeners();
     }
     //保存狀態到暫存
     Future<void>saveRemarkStatus(bool value)async{
        _isRemarkEnabled=value;
        await StorageHelper.saveRemarkEnabled(value);
     }
}