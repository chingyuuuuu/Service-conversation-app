import 'package:flutter/material.dart';
import 'package:jkmapp/client.dart';
import 'package:jkmapp/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settingpage.dart';
import 'menu.dart';


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

