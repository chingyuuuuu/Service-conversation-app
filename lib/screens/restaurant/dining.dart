import 'package:flutter/material.dart';
import 'menu.dart';
import 'package:jkmapp/routers/app_routes.dart';
import 'package:jkmapp/utils/localStorage.dart';
import'package:jkmapp/providers/Notification_Provider.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/utils/SnackBar.dart';
import 'package:jkmapp/providers/order_provider.dart';
import 'package:jkmapp/screens/client/client.dart';


class dining extends StatefulWidget {
  @override
  _DiningState createState() => _DiningState();
}


class _DiningState extends State<dining> {//和statefulwidget適配對，實際管理widget的狀態
  String? storeName;
  String? password;
  String? userId;
  @override
  void initState(){//初始化
     super.initState();
     _loadData();
  }

  Future<void> _loadData() async {
    String? storedName = await StorageHelper.getStoreName();
    String? savedPassword = await StorageHelper.getPassword();
    String? userId= await StorageHelper.getUserId();
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
              leading: Icon(Icons.assignment),
              title: Text('訂單'),
              onTap: () {
                Provider.of<OrderProvider>(context,listen: false).getallorders(userId, context);
                Navigator.pushNamed(context,Routers.userorderlist);
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
                Navigator.pushNamed(
                    context, Routers.Client,
                    arguments: 'A1',
                );
              },
            ),
            ListTile(
              leading:Icon(Icons.storage),
              title:Text('問答資料庫'),
              onTap:(){
                 Navigator.pushNamed(context, Routers.restaurant_database);
              },
            ),
            ListTile(
               leading: Icon(Icons.table_bar),
               title:Text('生成桌號'),
               onTap:(){
                  Navigator.pushNamed(context,Routers.TableManagementPage);
               },
            ),
            ListTile(
              leading: Icon(Icons.price_check_sharp),
              title:Text('結帳'),
              onTap:(){
                Navigator.pushNamed(context,Routers.CheckPage);
              },
            ),
            const SizedBox(height:30),
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
      body: Column(
        children: [
          Expanded(child: MenuPage()),
          // 使用 Consumer 监听服务铃状态
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              if (notificationProvider.serviceBellPressed) {
                WidgetsBinding.instance.addPostFrameCallback((_) {//在build 完成後顯示
                  SnackBarutils.showSnackBar(context, '按下服務鈴', Colors.red);

                  // 重置服務鈴狀態
                  notificationProvider.resetServiceBell();
                });
              }

              return Container(); // 這裡可以返回其他 UI 組件
            },
          ),
        ],
      ),
    );
  }
}