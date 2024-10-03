import 'package:flutter/material.dart';
import 'package:jkmapp/routers/app_routes.dart';

class First extends StatelessWidget{
      @override
      Widget build(BuildContext context){
        Future.delayed(Duration(seconds:3),(){
            Navigator.pushReplacementNamed(context,Routers.Login);
        });
        return Scaffold(
          backgroundColor: Color(0xFF223888),
          body: Center(
            child:Text(
              'Service',
              style: TextStyle(
                 color:Colors.white,
                 fontFamily: 'Kapakana',
                 fontSize:120,
                 fontWeight:FontWeight.bold,
            ),
          ),
        ),
        );
      }
}

