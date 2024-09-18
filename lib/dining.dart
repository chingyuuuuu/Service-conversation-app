import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jkmapp/menu.dart';
import 'package:jkmapp/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';



class dining extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,//隱藏右上角的debug
      home:HomeScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget {//定義widget的外觀和行為
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {//和statefulwidget適配對，實際管理widget的狀態
  String storeName = 'default';
  @override
  void initState(){//初始化
     super.initState();
     _loadStoreName();
  }

  //從本地加載店家名稱
  void _loadStoreName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storeName = prefs.getString('storeName')??'店家';
    });
  }

  void _navigateToSettings() async {
    bool? updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          onSave: () {
            setState(() {
              //當設置頁面儲存，更新主畫面狀態
              _loadStoreName(); // 更新店家名稱
            });
          },
        ),
      ),
    );

    if (updated != null && updated) {
      _loadStoreName(); //更新
    }
  }



  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(//側邊欄位
        backgroundColor: Colors.grey[300],
        child: ListView(
          padding: EdgeInsets.zero,//確保內容緊貼邊框
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Row(
                children: [
                  Icon(Icons.person, size: 50),
                  SizedBox(width: 10),
                  Text(storeName, style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('訂單'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.menu),
              title: Text('菜單'),
              onTap: () {
                    Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('設定'),
              onTap: _navigateToSettings,
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('客人模式'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context)=>menu()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('登出'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>Login()),
                );
              },
            ),
          ],
        ),
      ),
      body: MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {//菜單
  @override
  Widget build(BuildContext context) {
    return Scaffold(//基礎的布局結構
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("菜單"),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();//打開側邊欄
          },
        ),
      ),
      body: Container(//創建商品
        alignment: Alignment.topLeft,
        padding: const  EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,//確保頂部對齊
          crossAxisAlignment: CrossAxisAlignment.start,//確保左側對齊
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateMerchandisePage()),
                );
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    '+',
                    style: TextStyle(fontSize: 50),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '加入你的商品',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderPage extends StatelessWidget {//訂單紀錄
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("訂單"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Navigator.pop(context); // 返回上一頁
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Color(0xFF223888),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '賺入',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'NT\$100',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: false, // 依實際情況修改
                  onChanged: (value) {
                    // 處理選擇狀態改變
                  },
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '數量',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreateMerchandisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Create merchandise"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回上一頁
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: '名稱',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: '種類',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: '價格',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: '成本',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: '庫存量',
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectPhotoPage()),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.photo),
                  SizedBox(width: 10),
                  Text("圖片"),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 儲存商品邏輯
              },
              child: Text('儲存'),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectPhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("選擇相片"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回上一頁
          },
        ),
      ),
      body: Center(
        child: Text("相片選擇頁面內容"),
      ),
    );
  }
}
class SettingsPage extends StatefulWidget{
  final VoidCallback onSave;//回調函數
  SettingsPage({required this.onSave});//接受回調函數

  @override
   SettingsPageState createState() =>SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  TextEditingController _storeNameController =TextEditingController();
  TextEditingController _passwordController =TextEditingController();

  String storeName = 'default';
  String password = '123456';

  @override
  void initState() {
    super.initState();
    _loadInitialValues();//加載保存的設置
  }

  void _loadInitialValues() async {//用於從sharedpreferences加載儲存的值
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _storeNameController.text = prefs.getString('storeName') ?? '店家';
    _passwordController.text = prefs.getString('password') ?? '123456';
  }
  //將店家名稱儲存到sharedpreferences(暫存)
  Future<void> _saveStoreName(String storeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('storeName', storeName);
  }

  Future<void> _savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("設定"),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black), // 更改圖標顏色以適應白色背景
          onPressed: () {
            Navigator.pop(context); // 返回上一頁
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFF223888),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 40),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _storeNameController, // 必須設置 controller
                      decoration: InputDecoration(
                        labelText: '店家名稱',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.password, size: 40),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: '後臺密碼',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {//保存更改的資料到本地
                  await  _saveStoreName(_storeNameController.text);//用await直到future完成並返回結果
                  await  _savePassword(_passwordController.text);
                  widget.onSave(); // 调用回调函数，通知已經保存完成
                  Navigator.pop(context,true);//使用這個來實現主頁和設定頁面同步
                },
                child: Text('儲存'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF36FDE6),
                  foregroundColor: Colors.black,
                  minimumSize: Size(150, 50),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}