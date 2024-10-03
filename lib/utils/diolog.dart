import 'package:flutter/material.dart';


void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text('登入失敗'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text('確定'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
      ],
    ),
  );
}

void showSucessDialog(BuildContext context, String title, String message, {required VoidCallback onConfirmed}){
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text('登入成功'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text('確定'),
          onPressed: () {
            Navigator.of(ctx).pop();
            onConfirmed();
          },
        ),
      ],
    ),
  );
}
