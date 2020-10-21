import 'package:flutter/material.dart';

class WidgetProvider with ChangeNotifier {
  String _widgetStatus;

  get widgetStatus => _widgetStatus;

  void setWidgetStatus(String widgetStatus) {
    _widgetStatus = widgetStatus;
    notifyListeners();
  }
}