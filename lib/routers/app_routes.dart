import 'package:flutter/material.dart';
import 'package:jkmapp/widgets/First.dart';
import 'package:jkmapp/screens/user/Login.dart';
import 'package:jkmapp/screens/user/Forget1.dart';
import 'package:jkmapp/screens/user/Register.dart';
import 'package:jkmapp/screens/user/Forget2.dart';
import 'package:jkmapp/screens/user/Forget3.dart';
import 'package:jkmapp/screens/restaurant/dining.dart';
import 'package:jkmapp/screens/products/createmerchandise.dart';
import 'package:jkmapp/screens/restaurant/Setting/settingpage.dart';
import 'package:jkmapp/screens/products/productdetail.dart';
import 'package:jkmapp/screens/restaurant/menu.dart';
import 'package:jkmapp/screens/client/client.dart';
import 'package:jkmapp/screens/client/orderlistpage.dart';
import 'package:jkmapp/screens/restaurant/Order/userorderlist.dart';
import 'package:jkmapp/screens/restaurant/QA/restaurant_database.dart';
import 'package:jkmapp/screens/restaurant/QA/restaurant_qasytem.dart';
import 'package:jkmapp/screens/restaurant/QA/QA_unanswered.dart';
import 'package:jkmapp/screens/restaurant/Order/order_history.dart';
import 'package:jkmapp/screens/restaurant/Table/TableManagementPage.dart';
import 'package:jkmapp/screens/restaurant/Checkout/checkpage.dart';
import 'package:jkmapp/screens/restaurant/Checkout/RevenuePage.dart';


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
  static const String restaurant_database='/restaurant_database';
  static const String restaurant_qasytstem='/restaurant_qasytstem';
  static const String QA_unanswered='/UnansweredQuestions';
  static const String order_history='/Orderhistory';
  static const String TableManagementPage='/TableManagement';
  static const String CheckPage='/Checkpage';
  static const String RevenuePage='/Revenuepage';
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
      case Routers.dining:
        return MaterialPageRoute(builder: (_)=>dining());
      case Routers.createMerchandise:
        return MaterialPageRoute(builder: (_)=>CreateMerchandise());
      case Routers.menu:
        return MaterialPageRoute(builder: (_)=>MenuPage());
      case Routers.Client:
        final args=settings.arguments as String;
        return MaterialPageRoute(builder: (_)=>Client(tableNumber: args),);
      case Routers.settingpage:
        return MaterialPageRoute(builder: (_)=>SettingsPage(onSave: (){},));
      case Routers.orderlistpage:
        return MaterialPageRoute(builder: (_)=>Orderlistpage(),);
      case Routers.userorderlist:
        return MaterialPageRoute(builder: (_)=>UserOrderList());
      case Routers.productdetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_)=>ProductDetailPage(
           productId: args['product_id'],
          ),
        );
      case Routers.restaurant_database:
        return MaterialPageRoute(builder: (_)=>restaurantData());
      case Routers.restaurant_qasytstem:
        return MaterialPageRoute(builder: (_)=>RestaurantQASystem());
      case Routers.QA_unanswered:
        return MaterialPageRoute(builder: (_)=>UnansweredQuestionsPage());
      case Routers.order_history:
           return MaterialPageRoute(builder: (_)=>orderHistory());
      case Routers.TableManagementPage:
         return MaterialPageRoute(builder: (_)=>TableGeneratorPage());
      case Routers.CheckPage:
        return MaterialPageRoute(builder: (_)=>Checkpage());
      case Routers.RevenuePage:
        return MaterialPageRoute(builder: (_)=>RevenuePage());
      default:
        return null;
    }
  }
}