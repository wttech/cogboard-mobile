import 'dart:convert';

import 'package:cogboardmobileapp/models/url_preferences_model.dart';

class SettingsPreferences {
  static const String KEY = 'SettingsPreferences';
  static const int VERSION = 2;

  List<ConnectionPreferences> connections = [];
  ConnectionPreferences currentConnection;
  String sortBy;
  bool showHints;
  DateTime lastNotificationTimestamp;
  bool showNotifications;
  int notificationFrequencyInMinutes;
  int version;

  SettingsPreferences(
      {this.connections,
      this.version,
      this.currentConnection,
      this.showHints,
      this.sortBy,
      this.lastNotificationTimestamp,
      this.showNotifications,
      this.notificationFrequencyInMinutes});

  factory SettingsPreferences.fromJson(Map<String, dynamic> json) => SettingsPreferences(
        connections:
            List<dynamic>.from(jsonDecode(json['connections'])).map((e) => ConnectionPreferences.fromJson(e)).toList(),
        version: json['version'],
        showHints: json['showHints'],
        lastNotificationTimestamp:
            (json['lastNotificationTimestamp'] != "null" && json['lastNotificationTimestamp'] != null)
                ? DateTime.parse(json['lastNotificationTimestamp'])
                : null,
        showNotifications: json['showNotifications'],
        notificationFrequencyInMinutes: json['notificationFrequencyInMinutes'],
        sortBy: json['sortBy'],
        currentConnection:
            json['currentConnection'] != null ? ConnectionPreferences.fromJson(json['currentConnection']) : null,
      );

  Map<String, dynamic> toJson() {
    return {
      'connections': jsonEncode(connections.map((i) => i.toJson()).toList()).toString(),
      'version': version,
      'showHints': showHints,
      'lastNotificationTimestamp': lastNotificationTimestamp.toString(),
      'showNotifications': showNotifications,
      'notificationFrequencyInMinutes': notificationFrequencyInMinutes,
      'sortBy': sortBy,
      'currentConnection': currentConnection != null ? currentConnection.toJson() : null,
    };
  }
}
