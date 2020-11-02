import 'dart:convert';

import 'package:cogboardmobileapp/models/widget_model.dart';

class ConnectionPreferences {
  List<DashboardWidget> favouriteWidgets = [];
  List<DashboardWidget> quarantineWidgets = [];
  String connectionName;
  String connectionUrl;

  ConnectionPreferences({this.favouriteWidgets, this.quarantineWidgets, this.connectionName, this.connectionUrl});

  factory ConnectionPreferences.fromJson(Map<String, dynamic> json) => ConnectionPreferences(
    favouriteWidgets: List<dynamic>.from(jsonDecode(json['favouriteWidgets'])).map((e) => DashboardWidget.fromJson(e)).toList(),
    quarantineWidgets: List<dynamic>.from(jsonDecode(json['quarantineWidgets'])).map((e) => DashboardWidget.fromJson(e)).toList(),
    connectionName: json['connectionName'],
    connectionUrl: json['connectionUrl'],
      );

  Map<String, dynamic> toJson() {
    return {
      'favouriteWidgets': jsonEncode(favouriteWidgets.map((i) => i.toJson()).toList()).toString(),
      'quarantineWidgets': jsonEncode(quarantineWidgets.map((i) => i.toJson()).toList()).toString(),
      'connectionName': connectionName,
      'connectionUrl': connectionUrl,
    };
  }
}
