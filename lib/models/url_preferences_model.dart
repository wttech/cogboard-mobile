import 'dart:convert';

import 'package:cogboardmobileapp/models/widget_model.dart';

class UrlPreferences {
  List<DashboardWidget> favouriteWidgets = [];
  List<DashboardWidget> quarantineWidgets = [];

  UrlPreferences({this.favouriteWidgets, this.quarantineWidgets});

  factory UrlPreferences.fromJson(Map<String, dynamic> json) => UrlPreferences(
    favouriteWidgets: List<dynamic>.from(jsonDecode(json['favouriteWidgets'])).map((e) => DashboardWidget.fromJson(e)).toList(),
    quarantineWidgets: List<dynamic>.from(jsonDecode(json['quarantineWidgets'])).map((e) => DashboardWidget.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() {
    return {
      'favouriteWidgets': jsonEncode(favouriteWidgets.map((i) => i.toJson()).toList()).toString(),
      'quarantineWidgets': jsonEncode(quarantineWidgets.map((i) => i.toJson()).toList()).toString(),
    };
  }
}
