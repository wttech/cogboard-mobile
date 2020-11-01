import 'dart:convert';

import 'package:cogboardmobileapp/models/url_preferences_model.dart';

class SettingsPreferences {
  static const String KEY = 'SettingsPreferences';
  static const int VERSION = 1;

  List<ConnectionPreferences> connections = [];
  ConnectionPreferences currentConnection;
  String sortBy;
  bool showHints;
  int version;

  SettingsPreferences({this.connections, this.version, this.currentConnection, this.showHints, this.sortBy});

  factory SettingsPreferences.fromJson(Map<String, dynamic> json) => SettingsPreferences(
        connections:
            List<dynamic>.from(jsonDecode(json['connections'])).map((e) => ConnectionPreferences.fromJson(e)).toList(),
        version: json['version'],
        showHints: json['showHints'],
        sortBy: json['sortBy'],
        currentConnection:
            json['currentConnection'] != null ? ConnectionPreferences.fromJson(json['currentConnection']) : null,
      );

  Map<String, dynamic> toJson() {
    return {
      'connections': jsonEncode(connections.map((i) => i.toJson()).toList()).toString(),
      'version': version,
      'showHints': showHints,
      'sortBy': sortBy,
      'currentConnection': currentConnection != null ? currentConnection.toJson() : null,
    };
  }
}
