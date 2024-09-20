import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
                  MaterialPageRoute(builder: (context) => CreateMerchandise()),
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

class CreateMerchandise extends StatefulWidget {
  @override
  CreateMerchandiseState createState() => CreateMerchandiseState();
}

class CreateMerchandiseState extends State<CreateMerchandise>  {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  File? _selectedImage; // 用于存储选择的图片文件
  final ImagePicker _picker = ImagePicker(); // 初始化 image picker

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // 存储图片路径
      });
    }
  }

  void saveProduct() async { // 儲存商品資訊
    String name = _nameController.text;
    String type = _typeController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("名稱未輸入！"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if(_priceController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("價格未輸入！"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    double price;
    double cost;
    int quantity;
    try {
      price = double.parse(_priceController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("價格格式不正確！"),
          duration: Duration(seconds: 2),
        ),
      );
      return; // 结束函数执行
    }

    // 尝试解析成本
    try {
      cost = double.parse(_costController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("成本格式不正確！"),
          duration: Duration(seconds: 2),
        ),
      );
      return; // 结束函数执行
    }

    // 尝试解析数量
    try {
      quantity = int.parse(_quantityController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("庫存量格式不正確！"),
          duration: Duration(seconds: 2),
        ),
      );
      return; // 结束函数执行
    }
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:5000/uploadproducts'),
    );

    // 加入請求的資訊
    request.fields['name'] = name;
    request.fields['type'] = type;
    request.fields['price'] = price.toString();
    request.fields['cost'] = cost.toString();
    request.fields['quantity'] = quantity.toString();

    // 如果有選擇圖片，則加入圖片路徑
    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _selectedImage!.path,
      ));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Product saved successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("儲存成功！"),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } else {
      print("Failed to save product");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("儲存失敗！"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

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
          controller: _nameController,
          decoration: InputDecoration(
                labelText: '名稱',
              ),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: '種類',
              ),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: '價格',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _costController,
              decoration: InputDecoration(
                labelText: '成本',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: '庫存量',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _pickImage(); // 选择图片
                },
                child: Row(
                  children: [
                    Icon(Icons.photo),
                    SizedBox(width: 10),
                    Text(_selectedImage != null ? '已選擇圖片' : '圖片'), // 显示是否选择了图片
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                     saveProduct();
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