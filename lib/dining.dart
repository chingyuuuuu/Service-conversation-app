import 'package:flutter/material.dart';
import 'package:jkmapp/menu.dart';
import 'package:jkmapp/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settingpage.dart';
import 'createmerchandise.dart';
import 'dart:io';



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
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,//確保內容緊貼邊框
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
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

class MenuPage extends StatefulWidget{
   @override
  MenuPageState createState()=>MenuPageState();
}


class MenuPageState extends State<MenuPage> {//菜單
  String? _addedProductName;
  File? _addedProductImage;
  //處理返回的商品資訊
  Future<void>_navigateToCreateMerchandise() async{
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>CreateMerchandise())
    );
    if(result!=null&&result is Map<String,dynamic>){
      setState(() {
        _addedProductName =result['name'];
        //將圖片path轉換成file
        if(result['image']!=null){
          _addedProductImage = File(result['image']);
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(//基礎的布局結構
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("菜單"),
        backgroundColor: Color(0x179E9E9E),
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
            SizedBox(height: 20),
            if(_addedProductImage !=null)
              Column(
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(right:10),
                    child: Image.file(_addedProductImage!),
                  ),
                  Text(
                    _addedProductName ?? '',
                    style: TextStyle(fontSize:16),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                   onTap: _navigateToCreateMerchandise,
                   child: Text(
                      '加入你的商品',
                      textAlign:TextAlign.center,
                      style: TextStyle(fontSize:20,color:Colors.black),
                   ),
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

