import 'package:flutter/material.dart';
import 'package:jkmapp/First.dart';
import 'package:jkmapp/Login.dart';
import 'package:jkmapp/Forget1.dart';
import 'package:jkmapp/Choose.dart';
import 'package:jkmapp/Register.dart';
import 'package:jkmapp/Forget2.dart';
import 'package:jkmapp/Forget3.dart';
import 'package:jkmapp/dining.dart';
import 'package:jkmapp/createmerchandise.dart';
import 'package:jkmapp/settingpage.dart';
import 'package:jkmapp/productdetail.dart';
import 'package:jkmapp/menu.dart';
import 'package:jkmapp/client.dart';


class Routers{
  static const String first ='/First';
  static const String Login ='/Login';
  static const String forget1 ='/forget1';
  static const String choose ='/Choose';
  static const String register = '/Register';
  static const String forget2 = '/Forget2';
  static const String forget3 = '/Forget3';
  static const String dining = '/Dining';
  static const String settingpage ='/ProductDetailPage';
  static const String createMerchandise = '/Createmerchandise';
  static const String productdetail = '/Productdetail';
  static const String menu = '/Menu';
  static const String Client = '/Client';

}

class RouteGenerator{
  static Route<dynamic>? generateRoute(RouteSettings settings){
    print('Navigating to: ${settings.name}');
    switch (settings.name){
      case Routers.first:
        return MaterialPageRoute(builder: (_)=>First());//要和類名同
      case Routers.Login:
        return MaterialPageRoute(builder: (_)=>Login());
      case Routers.forget1:
        return MaterialPageRoute(builder: (_)=>Forget1());
      case Routers.register:
        return MaterialPageRoute(builder: (_)=>Register());
      case Routers.forget2:
        return MaterialPageRoute(builder: (_)=>Forget2());
      case Routers.forget3:
        return MaterialPageRoute(builder: (_)=>Forget3());
      case Routers.choose:
        return MaterialPageRoute(builder: (_)=>Choose());
      case Routers.dining:
        return MaterialPageRoute(builder: (_)=>dining());
      case Routers.createMerchandise:
        return MaterialPageRoute(builder: (_)=>CreateMerchandise());
      case Routers.menu:
        return MaterialPageRoute(builder: (_)=>MenuPage());
      case Routers.Client:
        return MaterialPageRoute(builder: (_)=>Client());
      case Routers.settingpage:
        return MaterialPageRoute(builder: (_)=>SettingsPage(onSave: (){},));
      case Routers.productdetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_)=>ProductDetailPage(
           productId: args['product_id'],
          ),
        );
      default:
        return null;
    }
  }
}