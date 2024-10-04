import 'package:flutter/material.dart';
import 'menu.dart';
import 'package:jkmapp/routers/app_routes.dart';
import 'package:jkmapp/utils/localStorage.dart';


class dining extends StatefulWidget {
  @override
  _DiningState createState() => _DiningState();
}


class _DiningState extends State<dining> {//和statefulwidget適配對，實際管理widget的狀態
  String? storeName;
  String? password;

  @override
  void initState(){//初始化
     super.initState();
     _loadData();
  }

  Future<void> _loadData() async {
    String? storedName = await StorageHelper.getStoreName();
    String? savedPassword = await StorageHelper.getPassword();

    setState(() {
      storeName = storedName;
      password = savedPassword;
    });
  }

  @override
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
                  Text( storeName ?? '店家', style: TextStyle(fontSize: 20)),
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
              onTap: () {
                Navigator.pushNamed(context, Routers.settingpage);
              },
             ),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('客人模式'),
              onTap: () {
                Navigator.pushNamed(context, Routers.Client);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('登出'),
              onTap: () {
                Navigator.pushNamed(context, Routers.Login);
              },
            ),
          ],
        ),
      ),
      body: MenuPage(),
    );
  }
}

