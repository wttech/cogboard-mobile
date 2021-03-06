import 'dart:convert';

import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/url_preferences_model.dart';

class SettingsPreferences {
  static const String KEY = 'SettingsPreferences';
  static const int VERSION = 8;

  List<ConnectionPreferences> connections = [];
  ConnectionPreferences currentConnection;
  String sortBy;
  bool showHints;
  DateTime lastNotificationTimestamp;
  bool showNotifications;
  int notificationFrequencyInMinutes;
  Map<String, bool> hints;
  int version;
  String sortByKey;
  String sortByOrder;

  SettingsPreferences({
    this.connections,
    this.version,
    this.currentConnection,
    this.showHints,
    this.sortBy,
    this.lastNotificationTimestamp,
    this.showNotifications,
    this.hints,
    this.notificationFrequencyInMinutes,
    this.sortByKey,
    this.sortByOrder,
  });

  factory SettingsPreferences.fromJson(Map<String, dynamic> json) => SettingsPreferences(
        version: json['version'],
        connections:
            List<dynamic>.from(jsonDecode(json['connections'])).map((e) => ConnectionPreferences.fromJson(e)).toList(),
        currentConnection:
            json['currentConnection'] != null ? ConnectionPreferences.fromJson(json['currentConnection']) : null,
        hints: ((json['hints']) as Map<String, dynamic>).map((key, value) => MapEntry(key.toString(), value)),
        showHints: json['showHints'],
        lastNotificationTimestamp:
            (json['lastNotificationTimestamp'] != "null" && json['lastNotificationTimestamp'] != null)
                ? DateTime.parse(json['lastNotificationTimestamp'])
                : null,
        showNotifications: json['showNotifications'],
        notificationFrequencyInMinutes: json['notificationFrequencyInMinutes'],
        sortBy: json['sortBy'],
        sortByKey: json['sortByKey'],
        sortByOrder: json['sortByOrder'],
      );

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'connections': jsonEncode(connections.map((i) => i.toJson()).toList()).toString(),
      'currentConnection': currentConnection != null ? currentConnection.toJson() : null,
      'hints': hints,
      'showHints': showHints,
      'lastNotificationTimestamp': lastNotificationTimestamp.toString(),
      'showNotifications': showNotifications,
      'notificationFrequencyInMinutes': notificationFrequencyInMinutes,
      'sortBy': sortBy,
      'sortByKey': sortByKey,
      'sortByOrder': sortByOrder,
    };
  }

  static int readVersion(Map<String, dynamic> json) {
    return json['version'];
  }

  static Map<String, bool> createHints() {
    return {
      Hints.REFRESH_FETCHING_CONFIG: true,
      Hints.SWIPE_BOARDS: true,
      Hints.SWIPE_WIDGET_DETAILS: true,
      Hints.SWIPE_TO_DELETE: true
    };
  }
}
