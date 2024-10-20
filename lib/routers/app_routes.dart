import 'package:flutter/material.dart';
import 'package:jkmapp/widgets/First.dart';
import 'package:jkmapp/screens/user/Login.dart';
import 'package:jkmapp/screens/user/Forget1.dart';
import 'package:jkmapp/screens/user/Choose.dart';
import 'package:jkmapp/screens/user/Register.dart';
import 'package:jkmapp/screens/user/Forget2.dart';
import 'package:jkmapp/screens/user/Forget3.dart';
import 'package:jkmapp/screens/restaurant/dining.dart';
import 'package:jkmapp/screens/products/createmerchandise.dart';
import 'package:jkmapp/screens/restaurant/settingpage.dart';
import 'package:jkmapp/screens/products/productdetail.dart';
import 'package:jkmapp/screens/restaurant/menu.dart';
import 'package:jkmapp/screens/client/client.dart';
import 'package:jkmapp/screens/client/orderlistpage.dart';
import 'package:jkmapp/screens/restaurant/userorderlist.dart';
import 'package:jkmapp/screens/customer service system/customer.dart';
import 'package:jkmapp/screens/customer service system/customer_data.dart';


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
  static const String orderlistpage='/Orderlistpage';
  static const String userorderlist='/userorderlist';
  static const String customer='/Customer';
  static const String customer_data='/Customer_data';

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
      case Routers.orderlistpage:
        return MaterialPageRoute(builder: (_)=>Orderlistpage());
      case Routers.userorderlist:
        return MaterialPageRoute(builder: (_)=>Userorderlist());
      case Routers.productdetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_)=>ProductDetailPage(
           productId: args['product_id'],
          ),
        );
      case Routers.customer:
        return MaterialPageRoute(builder: (_)=>Customer());
      case Routers.customer_data:
        return MaterialPageRoute(builder: (_)=>CustomerData());
      default:
        return null;
    }
  }
}