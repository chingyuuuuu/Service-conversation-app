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


class MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>>_addedProducts = [];//儲存多個商品訊息

  Future<void> _navigateToCreateMerchandise() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateMerchandise())
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        //將商品資訊放入列表中
        _addedProducts.add({
          'name': result['name'],
          'image': result['image'] != null ? File(result['image']) : null,
        });
      });
    }
  }

  void _navigateToProductDetail(Map<String, dynamic> product, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product, index: index),
      ),
    );

    if (result != null && result == 'delete') {
      setState(() {
        _addedProducts.removeAt(index);  // 刪除商品
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //基礎的布局結構
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("菜單"),
        backgroundColor: Color(0x179E9E9E),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer(); //打開側邊欄
          },
        ),
      ),
      body: _addedProducts.isEmpty
          ? Center(child: Text("尚未加入商品"))
          : GridView.builder(//用來生成網格
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 每行顯示兩個商品
          crossAxisSpacing: 10.0, // 方框之間的水平間距
          mainAxisSpacing: 10.0, // 方框之間的垂直間距
          childAspectRatio: 0.8, // 控制圖片與文字的比例
        ),
        itemCount: _addedProducts.length,//生成圖片顯示元素
        itemBuilder: (context, index) {
          final product = _addedProducts[index];
          return GestureDetector(
            onTap:(){
                 _navigateToProductDetail(product,index);
          },
          child: Column(
            children: [
              // 顯示圖片（如果有）
              product['image'] != null
                  ? Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                  child: Image.file(
                    product['image'],
                      fit: BoxFit.cover, // 圖片填充方式
                    ),
                  )
                  : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
              SizedBox(height: 5),
              // 顯示名稱
              Text(
                product['name'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis, // 當名稱過長時省略
                textAlign: TextAlign.center,
              ),
            ],
           ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateMerchandise,
        backgroundColor: Colors.white,
        child: Icon(
            Icons.add,
            color:Colors.black,
        ),
      ),
    );
  }
}


class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final int index;

  ProductDetailPage({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品詳情'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顯示圖片
            product['image'] != null
                ? Image.file(
              product['image'],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            )
                : Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: Icon(Icons.image, size: 100, color: Colors.grey),
            ),
            SizedBox(height: 20),
            // 顯示名稱
            Text(
              '名稱: ${product['name']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // 顯示刪除按鈕
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, 'delete');  // 返回上一頁並通知刪除
              },
              icon: Icon(Icons.delete),
              label: Text('刪除商品'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}