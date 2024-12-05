import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  bool _serviceBellPressed = false;

  bool get serviceBellPressed => _serviceBellPressed;

  void pressServiceBell() {
    _serviceBellPressed = true;
    notifyListeners();
  }

  void resetServiceBell() {
    _serviceBellPressed = false;
    notifyListeners();
  }
}