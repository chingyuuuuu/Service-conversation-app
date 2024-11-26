import 'package:flutter/material.dart';

class SnackBarutils{
  static void showSnackBar(BuildContext context,String message,Color color){
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
             backgroundColor:Colors.white,
             content:Text(message,style: TextStyle(color:color)),
             duration:Duration(seconds: 2),
         ),
    );
   }
}