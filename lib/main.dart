import 'package:flutter/material.dart';
import 'package:jkmapp/providers/Notification_Provider.dart';
import 'package:jkmapp/providers/QA_provider.dart';
import 'package:jkmapp/providers/order_provider.dart';
import 'package:jkmapp/routers/app_routes.dart';
import 'package:jkmapp/services/api_service.dart';
import 'package:jkmapp/providers/remark_provider.dart';
import 'package:jkmapp/providers/Speech_provider.dart';
import 'providers/cart_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider
          (create: (_) => CartProvider()//提供購物車的狀態
        ),
        ChangeNotifierProvider(create: (_)=>NotificationProvider()
        ),
        ChangeNotifierProvider(create: (_)=>OrderProvider()
        ),
        ChangeNotifierProvider(create: (_)=>QAprovider()
        ),
        ChangeNotifierProvider(create: (_)=>RemarkProvider()
        ),
        ChangeNotifierProvider(create: (_)=>SpeechProvider()
        ),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color:Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: Routers.first,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class DataWidget extends StatefulWidget {
  @override
  _DataWidgetState createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  Future<Map<String, dynamic>>? _data;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _data= _apiService.fetchData();//調用api獲取數據
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(//用於存取從flask 獲取的數據
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text('Message: ${snapshot.data!['message']}');
        }
      },
    );
  }
}


